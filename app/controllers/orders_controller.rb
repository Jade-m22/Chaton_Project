class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders - Afficher toutes les commandes de l'utilisateur
  def index
    if current_user.admin?
      @orders = Order.includes(:user, :order_items).all # Admin voit tout
    else
      @orders = current_user.orders # Utilisateur normal voit ses commandes
    end
  end
  

  # GET /orders/:id - Afficher une commande
  def show
    redirect_to root_path, alert: "Commande introuvable." unless @order
  end

  # POST /orders - Créer une commande
  def create
    cart_items = current_user.cart_items

    if cart_items.empty?
      redirect_to cart_path, alert: "Votre panier est vide."
      return
    end

    order = current_user.orders.new(status: "pending")

    cart_items.each do |cart_item|
      order.order_items.build(
        product: cart_item.product,
        quantity: cart_item.quantity,
        unit_price: cart_item.product.price
      )
    end

    order.calculate_total_price

    if order.save
      cart_items.destroy_all
      redirect_to order_path(order), notice: "Commande créée avec succès."
    else
      redirect_to cart_path, alert: "Erreur lors de la création de la commande."
    end
  end

  # PATCH/PUT /orders/:id - Mettre à jour une commande
  def update
    unless current_user.admin? || @order.user == current_user
      redirect_to orders_path, alert: "Accès non autorisé."
      return
    end

    if @order.update(order_params)
      redirect_to @order, notice: "Commande mise à jour."
    else
      render :edit
    end
  end

  # DELETE /orders/:id - Annuler une commande
  def destroy
    if @order.status == "pending"
      @order.destroy
      redirect_to orders_path, notice: "Commande annulée avec succès."
    else
      redirect_to orders_path, alert: "Impossible d'annuler une commande déjà traitée."
    end
  end

  private

  def set_order
    @order = current_user.orders.find_by(id: params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
