class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def terms
    render "shared/terms"
  end

  def contact
    render "shared/contact"
  end

  def about
    render "shared/about"
  end
end
