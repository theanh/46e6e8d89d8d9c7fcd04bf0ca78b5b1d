# ----------------------------------------------------------
# @: The Anh
# d: 141126
# f: seeker action controller
# ----------------------------------------------------------
angular.module('AppSurvey').controller 'UsersCtrl', ($location, $window, $http, $templateCache, $state, $scope, $translate, $rails, Common, Session, Validate, User) ->
  'use strict'
  # --------------------------------------------------------
  # private variable
  $validate = new Validate()
  $common = new Common
  $user = null

  # link call api
  _url =
    logged_in: $rails.root_url
    company_logged_in: $rails.root_url + 'company/index'
    company_manager_job: $rails.root_url + 'company/my-job'
    reset_password: $rails.root_url + 'api/v1/api_user9'
    change_password: $rails.root_url + 'api/v1/api_user16'

  # --------------------------------------------------------
  # public variable
  $scope.submitted = false # variable set state submitted
  $scope.load_error = null
  $scope.load_result = null
  $scope.seeker =
    count: 0
  $scope.url_logged_in = _url.logged_in
  $scope.url_company_logged_in = _url.company_logged_in

  # -- get config
  $scope.config = {}
  $scope.config.paging = $common.getConfig 'paging'

  # --------------------------------------------------------
  # public process
  #--- login
  $scope.login = (user, is_redirect) ->
    unless $scope.submitted
      unless user.email || user.password
        return false
      $scope.submitted = true
      $scope.auth_error = null
#      if user.type && user.type == 'company'
#        _url.logged_in = _url.company_logged_in
      $common.showLoading('.container_login_loading')
      Session.login(user.email, user.password, user.remember).then ((response) ->
        $common.hideLoading()
        if response.data.type == 'UserType::Normal'
          if is_redirect == false
            url_href = $window.location.reload()
          else
            url_href = _url.logged_in
        else
          url_href = _url.company_manager_job
        if response.status is 1
          $common.responseAlertDeffer(response).then ()->
            $window.location.href = url_href
        else
          $scope.auth_error = response.message
        $scope.submitted = false
        return
      ), (response) ->
        $scope.auth_error = $translate.instant 'api.message.error.server_offline'
        $common.hideLoading()
        $scope.submitted = false
        return

    return

  #--- register
  $scope.register = (user) ->
    if user
      unless $scope.submitted
        $scope.show_result = false
        $scope.submitted = true
        $scope.auth_error = null
        unless user.password || user.confirm_password
          $scope.submitted = false
          return false
        if user.password != user.confirm_password
          $scope.submitted = false
          return
        $common.showLoading('.container_register_loading')
        Session.register(user.email, user.password, user.confirm_password).then ((response) ->
          $common.hideLoading()
          $scope.submitted = false
          unless response.status is 1
            $scope.auth_error = response.message
          else
            $scope.show_result = true
            $scope.auth_success = response.message
          return
        ), (response) ->
          $common.hideLoading()
          errors = ''
          $.each response.data.errors, (index, value) ->
            errors += index.substr(0, 1).toUpperCase() + index.substr(1) + ' ' + value + ''
            return
          $scope.auth_error = errors
          $scope.submitted = false
          return
      $common.hideLoading()
    return

  #--- forgotPassword
  $scope.forgotPassword = (user, form) ->
    if user
      $common.showLoading('.container_forgot_password_loading')
      unless $scope.submitted
        $scope.submitted = true
        $scope.show_result = false
        unless user || user.email
          $scope.auth_error = $translate.instant 'user.error.password_not_match'
          $scope.submitted = false
          return false
        Session.reset_password(user.email).then ((response) ->
          $scope.submitted = false
          unless response.status is 1
            $scope.auth_error = response.message
          else
            $scope.show_result = true
            $scope.auth_success = response.message
          $common.hideLoading()
          return
        )
        $common.hideLoading()
    return

  # Init reset password
  $scope.initResetPassword = (token)->
    $scope.token = token

  # Reset password
  $scope.resetPassword = () ->
    unless $scope.submitted
      $scope.submitted = true
      $scope.show_result = false
      unless $scope.password || $scope.confirmation_password
        $scope.submitted = false
        return false
      if $scope.password != $scope.confirmation_password
        $scope.auth_error = $translate.instant 'user.error.password_not_match'
        $scope.submitted = false
        return false
      $scope.showLoading = true
      $http.post(_url.reset_password,
        password: $scope.password
        confirm_password: $scope.confirmation_password
        reset_password_token: $scope.token
      ).then (response) ->
        data = $validate.parseResult response
        $scope.submitted = false
        $scope.showLoading = false
        unless data.status is 1
          $scope.auth_error = data.message
        else
          $scope.show_result = true
          $scope.auth_success = data.message
        return

    return

  # Change password
  $scope.changePassword = () ->
    $scope.auth_error = ''
    $scope.auth_success = ''
    unless $scope.submitted
      $scope.submitted = true
      unless $scope.password || $scope.confirmation_password
        $scope.submitted = false
        return false
      if $scope.password != $scope.confirmation_password
        $scope.auth_error = $translate.instant 'user.error.password_not_match'
        $scope.submitted = false
        return false
      $scope.showLoading = true
      $http.post(_url.change_password,
        current_password: $scope.current_password
        password: $scope.password
        confirm_password: $scope.confirmation_password
      ).then (response) ->
        data = $validate.parseResult response
        $scope.submitted = false
        $scope.showLoading = false
        unless data.status is 1
          $scope.auth_error = data.message
        else
          $scope.auth_success = data.message
        return

    return

  $scope.login_with_social_network = (provider) ->
    Session.login_with_social_network($window.location.href, provider).then ((response) ->
      $common.showLoading('.container_login_social_loading')
      data = $validate.parseResult response
      unless response.status is 1
        $scope.auth_error = response.message
      else
        $common.responseAlertDeffer(response).then ()->
          $window.location.href = response.data[0].login_url
      $common.hideLoading()
      return
    )

  #--- logout
  $scope.logout = (employer) ->
    if employer == 1
      _url.logged_in = _url.company_logged_in
    else
      unless /users/.test($window.location.pathname)
        _url.logged_in = $location.absUrl()
    Session.logout(_url.logged_in)

  # route for controller: check state to call default function
  switch $state.current.name
    when 'logout' then $scope.logout()

  # --------------------------------------------------------
  # active users process
  #-- init
  # -- paging
  $scope.max_size = $scope.config.paging.max_size
  $scope.items_per_page = $scope.config.paging.items_per_page
  $scope.total_items = 0
  $scope.current_page = 0
  $scope.num_pages = 0
  $scope.order_by = null

  $scope.initActiveUsers = () ->
    $user = new User
    $scope.keyword = ''

    # search
    $scope.search()

  # sort
  $scope.sort = (field, reverse) ->
    sort_type = if reverse then ' desc' else ' asc'
    $scope.order_by = if (typeof (field) != 'undefined') then field + sort_type else null
    $scope.search()
    return

  #-- page change
  $scope.pageChanged = ()->
    $scope.search()

  #-- search
  $scope.search = () ->
    $user.search($scope.keyword, $scope.current_page, $scope.items_per_page, $scope.order_by).then (res)->
      $scope.users = res.list
      $scope.total_items = res.total

  $scope.activeUser = (user_id, active) ->
    $user.activeUser(user_id, active).then (res)->
      if !res or _.isEmpty res
        angular.forEach $scope.users, (value, k)->
          if value.id == user_id
            value.active = !active

  return

.factory 'User',  ($http, $q, $rails, $timeout, Validate, Common, $upload) ->
  'use strict'
  # -------------------------
  # static variables
  $common = new Common
  $validate = new Validate

  _url =
    apply_online: $rails.root_url + 'api/v1/api_job6'
    register_job_alert: $rails.root_url + 'api/v1/api_job_alerts1'
    search: $rails.root_url + 'api/v1/api_user17'
    active: $rails.root_url + 'api/v1/api_user18'

  User = ()->
    # private

    # public
    user =
      applyJob: (apply_job)->
        deferred = $q.defer()
        params =
          user_id: apply_job.current_user.id
          job_id: apply_job.job_info.id
          application_subject: apply_job.application_subject
          cover_letter: apply_job.cover_letter
        if apply_job.resume.type == 'resume_attachment'
          $upload.upload(
            url: _url.apply_online,
            data: params
            file: apply_job.resume.data
          ).progress((evt) ->
              console.log 'percent: ' + parseInt(100.0 * evt.loaded / evt.total)
          ).success((data, status, headers, config) ->
            data = $validate.parseResult data, true
#            if data && data.status == 1
#              # alert result
#              $common.responseAlert data
#            else
#              console.log '--- Data formatting error! ---'
            deferred.resolve data
            return
          ).error (er)->
            console.log er
            deferred.resolve {status: -1, message: 'Error!'}
        else
          params.resume = apply_job.resume.data
          deferred.resolve($common.changeDataActionNonConfirmReFull(_url.apply_online, params, false))
        return deferred.promise

      registerJobAlert: (email, category_id, company_id)->
        params =
          job_alerts:
            email: email
            category_id: category_id
            company_id: company_id
        $common.changeDataActionNonConfirm _url.register_job_alert, params

      search: (keyword, page, row_per_page, order_by)->
        deferred = $q.defer()
        $common.showLoading()
        url = _url.search
        $http.post(
          url,
          keyword: keyword
          page: page
          row_per_page: row_per_page
          order_by: order_by
        ).then (response) ->
          data = $validate.parseResult response
          $common.hideLoading()
          deferred.resolve data.data
          return

        return deferred.promise

      activeUser: (user_id, active)->
        html_confirm = '<p translate="user.active_user.confirm"></p>'
        html_confirm = '<p translate="user.active_user.non_confirm"></p>' unless active

        params =
          user_id: user_id
          user_active: active
        $common.changeDataActionRequireConfirm _url.active, params, html_confirm