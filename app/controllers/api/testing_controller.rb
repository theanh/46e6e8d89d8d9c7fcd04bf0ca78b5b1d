class Api::TestingController < ApiController
  def index
    method = params[:p1]
    return render_failed(2, 'invalid parameter') if method.nil?

    args = []
    (2..10).each do |i|
      val = params["p#{i}".to_sym]
      break if val.nil?
      args << val
    end

    result = eval "Tool.#{method}(*args)"
    render_success(result)
  end

end