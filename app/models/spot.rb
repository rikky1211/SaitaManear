class Spot < ApplicationRecord
  before_save :clean_address
  # geocoded_by :address
  # after_validation :geocode

  # latitude, longitude から Google Maps（または他の設定されたAPI）を使って住所情報を取得し、自動的に address に代入してくれます。
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode, if: -> { latitude.present? && longitude.present? }

  validates :name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  ACCEPTED_CONTENT_TYPES = %w[image/jpeg image/png image/gif image/webp image/heic].freeze
  validates :spot_image,
              presence: true,
              content_type: ACCEPTED_CONTENT_TYPES,
              size: { less_than_or_equal_to: 10.megabytes }

  validate :latlng_uniq
  validate :must_be_in_saitama

  has_many :spot_season_tags, dependent: :destroy
  has_many :season_tags, through: :spot_season_tags
  has_many :favorites, dependent: :destroy

  belongs_to :user
  # belongs_to :town
  has_one_attached :spot_image

  def latlng_uniq
    return unless new_record?

    if Spot.where(latitude: latitude, longitude: longitude).exists?
      errors.add(:base, "同じ緯度・経度のスポットはすでに存在します。")
    end
  end

  def must_be_in_saitama
    results = Geocoder.search([ latitude, longitude ]).first.formatted_address
    # binding.pry
    Rails.logger.debug "-----------------------------------"
    Rails.logger.debug "Geocoder results: #{results}"
    Rails.logger.debug "-----------------------------------"
    
    unless results.include?("埼玉県")
      errors.add(:base, "埼玉県以外の場所は登録できません。")
    end
  end

  # 保存する前に「日本、」と「〒123-4567 」を削除する
  def clean_address
    self.address = address.gsub(/\A日本、〒\d{3}-\d{4}\s*/, '')
  end
end
