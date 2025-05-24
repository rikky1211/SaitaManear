class Spot < ApplicationRecord
  # geocoded_by :address
  # after_validation :geocode

  validates :name, presence: true
  validates :spot_image, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  validate :LatLng_uniq

  belongs_to :user
  # belongs_to :town
  has_one_attached :spot_image

  def LatLng_uniq
    if Spot.where(latitude: latitude, longitude: longitude).exists?
      errors.add(:base, "同じ緯度・経度のスポットはすでに存在します。")
    end
  end
end
