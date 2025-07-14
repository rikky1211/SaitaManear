class SpotSeasonTag < ApplicationRecord
  belongs_to :spot
  belongs_to :season_tag

  validates :spot_id, presence: true
  validates :season_tag_id, presence: true

  validates :spot_id, uniqueness: { scope: :season_tag_id }
end
