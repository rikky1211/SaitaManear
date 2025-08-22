class SuperAdmin::UsersController < SuperAdmin::BaseController
  layout "super_admin/layouts/application"
  before_action :authenticate_user!, only: %i[index show edit update destroy]
  def index
    @users = User.all
  end

  def show

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to super_admin_users_path, notice: "成功：ユーザ情報を修正しました"
    else
      flash.now[:error] = "失敗：ユーザ情報を修正できませんでした"
      render :edit, status: :unprocessable_entity
    end

  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    redirect_to super_admin_users_path, notice: "成功：ユーザ情報を削除しました"
  end 

  private
  
  def user_params
    params.require(:user).permit(:id, :name, :email, :role)
  end

end
