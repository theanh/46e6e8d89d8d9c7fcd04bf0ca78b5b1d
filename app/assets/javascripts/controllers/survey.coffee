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
    console.log 1
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
    # if ($scope.form_survey.$valid)
    #   console.log 1
    #   if $scope.attempts
    #     unless $scope.submitted
    #       unless $scope.attempts['name'] || $scope.attempts['email']
    #         return false
    #       $scope.submitted = true
    #       $scope.auth_error = null

    #       # clone scope
    #       $scope.attempts['survey_id'] = $scope.survey_id
    #       $scope.master = angular.copy $scope.attempts

    #       # add new instances
    #       $survey = new Survey()
    #       $survey.attemptSurvey($scope.master).then (res)->
    #         console.log res
    #       $scope.submitted = false
    # else
    #   console.log 2
    #   $scope.form_survey.submitted = true
    return

  # --- show survey result
  $scope.showResult = (survey_id)->
    # common chart config
    $scope.chart_config = 
      options:
        chart: 
          plotBackgroundColor: null
          plotBorderWidth: null
          plotShadow: false
        tooltip: 
          pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        # legend:
        #   align: 'right'
        #   verticalAlign: 'top'
        #   layout: 'vertical'
        #   x: 0
        #   y: 100
        #   floating: true
        plotOptions: 
          pie:
            allowPointSelect: true
            cursor: 'pointer'
            dataLabels:
              enabled: false
              format: '<b>{point.name}</b>: {point.percentage:.1f} %'
              style: 
                color: Highcharts.theme && Highcharts.theme.contrastTextColor || 'black'
            showInLegend: true
        title: text: ''
      series: [{
        type: 'pie'
        name: ''
        data: []
      }]
      loading: false
      func: (chart) ->
        return

    # add new instances
    data_statistic = []
    $survey = new Survey()
    param = 
      survey_id: survey_id
    $survey.showSurveyResult(param).then (res)->
      if res.status == 1 && res.data[0] && res.data[0]['question_id']
        # analyze returned data, group by question
        data_statistic = []
        cur_q = res.data[0]['question_id']
        vi_length = res.data.length - 1
        angular.forEach res.data, (v, i)->
          if (cur_q != v['question_id']) || ( i == vi_length )
            $scope['chart_config'+cur_q] = angular.copy $scope.chart_config

            # if the last element => push it to final array!
            if i == vi_length
              data_statistic.push([v['option_text'], parseInt(v['count'])])
            $scope['chart_config'+cur_q]['series'][0]['data'] = data_statistic

            # reset flag
            cur_q = v['question_id']
            data_statistic = []
          # push option result to array
          data_statistic.push([v['option_text'], parseInt(v['count'])])
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
    show_survey_result: $rails.root_url + 'api/v1/api_survey2'

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

      showSurveyResult: (survey)->
        deferred = $q.defer()
        # $common.showLoading()
        url = _url.show_survey_result
        $http.post(
          url,
          survey: survey
        ).then (response) ->
          data = $validate.parseResult response
          # $common.hideLoading()
          deferred.resolve data
          return

        return deferred.promise