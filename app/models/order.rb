class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :status, presence: true, inclusion: { in: ["pending", "paid", "shipped", "cancelled"] }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :calculate_total_price

  def calculate_total_price
    self.total_price = order_items.sum(&:total_price)
  end
end