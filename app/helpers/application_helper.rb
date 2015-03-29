module ApplicationHelper
  # # ----------------------------------------------------------------------------------------
  # # @: The Anh
  # # d: 150106
  # # TODO: add meta tags
  # # ----------------------------------------------------------------------------------------
  # def meta_tags()
  #   meta_information = {}
  #   meta_information['title'] = 'Tìm kiếm việc làm và Tuyển dụng nhanh - StepUpHR.vn'
  #   meta_information['description'] = 'StepUpHR.vn - Mạng Việc làm & tuyển dụng uy tín tại Việt Nam. Tìm việc làm và ứng tuyển ngay việc làm mới từ nhà tuyển dụng hàng đầu tại Việt Nam.'
  #   meta_information['keywords'] = 'Việc làm, tìm việc làm, tuyển dụng, ứng viên,  mạng tuyển dụng, việc làm online, việc làm bán thời gian'
  #   meta_information['image'] = Rails.application.routes.url_helpers.root_url + ActionController::Base.helpers.image_url('settings/common/logo.png')
  #   meta_information['url'] = ''
  #   meta_information['title_name'] = 'StepUpHR.vn'
  #   meta_information['canon_url'] = '#'
  #   return meta_information
  # end

  # ----------------------------------------------------------------------------------------
  # @:
  # d: 141030
  # TODO: validate email
  # ----------------------------------------------------------------------------------------
  def valid_email?(email)
    email.present? &&
        (email =~ /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/)
  end

  # ----------------------------------------------------------------------------------------
  # @: The Anh
  # d: 140930
  # TODO: Force string convert to date, catch error
  # ----------------------------------------------------------------------------------------
  def str_convert_to_date(str)
    result = 0
    begin
      # result = Time.parse(str) {|year| year + (year < 70 ? 2000 : 1900)} unless str.blank?
      result = Time.parse(str) unless str.blank?
    rescue ArgumentError
      p ArgumentError
    end

    return result
  end

  # ----------------------------------------------------------------------------------------
  # @: The Anh
  # d: 140930
  # TODO: Force struct convert hash, catch error
  # ----------------------------------------------------------------------------------------
  def struct_to_hash(struct)
    result = {}
    begin
      result = JSON.parse(struct.to_json)
    rescue ArgumentError
      p ArgumentError
    end

    return result
  end

  # ----------------------------------------------------------------------------------------
  # @: The Anh
  # d: 140930
  # TODO: Force collection convert to hash, catch error
  # ----------------------------------------------------------------------------------------
  def collection_to_hash(collection)
    return collection.to_a.map(&:serializable_hash)
  end

  # ----------------------------------------------------------------------------------------
  # @: The Anh
  # d: 140930
  # TODO: Force string convert to url
  # ----------------------------------------------------------------------------------------
  def generate_url(str)
    str = escape_str_to_uri(str)

    # add locale symbol in the end of url
    locale_sym = I18n.locale.to_s[0, 1]
    str += locale_sym unless locale_sym.nil? && locale_sym != ''
    return str
  end

  # ----------------------------------------------------------------------------------------
  # @: The Anh
  # d: 140930
  # TODO: Force string convert to uri
  # ----------------------------------------------------------------------------------------
  def escape_str_to_uri(str)
    str = str.mb_chars.downcase
    str = str.gsub(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/,'a')
    str= str.gsub(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/,'e')
    str= str.gsub(/ì|í|ị|ỉ|ĩ/,'i')
    str= str.gsub(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/,'o')
    str= str.gsub(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/,'u')
    str= str.gsub(/ỳ|ý|ỵ|ỷ|ỹ/,'y')
    str= str.gsub(/đ/,'d')
    str= str.gsub(/!|@|%|\^|\*|\(|\)|\+|\=|\<|\>|\?|\/|,|\.|\:|\;|\'| |\"|\&|\#|\[|\]|~|$|_|★|【|】/,'-')
    # replace double '-' by single one
    str= str.gsub(/-+-/,'-')
    # remove final '-'
    str= str.gsub(/^\-+|\-+$/,'')
    return str
  end

  # --------------------------------------------------
  # @: The Anh
  # d: 150205
  # f: Capitalize first character of each words
  # link: http://stackoverflow.com/questions/13520162/ruby-capitalize-every-word-first-letter
  # --------------------------------------------------
  def ft_capitalize(str)
    return str.mb_chars.split.map(&:capitalize)*' '
  end

  # ----------------------------------------------------------------------------------------
  # @:
  # d: 141024
  # TODO: Render websites' result
  # ----------------------------------------------------------------------------------------
  def render_success(object = nil, message = nil, response_type = 'json')
    hash = { status: 1 }
    hash[:data] = object
    hash[:message] = message unless message.nil?
    if response_type == 'json'
      render json: JSON.pretty_generate(JSON.parse(hash.to_json))
    elsif response_type == 'html'
      render text: JSON.pretty_generate(JSON.parse(hash.to_json))
    end
  end

  def render_failed(reason_number, message, response_type = 'json')
    hash = { status: reason_number, message: message }
    if response_type == 'json'
      render json: JSON.pretty_generate(JSON.parse(hash.to_json))
    elsif response_type == 'html'
      render text: JSON.pretty_generate(JSON.parse(hash.to_json))
    end
  end

  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end
    #message = exception.message

    #unless Rails.env == 'production'
    message = "#{exception.message}\n#{exception.backtrace.join("\n")}"
    #end

    render_failed(0, message)
  end

  def render_failed_by_no_login(message = I18n.t('common.error.no_login'), response_type = 'json')
    render_failed(102, message, response_type = 'json')
  end

  def render_failed_by_missing_params(message = I18n.t('common.error.missing_param'), response_type = 'json')
    render_failed(100, message, response_type = 'json')
  end

  def render_failed_invalid_params(message = I18n.t('common.error.not_valid'), response_type = 'json')
    render_failed(101, message, response_type = 'json')
  end

  def render_failed_by_required_operator(message = I18n.t('common.error.require_permission'), response_type = 'json')
    render_failed(103, message, response_type = 'json')
  end

  # -----------------------------------
  # Global time helper
  # 2013/09/13 cinqsmile tokyo isobe
  # article_date(datetime)
  # => article_date(2013/09/13 17:47:28 +0900)
  # => 05:47 PM
  # => article_date(2013/09/13 17:47:28 +0900,false)
  # => Fri, 13 Sep 2013 17:47:28 +0900
  # -----------------------------------
  def format_article_date(datetime, short=true, format='%I:%M %p')
    return nil unless datetime
    now = Time.now
    if short
      if datetime.today?
        datetime.strftime('%I:%M %p')
      elsif now.yesterday.beginning_of_day < datetime && datetime < now.yesterday.end_of_day
        "#{I18n.t('time.yesterday')} #{datetime.strftime(format)}"
      elsif format != '%I:%M %p'
        datetime.strftime(format)
      else
        "#{I18n.t('date.abbr_month_names')[datetime.month]} #{datetime.day}, #{datetime.year}"
      end
    else
      I18n.l(datetime)
    end
  end

   # def omniauth_authorize_path(resource_name, provider)
   #   send "#{resource_name}_omniauth_authorize_path", provider
   # end

  # def valid_year?(year)
  #   year.present? && (year.to_i.in? 1900..Date.today.year)
  # end

  # def valid_month?(month)
  #   month.present? && (month.to_i.in? 1..12)
  # end

  # def split_string(string)
  #   string.split(' ').split('　')
  # end

  def convert_currency(number, option = {delimiter: ',', precision: 0, format: '%n'})
    return ActiveSupport::NumberHelper.number_to_currency(number, option)
  end

end
