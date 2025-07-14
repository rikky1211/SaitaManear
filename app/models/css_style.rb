class CssStyle < ApplicationRecord
  has_many :season_tags

  validates :style_name, presence: true
  validates :style_color, presence: true
  validates :style_daisyui, presence: true

  validates :style_name, uniqueness: { scope: [ :style_color, :style_daisyui ] }
end
