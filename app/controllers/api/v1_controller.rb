class Api::V1Controller < ApiController
  ###################
  #### COMMON    ####
  ###################
  VALIDATE_SURVEY = {
    'email' => {'type' => 'email', 'require' => {'survey' => true}},
    'name' => {'type' => 'string', 'require' => {'survey' => true}},
    'question' => {'type' => 'array', 'require' => {'survey' => true}},
  }
  # ----------------------------------------------------------------------------------------
  # @: The Anh
  # d: 150329
  # TODO: submit survey
  # method: post
  # ----------------------------------------------------------------------------------------
  def api_survey1
    # render_success(params[:survey]) and return
    # check params
    validated_param = validateParam(VALIDATE_SURVEY, params[:survey], 'survey')
    return if validated_param['failed']
    render_success(validated_param) and return

    attempt = survey.attempts.new
    # # info = {}
    # # if validated_param['arr_catalog']
    # #   info['catalog'] = {}
    # #   validated_param['arr_catalog'].each do | f |
        
    # #   end
    # # end

    # render_success(info) and return
  end

  private
end