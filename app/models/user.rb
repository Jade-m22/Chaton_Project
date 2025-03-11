class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :orders, dependent: :destroy
  
  validates :first_name, :email, presence: true
  
  def admin?
    is_admin == true
  end
end
