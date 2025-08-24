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
  end

  def new
  end

  def destroy
  end

end
