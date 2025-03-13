class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @products = Product.where.not(name: ["Mug Chaton", "Sweat Chaton", "Totebag Chaton", "Tshirt Chaton"])
  end  

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: "Produit ajouté avec succès."
    else
      render :new
    end
  end

  def edit
  end

  def update
    @product = Product.find(params[:id])
    if params[:product][:images].present?
      @product.images.attach(params[:product][:images])
    end
  
    # Mise à jour des autres champs sans toucher aux images
    if @product.update(product_params.except(:images))
      redirect_to @product, notice: "Produit mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end  

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Produit supprimé."
  end

  def derive
    derived_names = ["Mug Chaton", "Sweat Chaton", "Totebag Chaton", "Tshirt Chaton"]
    @derived_products = Product.where(name: derived_names)
  end  
  

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :category, images: [])
  end  

  def authenticate_admin!
    redirect_to root_path, alert: "Accès refusé" unless current_user&.admin?
  end
end
