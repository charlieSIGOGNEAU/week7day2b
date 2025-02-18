class EventsController < ApplicationController
  
  def show
    
  end

  def index
    @events=Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.admin = current_user # Si tu as un utilisateur connecté

    if @event.save
      redirect_to event_path(@event), notice: 'Événement créé avec succès!'
    else
      puts "#"*60
      puts @event.errors.full_messages
      flash.now[:alert] = @event.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :duration, :price, :location)
  end
end
