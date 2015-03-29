class ApiController < ApplicationController
  respond_to :json
  rescue_from Exception, :with => :render_500
  layout false
end