class SeasonTag < ApplicationRecord
  validates :season, presence: true

  # dependent: :nullify / Spotは残してタグだけ消す。
  has_many :spot_season_tags, dependent: :nullify
  has_many :spots, through: :spot_season_tags

  belongs_to :css_style
end
