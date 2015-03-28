# ----------------------------------------------------------
# @: The Anh
# d: 1503
# f: Change languages directive
# ----------------------------------------------------------
angular.module("AppSurvey")
.directive "dirChangeLanguages", ($compile, $http, $templateCache) ->
  $templateCache.put 'dir_change_language', 'pages/directives/translate/dir_change_language.html'

  restrict: 'A'
  templateUrl: $templateCache.get 'dir_change_language'