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
                                                        { :name => 'received', :id => 2 },
                                                        { :name => 'rejected', :id => 3 })
    end

    it "Should match hashes of attributes" do
      BookingStatus.should_not act_as_enumerated.with_items({ :name => 'confirmed' },
                                                            { :name => 'received' },
                                                            { :name => 'rejected' },
                                                            { :name => 'foo' })
    end

    it "Should reject when some attributes are wrong" do
      BookingStatus.should_not act_as_enumerated.with_items({ :name => 'confirmed', :id => 0 },
                                                            { :name => 'received', :id => 0 },
                                                            { :name => 'rejected', :id => 0 })
    end

    describe BookingStatus do
      it{ should act_as_enumerated }
    end

    describe Booking do
      it{ should_not act_as_enumerated }
    end

  end

  context "has_enumerated" do
    describe Booking do
      it { should have_enumerated(:status) }
    end

    it "Booking should have enumerated state" do
      Booking.should have_enumerated(:state)
    end
  end

end