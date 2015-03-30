'use strict'
# ----------------------------------------------------------
# @: The Anh
# d: 150330
# f: application controller
# ----------------------------------------------------------
angular.module('AppSurvey')
.controller 'AppCtrl', ($scope) ->
  # --------------------------------------------------------
  # public process
  $scope.goTo = (url)->
    location.href = url
    return

  return