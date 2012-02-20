if defined? RSpec
  require 'rspec/expectations'

  # This is used to test that a model acts as enumerated.  Example:
  #
  #     describe BookingStatus do
  #       it { should act_as_enumerated }
  #     end
  #
  # This also works:
  #
  #     describe BookingStatus do
  #       it "should act as enumerated" do
  #         BookingStatus.should act_as_enumerated
  #       end
  #     end
  #
  # You can use the `with_items` chained matcher to test that each enum is properly seeded:
  #
  #     describe BookingStatus do
  #       it {
  #         should act_as_enumerated.with_items(:confirmed, :received, :rejected)
  #       }
  #     end
  #
  # You can also pass in hashes if you want to be thorough and test out all the attributes of each enum.  If
  # you do this, you must pass in the `:name` attribute in each hash
  #
  #     describe BookingStatus do
  #       it {
  #         should act_as_enumerated.with_items({ :name => 'confirmed', :description => "Processed and confirmed" },
  #                                             { :name => 'received', :description => "Pending confirmation" },
  #                                             { :name => 'rejected', :description => "Rejected due to internal rules" })
  #       }
  #     end
  RSpec::Matchers.define :act_as_enumerated do

    chain :with_items do |*args|
      @items = args
    end

    match do |enum|
      enum_class = get_enum_class(enum)

      if enum_class.respond_to?(:[]) &&
          enum_class.respond_to?(:enumeration_model_updates_permitted) &&
          enum_class.respond_to?(:purge_enumerations_cache)

        if @items
          begin
            @items.all? { |item| validate_enum(enum_class, item) }
          rescue Exception
            false
          end
        else
          true
        end
      else
        false
      end
    end

    def get_enum_class(enum)
      if enum.is_a?(Class)
         enum
       else
         enum.class
       end
    end

    def validate_enum(enum_class, item)
      case item
      when String, Symbol, Fixnum
        enum_class[item].present?
      when Hash
        name = item[:name]
        if (e = enum_class[name]).present?
          item.all?{ |attribute, value|
            e.send(attribute) == value
          }
        else
          false
        end
      else
        false
      end
    end

    failure_message_for_should do
      message = "should act as enumerated"
      if @items
        message << " and have members #{@items.inspect}"
      end
      message
    end

    failure_message_for_should_not do
      message = "should not act as enumerated"
      if @items
        message << " and not have members #{@items.inspect}"
      end
      message
    end

    description do
      "act as enumerated"
    end
  end

  # This is used to test that a model has enumerated the given attribute:
  #
  #     describe Booking do
  #       it { should have_enumerated(:status) }
  #     end
  #
  # This is also valid:
  #
  #     describe Booking do
  #       it "Should have enumerated the status attribute" do
  #         Booking.should have_enumerated(:status)
  #       end
  #     end
  RSpec::Matchers.define :have_enumerated do |attribute|
    match do |model|
      model_class = if model.is_a?(Class)
                      model
                    else
                      model.class
                    end
      model_class.has_enumerated?(attribute)
    end

    failure_message_for_should do
      "expected #{attribute} to be an enumerated attribute"
    end

    failure_message_for_should_not do
      "expected #{attribute} to not be an enumerated attribute"
    end

    description do
      "have enumerated #{attribute}"
    end
  end

end