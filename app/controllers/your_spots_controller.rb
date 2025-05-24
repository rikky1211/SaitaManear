class YourSpotsController < ApplicationController
  before_action :authenticate_user!

  def index
    @spots = current_user.spots.page(params[:page])
  end

  def show
  end

  def edit
    @spot = current_user.spots.find(params[:id])
  end

  def destroy
      spot = current_user.spots.find(params[:id])
      if spot.spot_image.attached?
        spot.spot_image.purge
      end
      spot.destroy!
      redirect_to your_spots_path
  end

private

  def spot_params
    params.require(:spot)&.permit(:name, :spot_image, :summary, :latitude, :longitude)
  end
end
