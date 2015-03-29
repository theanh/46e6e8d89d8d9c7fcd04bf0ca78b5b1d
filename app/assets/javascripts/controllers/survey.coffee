'use strict'
# ----------------------------------------------------------
# @: The Anh
# d: 150329
# f: survey controller
# ----------------------------------------------------------
angular.module('AppSurvey')
.controller 'SurveyCtrl', ($location, $scope, Survey) ->
  # --------------------------------------------------------
  # private variable
  $survey = null

  # --------------------------------------------------------
  # public variable
  $scope.submitted = false # variable set state submitted
  $scope.load_error = null
  $scope.load_result = null
  $scope.attempts = {}

  # --------------------------------------------------------
  # public process
  #--- login
  $scope.submitSurvey = () ->
    console.log 'aaa'
    unless $scope.submitted
      unless $scope.attempts || $scope.attempts.name || $scope.attempts.email
        return false
      $scope.submitted = true
      $scope.auth_error = null

      # add new instances
      $survey = new Survey()

      # Session.login(user.email, user.password, user.remember).then ((response) ->
      #   $common.hideLoading()
      #   if response.data.type == 'UserType::Normal'
      #     if is_redirect == false
      #       url_href = $window.location.reload()
      #     else
      #       url_href = _url.logged_in
      #   else
      #     url_href = _url.company_manager_job
      #   if response.status is 1
      #     $common.responseAlertDeffer(response).then ()->
      #       $window.location.href = url_href
      #   else
      #     $scope.auth_error = response.message
      #   $scope.submitted = false
      #   return
      # ), (response) ->
      #   $scope.auth_error = $translate.instant 'api.message.error.server_offline'
      #   $common.hideLoading()
      #   $scope.submitted = false
      #   return

    return

  return

.factory 'Survey',  ($http, $q, $rails, Validate, Common) ->
  'use strict'
  # -------------------------
  # static variables
  $common = new Common
  $validate = new Validate

  _url =
    active: $rails.root_url + 'api/v1/api_user18'

  Survey = ()->
    # private

    # public
    survey =
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