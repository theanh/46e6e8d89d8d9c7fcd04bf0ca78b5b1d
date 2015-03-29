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
        $scope.attempts['survey_id'] = $scope.survey_id
        $scope.master = angular.copy $scope.attempts
        # add new instances
        $survey = new Survey()
        $survey.attemptSurvey($scope.master).then (res)->
          console.log res
        $scope.submitted = false
    return

  # --- show survey result
  $scope.showResult = (survey_id)->
    $scope.chart_config = 
      options:
        chart: 
          plotBackgroundColor: null
          plotBorderWidth: null
          plotShadow: false
        tooltip: 
          pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        plotOptions: 
          pie:
            allowPointSelect: true
            cursor: 'pointer'
            dataLabels:
              enabled: true
              format: '<b>{point.name}</b>: {point.percentage:.1f} %'
              style: 
                color: Highcharts.theme && Highcharts.theme.contrastTextColor || 'black'
        title: text: ''
      series: [{
        type: 'pie'
        name: ''
        data: [
          [
            'Firefox'
            45.0
          ]
          [
            'IE'
            26.8
          ]
          {
            name: 'Chrome'
            y: 12.8
            sliced: true
            selected: true
          }
          [
            'Safari'
            8.5
          ]
          [
            'Opera'
            6.2
          ]
          [
            'Others'
            0.7
          ]
        ]
      }]
      loading: false
      # size:
      #   width: 400
      #   height: 300
      func: (chart) ->
        console.log chart
        return
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