# ----------------------------------------------------------
# @: The Anh
# d: 150328
# f: init app
# ----------------------------------------------------------
((angular) ->
  'use strict'
  angular.module('AppSurvey', [
    # 'angular-data.DSCacheFactory'
    'pascalprecht.translate'
    'ui.bootstrap'
    'highcharts-ng'
    'ValidateService'
    'ModalModule'
    'ngRoute'
  ])
  .config ($provide, $httpProvider, $translateProvider, $rails) ->
    # CSFR token
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = angular.element(document.querySelector('meta[name=csrf-token]')).attr('content')

    # # Template cache
    # if $rails.env != 'development'
    #   $provide.service '$templateCache', ['$cacheFactory', ($cacheFactory) ->
    #     $cacheFactory('templateCache', {
    #       maxAge: 3600000 * 24 * 7,
    #       storageMode: 'localStorage',
    #       recycleFreq: 60000
    #     })
    #   ]

    # # Angular translate
    # $translateProvider.useStaticFilesLoader({
    #   prefix: 'locales/',
    #   suffix: '.json'
    # })
    # $translateProvider.preferredLanguage($rails.locale)

    # Assets interceptor
    $provide.factory 'railsAssetsInterceptor', ['$location', '$rootScope', '$q', ($location, $rootScope, $q) ->
      request: (config) ->
        if assetUrl = $rails.templates[config.url]
          config.url = assetUrl
        config
    ]
    $httpProvider.interceptors.push 'railsAssetsInterceptor'
    return

  # # --------------------------------------------------------
  # # global process
  # # --- focus on the first input when the page loads
  # window.focus = (selector) ->
  #   # timeout is needed for Chrome (is a bug in Chrome)
  #   setTimeout ()->
  #     $(!!selector ? selector : '[autofocus]:not(:focus)').first().focus()
  #   , 1
  #   return
  # return
) window.angular