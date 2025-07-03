class SpotsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @spots = Spot.all
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def new
    @spot = Spot.new
  end

  def create
    @spot = Spot.new(spot_params)
    @spot.user = current_user

    if @spot.save
      redirect_to @spot, notice: "スポットを新規登録しました"
    else
      logger.debug @spot.errors.full_messages
      flash.now[:error] = "新規スポット登録に失敗しました"
      render :new, status: :unprocessable_entity
    end

    def search

    end
  end



  private

  def spot_params
    # 市区町村プルダウン、実装見送りのため 「, :town_id」 削除
    params.require(:spot)&.permit(:name, :spot_image, :summary, :latitude, :longitude)
  end
end
