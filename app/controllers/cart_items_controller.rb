class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart_items = current_user.cart_items
  end

  def create
    @cart_item = current_user.cart_items.find_or_initialize_by(product_id: params[:product_id])
    @cart_item.quantity += params[:quantity].to_i
    if @cart_item.save
      redirect_to cart_items_path, notice: 'Produit ajouté au panier.'
    else
      redirect_to products_path, alert: 'Erreur lors de l\'ajout.'
    end
  end

  def destroy
    @cart_item = current_user.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path, notice: 'Produit retiré du panier.'
  end
end
