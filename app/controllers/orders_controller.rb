class OrdersController < ApplicationController
  before_action :authenticate_user! # Si tu utilises Devise
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders (Afficher toutes les commandes d'un utilisateur)
  def index
    @orders = current_user.orders
    render json: @orders
  end

  # GET /orders/:id (Afficher une commande spécifique)
  def show
    render json: @order
  end

  # POST /orders (Créer une commande à partir du panier)
  def create
    cart_items = current_user.cart_items

    if cart_items.empty?
      render json: { error: "Votre panier est vide." }, status: :unprocessable_entity
      return
    end

    order = current_user.orders.new(status: "pending")

    # Ajouter les articles du panier à la commande
    cart_items.each do |cart_item|
      order.order_items.build(
        product: cart_item.product,
        quantity: cart_item.quantity,
        unit_price: cart_item.product.price
      )
    end

    order.calculate_total_price

    if order.save
      cart_items.destroy_all # Vider le panier après commande
      render json: order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/:id (Mettre à jour le statut d'une commande)
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/:id (Annuler une commande)
  def destroy
    if @order.status == "pending"
      @order.destroy
      render json: { message: "Commande annulée avec succès." }
    else
      render json: { error: "Impossible d'annuler une commande déjà payée ou expédiée." }, status: :forbidden
    end
  end

  private

  # Trouver une commande spécifique
  def set_order
    @order = current_user.orders.find_by(id: params[:id])
    render json: { error: "Commande introuvable." }, status: :not_found unless @order
  end

  # Autoriser uniquement la mise à jour du statut
  def order_params
    params.require(:order).permit(:status)
  end
end
