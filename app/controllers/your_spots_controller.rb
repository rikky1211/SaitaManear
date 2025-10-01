class YourSpotsController < ApplicationController
  before_action :authenticate_user!, only: %i[index edit update destroy favorites]

  def index
    @spots = current_user.spots.page(params[:page])
  end

  def edit
    @spot = current_user.spots.find(params[:id])
    
    rescue ActiveRecord::RecordNotFound
      redirect_to your_spots_path, alert: "編集権限がないか、スポットが見つかりません"
  end

  def update
    @spot = current_user.spots.find(params[:id])

    if @spot.update(spot_params)
      redirect_to spot_path(@spot), notice: "スポットを更新しました"
    else
      flash.now[:error] = "スポットを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end

    rescue ActiveRecord::RecordNotFound
      redirect_to your_spots_path, alert: "更新権限がないか、スポットが見つかりません"
  end

  def destroy
    spot = current_user.spots.find(params[:id])
    if spot.spot_image.attached?
      spot.spot_image.purge
    end
    spot.destroy!
    redirect_to your_spots_path, notice: "スポットを削除しました"
    rescue ActiveRecord::RecordNotFound
      redirect_to your_spots_path, alert: "削除権限がないか、スポットが見つかりません"
  end

  def favorites
    @spots = current_user.favorite_to_spots.page(params[:page])

    # 使い方用スポットを1つだけ抽出
    @spot = Spot.order("RANDOM()").first
  end

private

  def spot_params
    params.require(:spot)&.permit(:name, :spot_image, :summary, :latitude, :longitude)
  end
end
