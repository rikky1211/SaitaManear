class TopController < ApplicationController
  def index
    # with_attached_spot_image: 画像が添付されているSpotのみ取得
    # sample: ランダムで1つ選ぶ
    @background_spot = Spot.with_attached_spot_image { |s| s.spot_image.attached? }.sample
  end

  def how_to_use
  end

  def terms_of_use
  end

  def privacy_policy
  end

  def contact_form
  end

  def sorry
  end
end
