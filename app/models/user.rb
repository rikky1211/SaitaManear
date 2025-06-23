class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  has_many :spots, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_to_spots, through: :favorites, source: :spot

  enum :role, { general: 0, admin: 1, super_admin: 2 }
end
