require 'spec_helper'
# BookingStatusUncached and StateUncached models act as enumerated.
# All predefined booking statuses are in "add_booking_statuses" migration.
#
describe 'acts_as_enumerated' do

  it 'responds to []' do
    BookingStatusUncached.should respond_to :[]
    StateUncached.should respond_to :[]
  end

  describe 'all_by_name' do

    def flush_cache(klass)
      tmp = klass.enumeration_model_updates_permitted
      begin
        klass.enumeration_model_updates_permitted = true
        klass.purge_enumerations_cache

        yield klass
        BookingStatusUncached.should_receive(:name_column).twice.and_return('name_column')
        BookingStatusUncached.should_receive(:all_by_attribute).and_raise(NoMethodError.new('foo', 'name_column'))
        expect{
          BookingStatusUncached.send(:all_by_name)
        }.to raise_error(TypeError)
      ensure
        klass.purge_enumerations_cache
        klass.enumeration_model_updates_permitted = tmp
      end
    end

    it 'should raise a TypeError if the name column is not defined' do
      flush_cache(BookingStatusUncached) do |klass|
        klass.should_receive(:name_column).twice.and_return('name_column')
        klass.should_receive(:all_by_attribute).and_raise(NoMethodError.new('foo', 'name_column'))
        expect{
          klass.send(:all_by_name)
        }.to raise_error(TypeError)
      end
    end

    it 'should raise NoMethodError for any unrelated NoMethodError' do
      flush_cache(BookingStatusUncached) do |klass|
        klass.should_receive(:name_column).and_return('name_column')
        klass.should_receive(:all_by_attribute).and_raise(NoMethodError.new('foo', 'foo'))
        expect{
          klass.send(:all_by_name)
        }.to raise_error(NoMethodError)
      end
    end
  end

  describe 'purge_enumerations_cache' do
    it 'should raise a runtime error unless enumeration model updates are permitted' do
      tmp = BookingStatusUncached.enumeration_model_updates_permitted
      begin
        BookingStatusUncached.enumeration_model_updates_permitted = false
        expect{
          BookingStatusUncached.purge_enumerations_cache
        }.to raise_error(RuntimeError)
      ensure
        BookingStatusUncached.enumeration_model_updates_permitted = tmp
      end
    end
  end

  describe 'enforce' do
    {
        :enforce_strict_literals => :foo,
        :enforce_strict_ids => 1,
        :enforce_strict_symbols => :foo
    }.each_pair do |method, argument|
      it "should raise ActiveRecord::RecordNotFound when #{method} is called" do
        expect{
          BookingStatusUncached.send(method, argument)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '[]' do

    context 'record exists' do
      context ':name_column is not specified (using :name by default)' do
        it 'returns a record found by name if String is passed' do
          status = BookingStatusUncached['confirmed']
          status.should be_an_instance_of BookingStatusUncached
          status.__enum_name__.should == 'confirmed'
          status.name_sym.should == :confirmed
        end

        it 'returns a record found by name if Symbol is passed' do
          status = BookingStatusUncached[:confirmed]
          status.should be_an_instance_of BookingStatusUncached
          status.__enum_name__.should == 'confirmed'
          status.name_sym.should == :confirmed
        end

        it 'returns a record found by id when Integer is passed' do
          status = BookingStatusUncached[1]
          status.should be_an_instance_of BookingStatusUncached
          status.__enum_name__.should == 'confirmed'
          status.name_sym.should == :confirmed
        end

      end

      context ':name_column is specified' do
        it 'returns a record found by name if String is passed' do
          state = StateUncached['IL']
          state.should be_an_instance_of StateUncached
          state.state_code.should == 'IL'
          state.name_sym.should == :IL
        end

        it 'returns a record found by name if Symbol is passed' do
          state = StateUncached[:IL]
          state.should be_an_instance_of StateUncached
          state.state_code.should == 'IL'
          state.name_sym.should == :IL
        end

        it 'returns a record found by id when Integer is passed' do
          state = StateUncached[1]
          state.should be_an_instance_of StateUncached
          state.state_code.should == 'IL'
          state.name_sym.should == :IL
        end

      end

      context 'multiple arguments to []' do
        it 'should look up multiple values' do
          states = StateUncached[:IL, 'WI']
          states.size.should == 2
          states.first.should == StateUncached[:IL]
          states.last.should == StateUncached[:WI]
        end

        it 'should handle nils' do
          states = StateUncached[nil, :IL]
          states.size.should == 2
          states.first.should == nil
          states.last.should == StateUncached[:IL]
        end

        it 'should filter out duplicates' do
          states = StateUncached[:IL, :IL]
          states.size.should == 1
          states.first.should == StateUncached[:IL]
        end
      end
    end

    context 'record does not exist' do
      context ':on_lookup_failure is specified' do
        it 'if :on_lookup_failure is passed calls the specified class method' do
          BookingStatusUncached.should_receive(:not_found).with(:bad_status)
          BookingStatusUncached[:bad_status]
        end
      end

      context ':on_lookup_failure is not specified' do
        it 'returns nil if String is passed' do
          StateUncached['XXX'].should be_nil
        end

        it 'raises if Symbol passed' do
          expect { StateUncached[:XXX] }.to raise_error ActiveRecord::RecordNotFound
        end

        it 'raises if Integer is passed' do
          expect { StateUncached[999_999] }.to raise_error ActiveRecord::RecordNotFound
        end

        it 'handles multiple args to []' do
          states = StateUncached['XXX', 'IL']
          states.size.should == 2
          states.first.should be_nil
          states.last.should == StateUncached[:IL]

          StateUncached['XXX', 'XXX'].size.should == 1

          expect{ StateUncached[999, 'IL'] }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context ':on_lookup_failure is a lambda' do
        it 'should call the defined lambda' do
          Color[:foo].should == :foo
          Color[nil].should == :bar
        end
      end
    end

    it 'returns instance when instance is passed' do
      state = StateUncached[1]
      state2 = StateUncached[state]
      state2.should == state
    end

  end # describe '[]'

  describe 'contains?' do

    context 'item exists' do

      context ':name_column is not explicitly specified' do

        it 'returns true if looking up String' do
          BookingStatusUncached.contains?('confirmed').should eq(true)
        end

        it 'returns true if looking up by Symbol' do
          BookingStatusUncached.contains?(:confirmed).should eq(true)
        end

        it 'returns true if looking up by id' do
          BookingStatusUncached.contains?(1).should eq(true)
        end

        it 'return true if passing in an enum instance' do
          BookingStatusUncached.contains?(BookingStatusUncached.all.first).should eq(true)
        end

      end # context ':name_column is not explicitly specified'

      context ':name_column is specified' do

        it 'returns true if looking up String' do
          StateUncached.contains?('IL').should eq(true)
        end

        it 'returns true if looking up by Symbol' do
          StateUncached.contains?(:IL).should eq(true)
        end

        it 'returns true if looking up by id' do
          StateUncached.contains?(1).should eq(true)
        end

        it 'return true if passing in an enum instance' do
          StateUncached.contains?(StateUncached.all.first).should eq(true)
        end
      end # context ':name_column is specified'

    end # context 'item exists'

    context 'item does not exist' do

      it 'returns false when passing in a nil' do
        BookingStatusUncached.contains?(nil).should eq(false)
      end

      it 'returns false when passing in a random value' do
        BookingStatusUncached.contains?(Booking.new).should eq(false)
      end

      it 'returns false when a lookup by id fails' do
        StateUncached.contains?(999999).should eq(false)
      end

      it 'returns false when a lookup by Symbol fails' do
        StateUncached.contains?(:XXX).should eq(false)
      end

      it 'returns false when a lookup by String fails' do
        StateUncached.contains?('XXX').should eq(false)
      end
    end
  end

  describe '===' do
    context ':name_column is not specified and on_lookup_failure defined' do

      it '=== should match correct string' do
        BookingStatusUncached[:confirmed].should === 'confirmed'
      end

      it '=== should match correct symbol' do
        BookingStatusUncached[:confirmed].should === :confirmed
      end

      it '=== should match correct id' do
        BookingStatusUncached[:confirmed].should === 1
      end

      it '=== should reject incorrect string' do
        BookingStatusUncached[:confirmed].should_not === 'foo'
      end

      it '=== should reject incorrect symbol' do
        BookingStatusUncached[:confirmed].should_not === :foo
      end

      it '=== should reject incorrect id' do
        BookingStatusUncached[:confirmed].should_not === 2
      end

      it '=== should reject nil' do
        BookingStatusUncached[:confirmed].should_not === nil
      end

      it '=== should match if a member of the array matches' do
        BookingStatusUncached[:confirmed].should === [:confirmed, :foo]
      end

      it '=== should reject if no member of the array matches' do
        BookingStatusUncached[:confirmed].should_not === [:baz, :bar, :foo]
      end

      it '=== should reject random garbage' do
        BookingStatusUncached[:confirmed].should_not === 2.5
      end

    end

    context ':name_column is specified and on_lookup_failure defined as enforce_strict_literals' do

      it '=== should match correct string' do
        StateUncached[:IL].should === 'IL'
      end

      it '=== should match correct symbol' do
        StateUncached[:IL].should === :IL
      end

      it '=== should match correct id' do
        StateUncached[:IL].should === 1
      end

      it '=== should reject incorrect string' do
        StateUncached[:IL].should_not === 'foo'
      end

      it '=== should raise if Symbol is compared' do
        StateUncached[:IL].should_not === 'foo'
      end

      it '=== should reject nil' do
        StateUncached[:IL].should_not === nil
      end

      it '=== should match if a member of the array matches' do
        StateUncached[:IL].should === [:IL, :foo]
      end

      it '=== should reject if no member of the array matches' do
        StateUncached[:IL].should_not === [nil, nil, nil]
      end

      it '=== should reject random garbage' do
        StateUncached[:IL].should_not === 2.5
      end

    end
  end

  describe 'name' do
    it 'should create a name alias by default' do
      StateUncached[:IL].respond_to?(:name).should eq(true)
    end

    it 'should not create a name alias if :name_alias is set to false' do
      FruitUncached[:apple].respond_to?(:name).should eq(false)
    end

    specify "#name" do
      BookingStatusUncached[:confirmed].name.should == 'confirmed'
      StateUncached[:IL].name.should == 'IL'
    end
  end

  describe 'in?' do
    it 'in? should find by Symbol, String, or Integer' do
      [1, :IL, 'IL'].each do |arg|
        StateUncached[:IL].in?(arg).should eq(true)
      end
    end

    it 'in? should return false if nothing matches' do
      StateUncached[:IL].in?(nil).should eq(false)
    end
  end

  describe '__enum_name__' do
    context ':name_column is not specified' do
      it '__ should return value of "name" attribute' do
        BookingStatusUncached[:confirmed].__enum_name__.should == 'confirmed'
      end
    end

    context ':name_column is specified to be :state_code' do
      it '__enum_name__ should return value of the "name_column" attribute' do
        StateUncached[:IL].__enum_name__.should == 'IL'
      end
    end
  end

  describe 'name_sym' do
    context ':name_column is not specified' do
      it 'name_sym should equal the value in the name column cast to a symbol' do
        BookingStatusUncached[:confirmed].name_sym.should == :confirmed
      end
    end

    context ':name_column is specified to be :state_code' do
      it 'name_sym should equal value in the column defined under :name_column cast to a symbol' do
        StateUncached[:IL].name_sym.should == :IL
      end
    end
  end

  describe 'to_sym' do

    it 'to_sym should alias to name_sym' do
      StateUncached.all.each{ |st| st.to_sym.should == st.name_sym }
    end

  end

  specify "#to_s" do
    BookingStatusUncached[:confirmed].to_s.should == 'confirmed'
    StateUncached[:IL].to_s.should == 'IL'
  end

  describe 'name_column' do
    context ':name_column is not specified' do
      it 'name_column should be :name' do
        BookingStatusUncached.name_column.should == :name
      end
    end

    context ':name_column is specified to be :state_code' do
      it 'name_column should be :state_code' do
        StateUncached.name_column.should == :state_code
      end
    end
  end

  describe 'include?' do
    it 'include? should find by id, Symbol, String, and self' do
      [StateUncached[:IL].id, StateUncached[:IL], :IL, 'IL'].each do |val|
        StateUncached.include?(val).should == true
      end
    end

    it 'include? should reject nil' do
      StateUncached.include?(nil).should == false
    end
  end

  describe 'validations' do
    before :each do
      BookingStatusUncached.enumeration_model_updates_permitted = false
    end

    after :each do
      BookingStatusUncached.enumeration_model_updates_permitted = false
    end

    it 'Should not permit the creation of new enumeration models by default' do
      bs = BookingStatusUncached.new(:name => 'unconfirmed'); puts "save: #{bs.save}"
      expect(bs.new_record?).to eq(true)
      expect(bs.save).to eq(false)
    end

    it 'Should not permit the creation of an enumeration model with a blank name' do
      BookingStatusUncached.enumeration_model_updates_permitted = true
      bs = BookingStatusUncached.create()
      bs.new_record?.should == true
      bs.valid?.should == false
      bs.errors[:name].first.should == "can't be blank"
      bs.save.should == false
    end

    it 'Should not permit the creation of an enumeration model with a duplicate name' do
      BookingStatusUncached.enumeration_model_updates_permitted = true
      bs = BookingStatusUncached.create(:name => 'confirmed')
      bs.new_record?.should == true
      bs.valid?.should == false
      bs.errors[:name].first.should == 'has already been taken'
      bs.save.should == false
    end
  end

  describe 'active' do
    context "no 'active' column" do
      it 'all and active should be the equal, i.e. contain all enums' do
        BookingStatusUncached.active.should == BookingStatusUncached.all
      end

      it 'inactive should be empty' do
        BookingStatusUncached.inactive.should be_empty
      end

      it 'each enum should be active' do
        BookingStatusUncached.all.each do |booking_status|
          booking_status.active?.should == true
          booking_status.inactive?.should == false
        end
      end
    end

    context "'active' column defined" do
      it 'active should only include active enums' do
        ConnectorTypeUncached.active.size.should == 2
        ConnectorTypeUncached.active.should include(ConnectorTypeUncached[:HDMI])
        ConnectorTypeUncached.active.should include(ConnectorTypeUncached[:DVI])
        ConnectorTypeUncached.active.should_not include(ConnectorTypeUncached[:VGA])
      end

      it 'inactive should only include inactive enums' do
        ConnectorTypeUncached.inactive.size.should == 1
        ConnectorTypeUncached.inactive.should_not include(ConnectorTypeUncached[:HDMI])
        ConnectorTypeUncached.inactive.should_not include(ConnectorTypeUncached[:DVI])
        ConnectorTypeUncached.inactive.should include(ConnectorTypeUncached[:VGA])
      end
    end

    context "no 'active' column but 'active?' overriden" do
      it "all and active should have the same contents" do
        StateUncached.active.should == StateUncached.all
      end

      it "inactive should be empty" do
        StateUncached.inactive.should be_empty
      end
    end
  end

  describe 'order' do
    it 'connector types should be ordered by name in descending order' do
      expected = ['VGA', 'HDMI', 'DVI']
      ConnectorTypeUncached.all.each_with_index do |con, index|
        con.__enum_name__.should == expected[index]
      end
    end
  end

  describe 'names' do
    it "should return the names of an enum as an array of symbols" do
      ConnectorTypeUncached.names.should == [:VGA, :HDMI, :DVI]
    end

    it 'should return names if there is no :name alias' do
      FruitUncached.names.should == [:apple, :peach, :pear]
    end
  end

  describe 'all_except' do
    it "should filter out one item (Symbol)" do
      expect(ConnectorTypeUncached.all_except(:VGA)).to match_array(ConnectorTypeUncached[:HDMI, :DVI])
    end

    it "should filter out one item (Enum)" do
      expect(ConnectorTypeUncached.all_except(ConnectorTypeUncached[:VGA])).to match_array(ConnectorTypeUncached[:HDMI, :DVI])
    end

    it "should filter out multiple items" do
      expect(ConnectorTypeUncached.all_except(:VGA, :DVI)).to match_array([ConnectorTypeUncached[:HDMI]])
    end
  end

  describe 'update_enumerations_model' do

    it 'should not complain if no block given' do
      expect{
        ConnectorTypeUncached.update_enumerations_model
      }.to_not raise_error
    end

    it 'should permit enumeration model updates and purge enumeration cache' do
      ConnectorTypeUncached.update_enumerations_model do
        ConnectorTypeUncached.create :name        => 'Foo',
                             :description => 'Bar',
                             :has_sound   => true
      end
      ConnectorTypeUncached.all.size.should == 4
      ConnectorTypeUncached['Foo'].should_not be_nil

      ConnectorTypeUncached.update_enumerations_model do
        ConnectorTypeUncached['Foo'].description = 'foobar'
        ConnectorTypeUncached['Foo'].save!
      end
      ConnectorTypeUncached['Foo'].description.should == 'foobar'

      ConnectorTypeUncached.update_enumerations_model do
        ConnectorTypeUncached['Foo'].destroy
      end
      ConnectorTypeUncached.all.size.should == 3
      ConnectorTypeUncached['Foo'].should be_nil
    end

    it 'should allow a block with an argument' do
      ConnectorTypeUncached.update_enumerations_model do |klass|
        klass.create :name        => 'Foo',
                     :description => 'Bar',
                     :has_sound   => true
      end
      ConnectorTypeUncached.all.size.should == 4
      ConnectorTypeUncached['Foo'].should_not be_nil

      ConnectorTypeUncached.update_enumerations_model do |klass|
        klass['Foo'].description = 'foobar'
        klass['Foo'].save!
      end
      ConnectorTypeUncached['Foo'].description.should == 'foobar'

      ConnectorTypeUncached.update_enumerations_model do |klass|
        klass['Foo'].destroy
      end
      ConnectorTypeUncached.all.size.should == 3
      ConnectorTypeUncached['Foo'].should be_nil
    end
  end

  describe 'acts_as_enumerated?' do
    it 'enum models should act as enumerated' do
      ConnectorTypeUncached.acts_as_enumerated?.should == true
    end

    it 'models which are not enums should not act as enumerated' do
      Booking.acts_as_enumerated?.should == false
    end
  end

  describe "freeze_members" do

    it "members not frozen" do
      ConnectorTypeUncached.all.each { |c| expect(c.frozen?).to eq(false) }
    end

    it "members frozen" do
      BookingStatusUncached.all.each { |c| expect(c.frozen?).to eq(true) }
    end

  end

  context 'when class methods are used as scopes' do
    before { StateUncached.enumeration_model_updates_permitted = true  }
    after  { StateUncached.enumeration_model_updates_permitted = false }

    it 'with .active method' do
      StateUncached.count.should == 3
      StateUncached.purge_enumerations_cache

      # .acitve may call redefined .all, which caches only values with passed scope(not all)
      StateUncached.where(:state_code => "IL").active

      StateUncached.all.size.should == 3
    end

    it 'with .inactive method' do
      StateUncached.count.should == 3
      StateUncached.purge_enumerations_cache

      # .inacitve may call redefined .all, which caches only values with passed scope(not all)
      StateUncached.where(:state_code => "IL").inactive

      StateUncached.all.size.should == 3
    end

  end
end
