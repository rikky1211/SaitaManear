class SuperAdmin::UsersController < SuperAdmin::BaseController
  layout "super_admin/layouts/application"
  before_action :authenticate_user!, only: %i[index show edit update destroy]
  def index
    @users = User.all
  end

  def show

  end

  def edit
    
  end

  def update

  end

  def destroy
  end 

end
