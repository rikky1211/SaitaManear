class SuperAdmin::ManagerSessionsController < SuperAdmin::BaseController
  layout "super_admin/layouts/application"
  before_action :authenticate_user!, only: %i[new]
  def new; end
end
