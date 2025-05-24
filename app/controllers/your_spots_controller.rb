class YourSpotsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show edit update destroy]

  def index
    @spots = current_user.spots.page(params[:page])
  end

  def show
  end

  def edit
    @spot = current_user.spots.find(params[:id])
  end

  def update
    @spot = current_user.spots.find(params[:id])

    if @spot.update(spot_params)
      redirect_to spot_path(@spot), notice: "スポットを更新しました"
    else
      flash.now[:error] = "スポットを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
      spot = current_user.spots.find(params[:id])
      if spot.spot_image.attached?
        spot.spot_image.purge
      end
      spot.destroy!
      redirect_to your_spots_path, notice: "スポットを削除しました"
  end

private

  def spot_params
    params.require(:spot)&.permit(:name, :spot_image, :summary, :latitude, :longitude)
  end
end
