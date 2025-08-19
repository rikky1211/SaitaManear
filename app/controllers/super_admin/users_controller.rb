class SuperAdmin::UsersController < ApplicationController
  layout "super_admin/layouts/application"
  before_action :authenticate_user!, only: %i[show edit update]
  def index; end
end
