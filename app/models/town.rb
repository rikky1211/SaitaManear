class Town < ApplicationRecord
  validates :address, presence: true, uniqueness: true

  # has_many :spots, dependent: :destroy
end
