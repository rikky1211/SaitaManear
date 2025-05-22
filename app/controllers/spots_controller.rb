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
    puts "-----------------------------------------"
    puts "フラッシュメッセージ追加しよう"
    puts "-----------------------------------------"
      redirect_to @spot, notice: "スポットを登録しました"
    else
    puts "-----------------------------------------"
    puts "フラッシュメッセージ追加しよう"
    puts "-----------------------------------------"
      render :new
    end
  end

  def update
    puts "-----------------------------------------"
    puts params
    puts "-----------------------------------------"

    @spot = current_user.spots.find_by(id: params[:id])

    if @spot.update(spot_params)
      redirect_to @spot, notice: "スポットを更新しました"
    else
      puts "もう一度入力してね"
      render :edit
    end
  end

  private

  def spot_params
    # 市区町村プルダウン、実装見送りのため 「, :town_id」 削除
    params.require(:spot)&.permit(:name, :spot_image, :summary, :latitude, :longitude)
  end
end
