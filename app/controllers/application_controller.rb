class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  include JsEnv
  include ApplicationHelper
  include TextHelper
  include Checker
  before_action :set_locale
  # before_filter :cors_preflight_check
  # before_action :set_locale, :set_meta_tags
  # after_filter :cors_set_access_control_headers

  # # ----------------------------------------------------------------------------------------
  # # @: The Anh
  # # d: 150106
  # # TODO: set meta tags
  # # ----------------------------------------------------------------------------------------
  # def set_meta_tags
  #   @meta_information = meta_tags
  # end

  # ----------------------------------------------------------------------------------------
  # @:
  # d: 150101
  # TODO: multi language functions
  # ----------------------------------------------------------------------------------------
  def set_locale
    I18n.locale = I18n.default_locale
    I18n.locale = session[:language] if session[:language].present?
  end

  # For all responses in this controller, return the CORS access control headers.
  # http://blog.rudylee.com/2013/10/29/rails-4-cors/
  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.
  # http://blog.rudylee.com/2013/10/29/rails-4-cors/
  def cors_preflight_check
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  # before_filter do
  #   ip_text = request.env["HTTP_X_FORWARDED_FOR"] || request.ip
  #   logger.debug("ACCESS FROM #{ip_text.to_s}")
  # end

  class AccessDenied < StandardError; end

  rescue_from AccessDenied, :with => :access_denied

  around_filter :set_time_zone

  private

    def access_denied
      render :layout => false, :template => 'front/errors/error_403'
    end

    def set_time_zone
      old_time_zone = Time.zone
      begin
        Time.zone = browser_timezone if browser_timezone.present?
        yield
      rescue
        Time.zone = old_time_zone
        raise
      end
    end

    def browser_timezone
      cookies['browser.timezone']
    end
end
