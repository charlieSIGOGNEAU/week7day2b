class CheckoutController < ApplicationController
  def create
    @total = params[:total].to_d
    @event_id = params[:event_id]
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'eur',
            unit_amount: (@total*100).to_i,
            product_data: {
              name: 'Rails Stripe Checkout',
            },
          },
          quantity: 1
        },
        
      ],
      customer_email: current_user.email,
      metadata: {event_id: @event_id},
      mode: 'payment',
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url
    )
    redirect_to @session.url, allow_other_host: true
  end

  def success
    # Récupérer la session Stripe
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    # ??? pareil que session en plus detailé ?
    @payment_intent = Stripe::PaymentIntent.retrieve(@session.payment_intent)
    # Récupérer l'ID de l'événement depuis les metadata de la session
    @event_id = @session.metadata.event_id
  
    if @session.payment_status == 'paid' # Vérifier le statut du paiement
      # Si le paiement est réussi, créer l'Attendance
      puts "1"*60
      @attendance = Attendance.create(
        user_id: current_user.id,
        event_id: @event_id,
        # stripe_customer_id: @session.customer  !!!!!!!!!!!!!!!!!!!!!!!!!!!!
      )
      puts "2"*60
      puts @session
      p @attendance
      puts @event_id
      puts @attendance.errors.full_messages  # Affiche les erreurs dans la console
      puts "2"*60
      # Rediriger vers la page de l'événement avec un message de succès
      redirect_to event_path(@event_id), notice: 'Inscription réussie à l\'événement!'
    else
      # Si le paiement a échoué
      redirect_to event_path(@event_id), alert: 'Le paiement a échoué. Veuillez réessayer.'
    end

  end

  def cancel
    # Gérer le cas d'annulation de paiement
    redirect_to event_path(params[:event_id]), alert: 'Vous avez annulé le paiement.'
  end
end

