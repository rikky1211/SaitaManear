class SuperAdmin::SpotsController < SuperAdmin::BaseController
  def index
    @spots = Spot.all
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def edit
    @spot = Spot.find(params[:id])
  end

  def update
    @spot = Spot.find(params[:id])
    if @spot.update(spot_params)
      redirect_to super_admin_spot_path(@spot), notice: "スポットを更新しました"
    else
      flash.now[:error] = "スポットを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def spot_params
    params.require(:spot).permit(:name, :spot_image, :summary, :latitude, :longitude)
  end

end
