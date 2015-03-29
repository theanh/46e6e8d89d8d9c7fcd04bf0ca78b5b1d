'use strict'
# ----------------------------------------------------------
# @: The Anh
# d: 150329
# f: survey controller
# ----------------------------------------------------------
angular.module('AppSurvey')
.controller 'SurveyCtrl', ($scope, $rails, Survey) ->
  # --------------------------------------------------------
  # private variable
  $survey = null

  # --------------------------------------------------------
  # public variable
  # $scope.submitted = false # variable set state submitted
  $scope.load_error = null
  $scope.load_result = null
  $scope.master = {}
  $scope.attempts = {}
  $scope.cus_validate = {}

  # --------------------------------------------------------
  # public process
  # --- init survey
  $scope.initSurvey = (survey_id, arr_chk_valid_questions)->
    $scope.survey_id = survey_id
    # init custom validate value
    $scope.cus_validate.question = {}
    angular.forEach arr_chk_valid_questions, (value, index)->
      $scope.cus_validate.question[value] = true
    return

  # --- validate
  $scope.checkValidate = ()->
    flg_validate = true
    if !$scope.attempts.question
      angular.forEach $scope.cus_validate.question, (value, index)->
        if flg_validate
          $scope.cus_validate.question[index] = false
          flg_validate = false
    else
      angular.forEach $scope.cus_validate.question, (value, index)->
        if flg_validate
          if !$scope.attempts.question[index]
            $scope.cus_validate.question[index] = false
            flg_validate = false
          else
            if $scope.attempts.question[index].length == 0
              $scope.cus_validate.question[index] = false
              flg_validate = false
            else
              # scan value false
              flg_validate_f = false
              angular.forEach $scope.attempts.question[index], (v, i)->
                flg_validate_f = true if v
              unless flg_validate_f
                $scope.cus_validate.question[index] = false
                flg_validate = false

    unless flg_validate
      $scope.form_survey.$valid = false
      
      # timeout is needed for Chrome (is a bug in Chrome)
      setTimeout(()->
        # auto focus on the first invalid element!
        frt_invalid = $('form[name=form_survey] .cus-validate.ng-invalid')[0]
        if frt_invalid
          frt_invalid.focus()
      , 1)
      
      return false

    return true

  # --- submit
  $scope.submitSurvey = () ->
    # check custom validate
    if $scope.checkValidate()
      $scope.auth_error = null
      # clone scope
      $scope.attempts['survey_id'] = $scope.survey_id
      $scope.master = angular.copy $scope.attempts

      # add new instances
      $survey = new Survey()
      $survey.attemptSurvey($scope.master).then (res)->
        if res.status == 1
          location.href = $rails.root_url + 'survey/result'
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
          deferred.resolve data
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