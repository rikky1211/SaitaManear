class SpotsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @spots = Spot.all
    @lat = params[:lat]
    @lng = params[:lng]
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def new
    @spot = Spot.new
    @season_tags = SeasonTag.all
  end

  def create
    @spot = current_user.spots.build(spot_params)

    if @spot.valid?
      begin
        @spot.spot_image = \
          ImageProcessable.process_and_transform_image(params[:spot][:spot_image], 854) \
            if params[:spot][:spot_image].present?

        if @spot.save
          redirect_to @spot, notice: "スポットを新規登録しました"
        end

      rescue ImageProcessable::ImageProcessingError => e
        flash.now[:error] = e.message
        render :new, status: :unprocessable_entity
      end
    else
      logger.debug @spot.errors.full_messages
      flash.now[:error] = "新規スポット登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def search
    @spots = Spot.all
  end

  private

  def spot_params
    # 市区町村プルダウン、実装見送りのため 「, :town_id」 削除
    params.require(:spot)&.permit(:name, :spot_image, :summary, :latitude, :longitude)
  end
end
