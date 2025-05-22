class YourSpotsController < ApplicationController
  def index
  end

  def show
  end

  def edit
    @spot = current_user.spots.find(params[:id])
  end

  def destroy
      @spot = current_user.spots.find(params[:id])
      @spot.destroy
  end

private

  def spot_params
    params.require(:spot).permit(:name, :spot_image, :summary, :latitude, :longitude)
  end
end
