class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def show
    @cart = current_user.cart
  end

  def add_item
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_or_initialize_by(product: product)
    cart_item.quantity ||= 0
    cart_item.quantity += 1
    if cart_item.save
      redirect_to cart_path, notice: "Produit ajouté au panier."
    else
      redirect_to products_path, alert: "Impossible d'ajouter le produit."
    end
  end

  def remove_item
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Produit retiré du panier."
  end

  def empty
    @cart.cart_items.destroy_all
    redirect_to cart_path, notice: "Panier vidé."
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end
end
