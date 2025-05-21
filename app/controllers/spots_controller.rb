class SpotsController < ApplicationController
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
      redirect_to @spot, notice: "スポットを登録しました"
    else
      puts "DEBUG: spot errors = #{@spot.errors.full_messages}"
      render :new
    end
  end

  private

  def spot_params
    # 市区町村プルダウン、実装見送りのため 「, :town_id」 削除
    params.require(:spot)&.permit(:name, :spot_image, :summary, :latitude, :longitude)
  end
end
