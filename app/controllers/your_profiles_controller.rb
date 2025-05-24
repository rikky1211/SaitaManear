class YourProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[show edit update]

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(your_profile_params)
      redirect_to your_profile_path, notice: "プロフィールを更新しました"
    else
      flash.now[:error] = "アカウント名変更に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def your_profile_params
    params.require(:user).permit(:name)
  end
end
