class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :form_url

  def form_url
    if controller_path == "your_spots"
      your_spot_path(@spot)
    else
      spots_path
    end
  end
end
