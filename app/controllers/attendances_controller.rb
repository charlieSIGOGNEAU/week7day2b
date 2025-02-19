class AttendancesController < ApplicationController
  before_action :set_event
  
  def new
    @attendance = Attendance.new
    @event_id = @event.id
    @title =@event.title
    @price = @event.price
  end

  def index
    
    @attendances = @event.attendances
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

end
