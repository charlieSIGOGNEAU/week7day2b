class AttendancesController < ApplicationController
  before_action :set_event
  before_action :authorize_admin, only: [:index]

  def new
    @attendance = Attendance.new
    @event_id = @event.id
    @title =@event.title
    @price = @event.price
  end

  def index
    @attendances = @event.attendances
  end

  def update
    
  end

  def destroy
    @attendance.destroy
    redirect_to event_attendances_path(@event), notice: "L'invité a été supprimé avec succès."
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def authorize_admin
    redirect_to event_path(@event), alert: "Accès refusé." unless @event.admin == current_user
  end

end
