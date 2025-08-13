class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  protect_from_forgery with: :exception
  
  before_action :load_categories
  
  private
  
  def load_categories
    @categories = Category.includes(:softwares).ordered
  end
  
  def authenticate_admin!
    return if admin_signed_in?
    
    authenticate_or_request_with_http_basic('Admin Area') do |username, password|
      username == ENV.fetch('ADMIN_USERNAME', 'admin') && 
      password == ENV.fetch('ADMIN_PASSWORD', 'password')
    end
  end
  
  def admin_signed_in?
    session[:admin_authenticated] == true ||
    authenticate_with_http_basic { |u, p| 
      u == ENV.fetch('ADMIN_USERNAME', 'admin') && 
      p == ENV.fetch('ADMIN_PASSWORD', 'password')
    }
  end
end
