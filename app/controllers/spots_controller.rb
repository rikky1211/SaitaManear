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
    puts ""
    puts "-------------------------------------------------------"
    puts "ENVバケット: #{ENV['AWS_S3_BUCKET_NAME']}"
    puts "Rails.env: #{Rails.env}"
    puts "実際に使われるバケット: #{ENV['AWS_S3_BUCKET_NAME']}-#{Rails.env}"
    puts "-------------------------------------------------------"
    puts ""

    @spot = Spot.new(spot_params)
    @spot.user = current_user
    # @spot.town = Town.find(spot_params[:town_id])
      if @spot.save
        redirect_to @spot, notice: "スポットが登録されました"
      else
        puts params
        render :new
      end
  end

  private

  def spot_params
    params.require(:spot).permit(:name, :spot_image, :summary, :latitude, :longitude, :town_id)
  end
end
