class YourProfilesController < ApplicationController
  def show
    @user = current_user
    puts @user.name
    puts @user.email
  end

  def edit
    @user = current_user
  end
end
