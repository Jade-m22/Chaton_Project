class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :orders, dependent: :destroy
  has_many :cart_items
  
  validates :first_name, :email, presence: true
  
  def admin?
    is_admin == true
  end
end
