class SuperAdmin::ManagementsController < SuperAdmin::BaseController
  before_action :authenticate_user!, only: %i[index]
  def index
  end
end
