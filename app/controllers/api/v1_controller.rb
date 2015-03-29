class Api::V1Controller < ApiController
  ###################
  #### COMMON    ####
  ###################
  VALIDATE_SURVEY = {
    'survey_id' => {'type' => 'int', 'require' => {'survey' => true}},
    'email' => {'type' => 'email', 'require' => {'survey' => true}},
    'name' => {'type' => 'string', 'require' => {'survey' => true}},
    'question' => {'type' => 'array', 'require' => {}}
  }
  # ----------------------------------------------------------------------------------------
  # @: The Anh
  # d: 150329
  # TODO: submit survey
  # method: post
  # ----------------------------------------------------------------------------------------
  def api_survey1
    # check params
    p params[:survey]
    validated_param = validateParam(VALIDATE_SURVEY, params[:survey], 'survey')
    return if validated_param['failed']
    p validateParam
    # validateParam['questions'].each_with_index do |question, index|
    #   p 'adssad'
    #   p question
    # end
    render_success(validated_param) and return

    # survey = Survey::Survey.active.find_by(:id => validated_param['survey_id'])
    # attempt = survey.attempts.new

    # # check user exist?
    # user = User.find_by(:email => validated_param['email'])
    # if user.nil?
    #   # create new if not exist
    #   user = User.create!(
    #     email: validated_param['email'], 
    #     name: validated_param['name']
    #   )
    # end
    # # set participant
    # attempt.participant = user
    # validateParam['questions'].each_with_index do |question_id, index|
    #   attempt.answers.create!(
    #     question_id: question_id,
    #     option_id: index
    #   )
    # end
    # render_success(info) and return
  end

  private
end