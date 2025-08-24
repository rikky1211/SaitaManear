class SuperAdmin::SpotsController < SuperAdmin::BaseController
  def index
    @spots = Spot.all
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def edit
  end

  def new
  end

  def update
  end

  def destroy
  end

end
