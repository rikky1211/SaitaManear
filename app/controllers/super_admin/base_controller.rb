class SuperAdmin::BaseController < ApplicationController
  before_action :authorized_only
  layout "super_admin/layouts/application"

  private

  def not_authenticated
    flash[:warning] = t('defaults.flash_message.require_login')
    redirect_to admin_login_path
  end

  def authorized_only
    redirect_to root_path unless current_user.super_admin?
  end
end
