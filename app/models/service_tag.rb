class ServiceTag < ApplicationRecord
  validates :name, presence: true

  has_many :spots
  belongs_to :css_style
end
