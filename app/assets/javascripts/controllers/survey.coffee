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
  $scope.master = {}
  $scope.attempts = {}

  # --------------------------------------------------------
  # public process
  # --- validate
  $scope.checkValidate = ()->
    return

  # --- submit
  $scope.submitSurvey = () ->
    if $scope.attempts
      unless $scope.submitted
        unless $scope.attempts['name'] || $scope.attempts['email']
          return false
        $scope.submitted = true
        $scope.auth_error = null

        # clone scope
        # $scope.attempts['survey_id'] = $scope.survey_id
        $scope.master = angular.copy $scope.attempts
        # add new instances
        $survey = new Survey()
        $survey.attemptSurvey($scope.master).then (res)->
          console.log res
        $scope.submitted = false
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
  # -------------------------
  # static variables
  $common = new Common
  $validate = new Validate

  _url =
    attempt_survey: $rails.root_url + 'api/v1/api_survey1'

  Survey = ()->
    # private

    # public
    survey =
      attemptSurvey: (survey)->
        deferred = $q.defer()
        # $common.showLoading()
        url = _url.attempt_survey
        $http.post(
          url,
          survey: survey
        ).then (response) ->
          data = $validate.parseResult response
          # $common.hideLoading()
          deferred.resolve data.data
          return

        return deferred.promise