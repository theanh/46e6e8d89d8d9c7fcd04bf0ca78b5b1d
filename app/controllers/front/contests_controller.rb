class Front::ContestsController < FrontController
  helper_method :survey, :participantFront

  def survey
    @survey ||= Survey::Survey.active.first
    render 'front/contests/attempts/new'
  end

  def survey_result
    @survey ||= Survey::Survey.active.first
    render 'front/contests/attempts/result'
  end
end