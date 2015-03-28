
class Api::V1Controller < ApiController
  ###################
  #### COMMON    ####
  ###################
  VALIDATE_COMMON = {
      'arr_catalog' => {'type' => 'array', 'require' => {'catalog' => true}},
      'is_filter' => {'type' => 'boolean', 'require' => {'catalog' => true}},
      'is_get_url_search' => {'type' => 'boolean', 'require' => {}}
  }
  # ----------------------------------------------------------------------------------------
  # @: The Anh
  # d: 14/11/20
  # TODO: get common info
  # method: post
  # ----------------------------------------------------------------------------------------
  def api_common1
    # check params
    validated_param = validateParam(VALIDATE_COMMON, params[:common], 'catalog')
    return if validated_param['failed']

    # process
    is_filter = validated_param['is_filter'] ? validated_param['is_filter']: false
    is_get_url_search = validated_param['is_get_url_search'] ? validated_param['is_get_url_search']: false

    info = {}
    if validated_param['arr_catalog']
      info['catalog'] = {}
      validated_param['arr_catalog'].each do | f |
        if f == 'categories'
          info['catalog']['categories'] = {}
          if is_filter
            info['catalog']['categories'] = Category.all.uniq.order(:sort_no => :asc).as_json(:only => [:id], methods: [:locale_name, :text])
          elsif is_get_url_search
            info['catalog']['categories'] = Category.all.uniq.order(:sort_no => :asc).as_json(:only => [:id], methods: [:locale_name, :url_search_by_category])
          else
            info['catalog']['categories'] = Category.all.uniq.order(:sort_no => :asc).as_json
          end
        end

        if f == 'locations'
          info['catalog']['locations'] = {}
          if is_filter
            info['catalog']['locations'] = Location.all.uniq.order(:sort_no => :asc).as_json(:only => [:id], methods: [:locale_name, :text])
          else
            info['catalog']['locations'] = Location.all.uniq.order(:sort_no => :asc).as_json
          end
        end

        if f == 'job_level'
          info['catalog']['job_level'] = {}
          if is_filter
            info['catalog']['job_level'] = JobLevel.all.uniq.order(:sort_no => :asc).as_json(:only => [:id], methods: [:locale_name, :text])
          else
            info['catalog']['job_level'] = JobLevel.all.uniq.order(:sort_no => :asc).as_json
          end
        end

        if f == 'languages'
          info['catalog']['languages'] = {}
          if is_filter
            info['catalog']['languages'] = Language.all.uniq.order(:sort_no => :asc).as_json(:only => [], methods: [:locale_name, :text])
          else
            info['catalog']['languages'] = Language.all.uniq.order(:sort_no => :asc).as_json
          end
        end

        if f == 'language_levels'
          info['catalog']['language_levels'] = {}
          if is_filter
            info['catalog']['language_levels'] = LanguageLevel.all.uniq.order(:sort_no => :asc).as_json(:only => [:id], methods: [:locale_name, :text])
          else
            info['catalog']['language_levels'] = LanguageLevel.all.uniq.order(:sort_no => :asc).as_json
          end
        end

        if f == 'education_levels'
          info['catalog']['education_levels'] = {}
          if is_filter
            info['catalog']['education_levels'] = EducationLevel.all.uniq.order(:sort_no => :asc).as_json(:only => [:id], methods: [:locale_name, :text])
          else
            info['catalog']['education_levels'] = EducationLevel.all.uniq.order(:sort_no => :asc).as_json
          end
        end
      end
    end

    render_success(info) and return
  end

  private
  ###################
  #### USERS     ####
  ###################
  def update_user(validated_param)
    user = User.find_by(:id => validated_param['id'].to_i.abs)
    if user && validated_param['image'] != ''
      user.update!(
          accessibility: validated_param['accessibility'],
          notification_email_flags: validated_param['notification_email_flags'],
          image: validated_param['image'],
          profile: validated_param['profile']
      )
      return user.as_json
    else
      user.update!(
          accessibility: validated_param['accessibility'],
          notification_email_flags: validated_param['notification_email_flags'],
          profile: validated_param['profile']
      )
      return user.as_json
    end
    return nil
  end

  ###################
  #### COMPANY   ####
  ###################
  def requireOperatorPermission
    return true unless current_user.is_operator?
    return false
  end

  ###################
  #### SUPPORTER ####
  ###################
  def requireAdminPermission
    return true if current_user && current_user.type != User::USER_ADMIN
    return false
  end
end