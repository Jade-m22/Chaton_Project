class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :cart

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }

  def total_price
    product.price * quantity
  end
end
