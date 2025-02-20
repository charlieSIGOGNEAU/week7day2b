class AvatarsController < ApplicationController

  def create 
    if params[:event_id]
      @event = Event.find(params[:event_id])
      @event.avatar.attach(params[:avatar])
      redirect_to event_path(params[:event_id])
    else
      @user = User.find(params[:user_id])
      @user.avatar.attach(params[:avatar])
      redirect_to user_path(params[:user_id])
    end
  end
end