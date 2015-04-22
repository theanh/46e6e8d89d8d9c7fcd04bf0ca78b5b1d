class Front::ContestsController < FrontController
  helper_method :survey, :participantFront

  def survey
    @survey ||= Survey::Survey.active.first
    if @survey && @survey.questions.length > 0
      @arr_chk_valid_questions = @survey.questions.collect { |item|  item['id'] }.compact.as_json
      render 'front/contests/attempts/new'
    else
      render 'front/contests/attempts/alert_empty'
    end
  end

  def survey_result
    @survey ||= Survey::Survey.active.first
    if @survey
      render 'front/contests/attempts/result'
    else
      render 'front/contests/attempts/alert_empty'
    end
  end
end