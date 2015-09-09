'use strict'
# ----------------------------------------------------------
# @: The Anh
# d: 141120
# f: Common controller -> get common info of system
# ----------------------------------------------------------
angular.module('AppSurvey').controller 'CommonCtrl', ['$scope', 'Common', ($scope, Common) ->
  # global variable
  $common = new Common()

  # public variable
  $scope.load_error = null
  $scope.load_result = null
  $scope.common = {}

  # public process
  $scope.run = ()->
    $common.getCatalog().then((res)->
      $scope.common = res
    )

  $scope.goToTop = ()->
    $("html, body").animate({scrollTop: '0px'}, 400)
    return

  $scope.locationReload = ()->
    location.reload()
    return

  return
]
.factory 'Common', ['$http', '$compile', '$q', '$templateCache', '$rails', '$timeout', '$translate', '$modal', 'Validate', 'Modal',
 ($http, $compile, $q, $templateCache, $rails, $timeout, $translate, $modal, Validate, Modal) ->
  # -------------------------
  # static variables
  $validate = new Validate()

  Common = ()->
    # private
    _is_filter  = false
    _is_get_url_search  = false
    _url        =
      catalog: $rails.root_url + 'api/v1/api_common1'
      common_references:$rails.root_url + 'api/v1/api_common2'

    _info =
      catalog: []
      location: []

    _loading=
      container: 'body'

    # public
    basic_info =
      #--- function system config
      getConfig: (type) ->
        config =
          paging:
            max_size: 5
            items_per_page: 10
          datetime:
            date_format: 'dd/mm/yy'
          image:
            avatar:
              class_name: 'avatar'
              container: '.avatar'
              open_modal: true
              aspect_ratio: 3/4
              cropper_min_width: 119
              cropper_min_height: 158
              max_size: 2048
              save_size:
                width: 119
                height: 158
            logo:
              class_name: 'company_logo'
              container: '.company_logo'
              open_modal: true
              aspect_ratio: 'auto'
              cropper_min_width: 90
              cropper_min_height: 120
              max_size: 2048
              save_size:
                width: 278
                height: 184
            company_images:
              class_name: 'company_images'
              container: '.company_image'
              open_modal: false
              max_size: 5120
              save_size:
                width: 480
                height: 480
            company_photo_panel:
              class_name: 'company_photo_panel'
              container: '.company_photo_panel'
              open_modal: false
              aspect_ratio: 10/3.5
              cropper_min_width: 300
              cropper_min_height: 105
              max_size: 5120*2
              save_size:
                width: 700
                height: 245

        return config[type] if config[type]
        return null

      # -- Search by key words
      searchByKeyword: (keyword)->
        self = this
        key_index = $rails.locale_sym || 'v'
        str_search = ''
        str_search = self.reduce_space_to_uri(keyword) if keyword != ''
        $rails.root_url + str_search + '-k' + key_index

      #--- function system catalog
      getCatalog: (arr_catalog, is_filter, is_get_url_search)->
        _is_filter = (if is_filter then is_filter else false)
        _is_get_url_search = (if is_get_url_search then is_get_url_search else false)

        deferred = $q.defer()
        url = _url.catalog
        $http.post(url,
          common:
            arr_catalog: arr_catalog
            is_filter: _is_filter
            is_get_url_search: _is_get_url_search
        ).then (response) ->
          data = $validate.parseResult(response)
          if data.status == 1
            _info = data.data
          deferred.resolve _info['catalog']
          return
        return deferred.promise

      #--- function system common info
      getCommon: () ->
        deferred = $q.defer()
        url = _url.common_references
        common = []
        $http.get(url).then (response) ->
          data = $validate.parseResult(response)
          if data.status == 1
            common = data.data
          deferred.resolve common
          return
        return deferred.promise

      #--- function alert result
      responseAlert: (data, is_hold) ->
        modal_process = ($scope, $modalInstance) ->
          # init alert message
          $scope.auth_success = null
          $scope.auth_reason = null
          $scope.auth_error = null

          # check data status to set alert status
          if data.status == 0
            $scope.auth_error = data.message
          else if data.status == 1
            $scope.auth_success = data.message
          else
            $scope.auth_reason = data.message

          # set close alert popup for manual events
          $scope.close = () ->
            $modalInstance.dismiss 'cancel'

          # set close alert popup for auto events
          if !is_hold
            delay = 5000
            $timeout(()->
              $modalInstance.dismiss 'cancel'
            , delay)

        auto_open = false
        modal = new Modal '', '', auto_open, modal_process, $.noop
        modal.alert()
        return

      #--- function alert result
      responseAlertDeffer: (data, is_hold) ->
        deferred = $q.defer()
        modal_process = ($scope, $modalInstance) ->
          # init alert message
          $scope.auth_success = null
          $scope.auth_reason = null
          $scope.auth_error = null

          # check data status to set alert status
          if data.status == 0
            $scope.auth_error = data.message
          else if data.status == 1
            $scope.auth_success = data.message
          else
            $scope.auth_reason = data.message

          # set close alert popup for manual events
          $scope.close = () ->
            deferred.resolve $modalInstance.dismiss 'cancel'

          # set close alert popup for auto events
          if !is_hold
            delay = 1000
            $timeout(()->
              deferred.resolve $modalInstance.dismiss 'cancel'
            , delay)

        auto_open = false
        modal = new Modal '', '', auto_open, modal_process, $.noop
        modal.alert()
        return deferred.promise

      #--- function create/ update data return full format
      changeDataActionNonConfirmReFull: (url_update, params, show_alert)->
        self = this
        deferred = $q.defer()
        is_show_alert = (if typeof(show_alert) == 'undefined' then true else show_alert)
        $http.post(url_update, params).then (response) ->
          data = $validate.parseResult response
          # alert result
          self.responseAlert data if is_show_alert
          deferred.resolve data
          return

        return deferred.promise

      #--- function create/ update data
      changeDataActionNonConfirm: (url_update, params, show_alert)->
        self = this
        deferred = $q.defer()
        is_show_alert = (if typeof(show_alert) == 'undefined' then true else show_alert)
        $http.post(url_update, params).then (response) ->
          data = $validate.parseResult response
          # alert result
          self.responseAlert data if is_show_alert
          deferred.resolve data.data
          return

        return deferred.promise

      #--- function delete data
      changeDataActionRequireConfirm: (url, params, html_confirm, show_alert, return_full) ->
        self = this
        deferred = $q.defer()
        is_show_alert = (if typeof(show_alert) == 'undefined' then true else show_alert)
        is_return_full = (if typeof(return_full) == 'undefined' then true else return_full)
        process = ($scope, $sce, $modalInstance, constants) ->
          $scope.title = constants.title
          $scope.custom_html = '<p translate="activerecord.delete"></p>'
          $scope.custom_html = html_confirm if html_confirm
          $scope.ok = ()->
            $http.post(url, params).then (response) ->
              data = $validate.parseResult response
              # alert result
              self.responseAlert data if is_show_alert
              unless is_return_full
                deferred.resolve data.data
              else
                deferred.resolve data
              return
            $modalInstance.close()
            return

          $scope.cancel = ()->
            deferred.resolve null
            $modalInstance.dismiss 'cancel'
            return

        auto_open = false
        modal_size = 'md'
        modal = new Modal('pages/template/dialog/confirm.html', $translate.instant('form.confirm'), auto_open, process, $.noop)
        modal.open modal_size, 'custom-size-confirm', 'static'
        return deferred.promise

      #--- function map array data to multi select directive
      mapArrayDataToMultiSelect: (source, arr_data) ->
        angular.forEach(source, (value, key)->
          value.ticked = false
          angular.forEach arr_data, (v, k)->
            if value.id == v.id
              value.ticked = true
              return
        )

      #--- function map data to multi select directive
      mapDataToMultiSelect: (source, data, arr_data_output) ->
        angular.forEach(source, (value, key)->
          value.ticked = false
          angular.forEach data, (v, k)->
            if value.id == parseInt v
              value.ticked = true
              arr_data_output.push value if arr_data_output
              return
        )

      #--- function escape utf-8 string to uri string
      escape_str_to_uri: (str)->
        str = str.toLowerCase()
        str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g,'a')
        str= str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g,'e')
        str= str.replace(/ì|í|ị|ỉ|ĩ/g,'i')
        str= str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g,'o')
        str= str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g,'u')
        str= str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g,'y')
        str= str.replace(/đ/g,'d')
        str= str.replace(/!|@|%|\^|\*|\(|\)|\+|\=|\<|\>|\?|\/|,|\.|\:|\;|\'| |\"|\&|\#|\[|\]|~|$|_|★|【|】/g,'-')
        # replace double '-' by single one
        str= str.replace(/-+-/g,'-')
        # remove final '-'
        str= str.replace(/^\-+|\-+$/g,'')
        return str

      #--- function escape special string to uri string
      reduce_space_to_uri: (str)->
        str= str.replace(/!|@|%|\^|\*|\(|\)|\+|\=|\<|\>|\?|\/|,|\.|\:|\;|\'| |\"|\&|\#|\[|\]|~|$|_|★|【|】/g,'-')
        # replace double '-' by single one
        str= str.replace(/-+-/g,'-')
        # remove final '-'
        str= str.replace(/^\-+|\-+$/g,'')
        return str

      # show loading
      showLoading: (container)->
        _loading.container = ''
        _loading.container = container if container
        $(_loading.container + ' .dir-loading').show()
        return

      # hide loading
      hideLoading: ()->
        $(_loading.container + ' .dir-loading').hide({effect: 'fade', easing: 'swing', duration: 2000})
        return

      # modal login
      openModalLogin: (scope)->
        $templateCache.put 'modal_login', 'pages/users/modal_login.html'
        return $modal.open(
          templateUrl: $templateCache.get 'modal_login'
          controller: "UsersCtrl"
          scope: scope
          windowClass: 'login-modal-mod'
        )

      # modal register job alert
      openModalRegisterJobAlert: (company_id, company_name, callback)->
        $templateCache.put 'modal_register_job_alerts', 'pages/template/dialog/modal_register_job_alerts.html'
        process = ($scope, $sce, $modalInstance, constants) ->
          $scope.title = constants.title
          $scope.company_id = company_id
          $scope.company_name = company_name
          $scope.ok = ()->
            callback($scope.email, $scope.company_id)
            $modalInstance.close()
            return

          $scope.cancel = ()->
            $modalInstance.dismiss 'cancel'
            return
        auto_open = false
        modal_size = null
        modal = new Modal($templateCache.get('modal_register_job_alerts'), $translate.instant('company.register_job_alert.title', company_name: company_name), auto_open, process, $.noop)
        modal.open modal_size
        return

  Common
]