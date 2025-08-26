class SuperAdmin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :authorized_only
  layout "super_admin/layouts/application"

  private

  def authorized_only
    redirect_to root_path unless current_user&.super_admin?
  end
end
