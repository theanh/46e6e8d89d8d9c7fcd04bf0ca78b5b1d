class Front::ErrorsController < FrontController
  #layout false
  def error_403
    render :status => 403, :formats => [:html]
  end

  def error_404
    render :status => 404, :formats => [:html]
  end

  def error_500
    render :status => 500, :formats => [:html]
  end

  def error_503
    render :status => 503, :formats => [:html]
  end
end
