class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  
  validates :email, presence: true
  
  def admin?
    admin == true
  end
end
