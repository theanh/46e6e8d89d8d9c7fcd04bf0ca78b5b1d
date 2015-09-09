'use strict'
angular.module('AppSurvey')
.directive "dirLoading", ['$compile', '$templateCache', ($compile, $templateCache) ->
  $templateCache.put 'loading-block', 'pages/directives/loading/block.html'

  templateUrl: $templateCache.get 'loading-block'
  restrict: 'A'
  link: (scope, elms, attrs)->
    nu_elems = 8
    scope.style = 'fading-bars'
    scope.show_backdrop = false
    scope.show_overlay = false
    scope.elems = [1..8]
    scope.container_width = 100

    scope.style = attrs.ldStyle if attrs.ldStyle
    scope.show_backdrop = attrs.showBackdrop if typeof(attrs.showBackdrop) != 'undefined'
    scope.show_overlay = attrs.showOverlay if typeof(attrs.showOverlay) != 'undefined'
    scope.loading_center = attrs.loadingCenter if typeof(attrs.loadingCenter) != 'undefined'
    nu_elems = parseInt(attrs.nuElems) if typeof(attrs.nuElems) != 'undefined' && (angular.isNumber(parseInt(attrs.nuElems)) && !isNaN(parseInt(attrs.nuElems)))
    scope.elems = [1..nu_elems]
    # cal size of the container
    scope.container_width = nu_elems*100/8
    # default hide loading
    elms.hide()

    return
]