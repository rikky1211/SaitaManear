class YourProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(your_profile_params)
    puts "----------------------------------------------------"
    puts "フラッシュメッセージを追加しよう"
    puts "----------------------------------------------------"
      redirect_to your_profile_path, notice: "プロフィールを更新しました"
    else
    puts "----------------------------------------------------"
    puts "フラッシュメッセージを追加しよう"
    puts "----------------------------------------------------"
      render :edit
    end
  end

  private

  def your_profile_params
    params.require(:user).permit(:name)
  end
end
