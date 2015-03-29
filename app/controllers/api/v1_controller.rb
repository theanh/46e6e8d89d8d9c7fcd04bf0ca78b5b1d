class Api::V1Controller < ApiController
  # ---------------------------------------------------------------------------------
  # @: The Anh
  # d: 150329
  # TODO: submit survey
  # method: post
  # ---------------------------------------------------------------------------------
  def api_survey1
    # check params
    render_failed(100, t('common.error.missing_param', {obj: 'survey'})) and return if params[:survey].nil?
    render_failed(100, t('common.error.missing_param', {obj: 'survey id'})) and return if params[:survey][:survey_id].nil?
    render_failed(100, t('common.error.missing_param', {obj: 'user email'})) and return if params[:survey][:email].nil?
    render_failed(100, t('common.error.missing_param', {obj: 'user name'})) and return if params[:survey][:name].nil?
    render_failed(100, t('common.error.missing_param', {obj: 'question'})) and return if params[:survey][:question].nil?

    survey = Survey::Survey.active.find_by(:id => params[:survey][:survey_id].to_i.abs)
    render_failed(100, t('common.error.not_found', {obj: 'survey'})) and return if survey.nil?
    attempt = survey.attempts.new
    # check user exist?
    user = User.find_by(:email => params[:survey][:email])
    if user.nil?
      # create new if not exist
      user = User.create!(
        email: params[:survey][:email], 
        name: params[:survey][:name]
      )
    end
    # set participant
    attempt.participant = user
    attempt.save!
    params[:survey][:question].each do |question|
      question[1].each do |op|
        if op[1]
          attempt.answers.create!(
            question_id: question[0],
            option_id: op[0]
          )
        end
      end
    end
    render_success(attempt.answers) and return
  end

  # ---------------------------------------------------------------------------------
  # @: The Anh
  # d: 150329
  # TODO: get survey result
  # method: post
  # ---------------------------------------------------------------------------------
  def api_survey2
    # check params
    render_failed(100, t('common.error.missing_param', {obj: 'survey'})) and return if params[:survey].nil?
    render_failed(100, t('common.error.missing_param', {obj: 'survey id'})) and return if params[:survey][:survey_id].nil?
    render_failed(100, t('common.error.missing_param', {obj: 'question id'})) and return if params[:survey][:question_id].nil?
    survey = Survey::Survey.active.find_by(:id => params[:survey][:survey_id].to_i.abs)
    render_failed(100, t('common.error.not_found', {obj: 'survey'})) and return if survey.nil?
    question = survey.questions.find_by(:id => params[:survey][:question_id].to_i.abs)
    render_failed(100, t('common.error.not_found', {obj: 'question'})) and return if question.nil?

    info = Survey::Option.joins("left join `survey_answers` on `survey_answers`.`option_id` = `survey_options`.`id` AND `survey_answers`.`deleted_at` IS NULL").where(:question_id => params[:survey][:question_id].to_i.abs).group('`survey_options`.`id`').count('survey_answers.id')
    render_success(info) and return
    # # test
    # Survey::Option.joins("left join `survey_answers` on `survey_answers`.`option_id` = `survey_options`.`id` AND `survey_answers`.`deleted_at` IS NULL").where(:question_id => 1).group('`survey_options`.`id`').count('survey_answers.id')
  end

  private
end