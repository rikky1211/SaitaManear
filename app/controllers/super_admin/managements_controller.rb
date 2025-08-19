class SuperAdmin::ManagementsController < SuperAdmin::BaseController
  layout "super_admin/layouts/application"
  before_action :authenticate_user!, only: %i[index]
  def index
  end
end
