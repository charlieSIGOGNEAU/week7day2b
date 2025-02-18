class UsersController < ApplicationController
  # efore_action :authenticate_user! # Assure-toi que l'utilisateur est connecté
  def show
    @user=current_user
  end
end
