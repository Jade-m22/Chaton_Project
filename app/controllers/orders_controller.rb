class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :update, :destroy, :checkout]

  # GET /orders - Afficher toutes les commandes de l'utilisateur
  def index
    @orders = current_user.admin? ? Order.includes(:user, :order_items).all : current_user.orders
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

    # Ajouter les produits du panier à la commande
    cart_items.each do |cart_item|
      order.order_items.build(
        product: cart_item.product,
        quantity: cart_item.quantity,
        price: cart_item.product.price
      )
    end

    order.calculate_total_price # Assure que total_price est défini avant save

    if order.save
      cart_items.destroy_all
      redirect_to checkout_order_path(order)  # Redirection vers checkout après la création de la commande
    else
      puts "❌ Erreur lors de la sauvegarde de l'order : #{order.errors.full_messages}"
      redirect_to cart_path, alert: "Erreur lors de la création de la commande."
    end
  end


  # GET /orders/:id/checkout - Rediriger vers Stripe Checkout
  def checkout
    begin
      session = Stripe::Checkout::Session.create(
        payment_method_types: ["card"],
        line_items: @order.order_items.map do |item|
          {
            price_data: {
              currency: "eur",
              product_data: { name: item.product.name },
              unit_amount: (item.price * 100).to_i
            },
            quantity: item.quantity
          }
        end,
        mode: "payment",
        success_url: dashboard_url,  # ✅ Redirige vers le Dashboard après paiement
        cancel_url: cart_url
      )
  
      redirect_to session.url, allow_other_host: true
    rescue Stripe::StripeError => e
      redirect_to cart_url, alert: "Erreur Stripe : #{e.message}"
    end
  end
  
  private

  def set_order
    @order = current_user.orders.find_by(id: params[:id])
    redirect_to root_path, alert: "Commande introuvable." unless @order
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
