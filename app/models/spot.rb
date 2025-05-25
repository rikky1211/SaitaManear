class Spot < ApplicationRecord
  # geocoded_by :address
  # after_validation :geocode

  # latitude, longitude から Google Maps（または他の設定されたAPI）を使って住所情報を取得し、自動的に address に代入してくれます。
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode, if: -> { latitude.present? && longitude.present? }

  validates :name, presence: true
  validates :spot_image, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  validate :latlng_uniq
  validate :must_be_in_saitama

  belongs_to :user
  # belongs_to :town
  has_one_attached :spot_image

  def latlng_uniq
    if Spot.where(latitude: latitude, longitude: longitude).exists?
      errors.add(:base, "同じ緯度・経度のスポットはすでに存在します。")
    end
  end

  def must_be_in_saitama
    results = Geocoder.search([latitude, longitude])
    Rails.logger.debug "Geocoder results: #{results.map(&:data)}"
    unless in_saitama_prefecture?(results)
      errors.add(:base, "埼玉県以外の場所は登録できません。")
    end
  end

  def in_saitama_prefecture?(geocoder_results)
    return false if geocoder_results.blank?

    geocoder_results.any? do |result|
      address = result.data["address"] || {}
      # 例えば英語表記で"province"に"Saitama Prefecture"が含まれているかチェック
      address["province"] == "Saitama Prefecture" ||
      # 日本語表記で"埼玉県"が含まれているかどうかもチェック
      address["state"] == "埼玉県" ||
      address.values.any? { |v| v.to_s.include?("埼玉県") }
    end
  end
end
