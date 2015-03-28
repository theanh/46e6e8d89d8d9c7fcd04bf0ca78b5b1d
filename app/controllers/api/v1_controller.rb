class Api::V1Controller < ApiController
  # ###################
  # #### COMMON    ####
  # ###################
  # VALIDATE_COMMON = {
  #     'arr_catalog' => {'type' => 'array', 'require' => {'catalog' => true}},
  #     'is_filter' => {'type' => 'boolean', 'require' => {'catalog' => true}},
  #     'is_get_url_search' => {'type' => 'boolean', 'require' => {}}
  # }
  # # ----------------------------------------------------------------------------------------
  # # @: The Anh
  # # d: 14/11/20
  # # TODO: get common info
  # # method: post
  # # ----------------------------------------------------------------------------------------
  # def api_common1
  #   # check params
  #   validated_param = validateParam(VALIDATE_COMMON, params[:common], 'catalog')
  #   return if validated_param['failed']

  #   info = {}
  #   if validated_param['arr_catalog']
  #     info['catalog'] = {}
  #     validated_param['arr_catalog'].each do | f |
        
  #     end
  #   end

  #   render_success(info) and return
  # end

  private
end