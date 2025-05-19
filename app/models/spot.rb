class Spot < ApplicationRecord
  # geocoded_by :address
  # after_validation :geocode

  validates :spot_image, presence: true
  validates :latitude, presence: true, uniqueness: true
  validates :longitude, presence: true, uniqueness: true

  belongs_to :user
  belongs_to :town
  has_one_attached :spot_image
end
