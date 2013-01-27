require 'spec_helper'

describe "RSpec Matchers" do

  context "acts_as_enumerated" do

    it "BookingStatus should act as enumerated" do
      BookingStatus.should act_as_enumerated
    end

    it "Booking should not act as enumerated" do
      Booking.should_not act_as_enumerated
    end

    it "Should match a list of enum names" do
      BookingStatus.should act_as_enumerated.with_items(:confirmed, :received, :rejected)
    end

    it "Should reject invalid names" do
      BookingStatus.should_not act_as_enumerated.with_items(:foo)
    end

    it "Should reject when some invalid items are in the name list" do
      BookingStatus.should_not act_as_enumerated.with_items(:confirmed, :received, :rejected, :foo)
    end

    it "Should match hashes of attributes" do
      BookingStatus.should act_as_enumerated.with_items({ :name => 'confirmed', :id => 1 },
                                                        { :name => 'received',  :id => 2 },
                                                        { :name => 'rejected',  :id => 3 })
    end

    it "Should match hashes of attributes" do
      BookingStatus.should_not act_as_enumerated.with_items({ :name => 'confirmed' },
                                                            { :name => 'received'  },
                                                            { :name => 'rejected'  },
                                                            { :name => 'foo'       })
    end

    it "Should reject when some attributes are wrong" do
      BookingStatus.should_not act_as_enumerated.with_items({ :name => 'confirmed', :id => 0 },
                                                            { :name => 'received',  :id => 0 },
                                                            { :name => 'rejected',  :id => 0 })
    end

    describe BookingStatus do
      it{ should act_as_enumerated }
    end

    describe Booking do
      it{ should_not act_as_enumerated }
    end

    describe 'matcher behavior' do
      subject{ act_as_enumerated.with_items(:foo, :bar, :baz) }

      it 'should have the correct description' do
        subject.description.should eq('act as enumerated')
      end

      it 'should have the correct failure message for should' do
        subject.failure_message_for_should.should eq("should act as enumerated and have members #{[:foo, :bar, :baz].inspect}")
      end

      it 'should have the correct failure message for should_not' do
        subject.failure_message_for_should_not.should eq("should not act as enumerated with members #{[:foo, :bar, :baz].inspect}")
      end

      it 'validate_enum should handle a random item value' do
        subject.validate_enum(BookingStatus, 1.5).should be_false
      end

      it 'should handle an exception in validate_enum' do
        subject.should_receive(:validate_enum).and_raise(RuntimeError)
        subject.matches?(BookingStatus).should be_false
      end
    end

  end

  context "has_enumerated" do
    describe Booking do
      it { should have_enumerated(:status) }
    end

    it "Booking should have enumerated state" do
      Booking.should have_enumerated(:state)
    end

    describe 'matcher behavior' do
      subject{ have_enumerated(:foo) }

      it 'should have the correct description' do
        subject.description.should eq('have enumerated foo')
      end

      it 'should have the correct failure message for should' do
        subject.failure_message_for_should.should eq('expected foo to be an enumerated attribute')
      end

      it 'should have the correct failure message for should_not' do
        subject.failure_message_for_should_not.should eq('expected foo to not be an enumerated attribute')
      end
    end
  end

  context 'match_enum' do

    let(:booking){
      Booking.new(:status => :confirmed)
    }

    it 'should match symbol values' do
      booking.status.should match_enum(:confirmed)
      booking.status.should_not match_enum(:received)
    end

    it 'should match string values' do
      booking.status.should match_enum('confirmed')
      booking.status.should_not match_enum('received')
    end

    it 'should match ids' do
      booking.status.should match_enum(1)
      booking.status.should_not match_enum(2)
    end

    it 'should match enum instances' do
      booking.status.should match_enum(BookingStatus[:confirmed])
      booking.status.should_not match_enum(BookingStatus[:received])
    end

    it 'should not match nil' do
      booking.status.should_not match_enum(nil)
    end

    it 'should not match random junk' do
      booking.status.should_not match_enum({})
    end

    it 'matcher should still work on non-enum classes' do
      booking.should_not match_enum(nil)
    end

    describe 'matcher behavior' do
      subject{ match_enum(:foo) }

      it 'should have the correct description' do
        subject.description.should eq('match enum value of foo')
      end

      it 'should have the correct failure message for should' do
        subject.failure_message_for_should.should eq('expected foo to match the enum')
      end

      it 'should have the correct failure message for should_not' do
        subject.failure_message_for_should_not.should eq('expected foo to not match the enum')
      end
    end
  end

end