class YourProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[show edit update]

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    # パスワードが存在すればパスワード更新
    if your_profile_params[:password].present?
      judge = @user.update_with_password(your_profile_params)
    else
      judge = @user.update(your_profile_params.except(:password, :password_confirmation, :current_password))
    end

    # judgeにはtrue.falseが入ってる
    if judge
      redirect_to user_profile_path, notice: "プロフィールを更新しました"
    else
      puts "#{@user.errors.full_messages.join(",")}"
      flash.now[:alert] = "プロフィールの更新に失敗しました"
      render "users/registrations/edit", status: :unprocessable_entity

    end
  end

  private

  def your_profile_params
    params.require(:user)&.permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end
