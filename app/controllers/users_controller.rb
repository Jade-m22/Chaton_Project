class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]

  # Afficher tous les utilisateurs (réservé aux admins)
  def index
    if current_user.admin?
      @users = User.all
    else
      redirect_to root_path, alert: "Accès refusé."
    end
  end

  # Afficher un utilisateur
  def show
  end

  # Formulaire d'édition d'un utilisateur
  def edit
  end

  # Mettre à jour un utilisateur
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profil mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Supprimer un utilisateur (réservé aux admins)
  def destroy
    if current_user.admin?
      @user.destroy
      redirect_to users_path, notice: "Utilisateur supprimé."
    else
      redirect_to root_path, alert: "Action non autorisée."
    end
  end

  private

  # Trouver un utilisateur selon l'ID
  def set_user
    @user = User.find(params[:id])
  end

  # Vérifier si l'utilisateur peut modifier/mettre à jour son propre compte
  def authorize_user
    unless current_user == @user || current_user.admin?
      redirect_to root_path, alert: "Vous ne pouvez pas modifier ce profil."
    end
  end

  # Définir les paramètres autorisés
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
