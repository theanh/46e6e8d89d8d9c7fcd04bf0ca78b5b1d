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
    render_failed(104, t('common.error.not_found', {obj: 'survey'})) and return if survey.nil?
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

    # begin transaction
    ActiveRecord::Base.transaction do
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
		end
		# end transaction
    render_success(attempt.answers) and return if attempt.answers
    render_failed(105, t('common.error.unexpectedly')) and return
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
    survey = Survey::Survey.active.find_by(:id => params[:survey][:survey_id].to_i.abs)
    render_failed(104, t('common.error.not_found', {obj: 'survey'})) and return if survey.nil?

    info = Survey::Option.joins("left join `survey_answers` on `survey_answers`.`option_id` = `survey_options`.`id` AND `survey_answers`.`deleted_at` IS NULL")
      .group('`survey_options`.`id`').select('count(`survey_answers`.`id`) as count, `survey_options`.`id` as id, `survey_options`.`text` as option_text, `survey_options`.`question_id` as question_id')
    render_success(info) and return
    # # test
    # Survey::Option.joins("left join `survey_answers` on `survey_answers`.`option_id` = `survey_options`.`id` AND `survey_answers`.`deleted_at` IS NULL").where(:question_id => 1).group('`survey_options`.`id`').select('count(`survey_answers`.`id`) as count, `survey_options`.`id` as id, `survey_options`.`text` as option_text')
  end

  private
end