require 'spec_helper'

describe 'has_enumerated' do
  before(:each) do
    Booking.destroy_all
    @booking = Booking.create
  end

  it 'provides #status method' do
    @booking.should respond_to :status
  end

  it 'provides #status= method' do
    @booking.should respond_to :status=
  end


  context 'when status exists' do
    it 'assigns and returns an appropriate status model when Symbol is passed' do
      @booking.status = :confirmed
      status = @booking.status
      status.should_not be_new_record
      status.should be_an_instance_of BookingStatus
      status.name.should == 'confirmed'
    end

    it 'assigns and returns an appropriate status when String is passed' do
      @booking.status = 'confirmed'
      status = @booking.status
      status.should_not be_new_record
      status.should be_an_instance_of BookingStatus
      status.name.should == 'confirmed'
    end

    it 'assigns and returns an appropriate status when Fixnum is passed' do
      @booking.status = 1
      status = @booking.status
      status.should_not be_new_record
      status.should be_an_instance_of BookingStatus
      status.name.should == 'confirmed'
    end
  end

  context 'when status does not exist' do
    it 'calls :on_lookup_failure method on assigning' do
      @booking.should_receive(:not_found_status_handler).
          with(:write, 'status', 'status_id', 'BookingStatus', 'bad_status')
      @booking.status = 'bad_status'
    end

    it 'does not call :on_lookup_failure method on assignment when nil is passed' do
      @booking.should_receive(:status_id=).with(nil)
      @booking.status = nil
    end

    it 'raises ArgumentError if :on_lookup_failure method is not specified' do
      expect { @booking.state = :XXX }.to raise_error ArgumentError
    end

    it 'assigns the foreign key to nil if :on_lookup_failure method is not specified and nil is passed' do
      @booking.status = :confirmed
      @booking.status = nil
      @booking.status.should be_nil
    end
  end

end
