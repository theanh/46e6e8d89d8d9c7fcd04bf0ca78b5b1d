'use strict'
angular.module("AppSurvey")
.directive "focus", ($timeout) ->
  scope:
    trigger: "@focus"
  link: (scope, element) ->
    scope.$watch "trigger", (value) ->
      if value is "true"
        $timeout ->
          element[0].focus()
          return
      return

    return

.directive "httpPrefix", ->
  restrict: "A"
  require: "ngModel"
  link: (scope, element, attrs, controller) ->
    ensureHttpPrefix = (value) ->
      # Need to add prefix if we don't have http:// prefix already AND we don't have part of it
      if value and not /^(https?):\/\//i.test(value) and "http://".indexOf(value) is -1
        value = value.charAt(value.length - 1)
        controller.$setViewValue "http://" + value
        controller.$render()
        "http://" + value
      else
        value
    controller.$formatters.push ensureHttpPrefix
    controller.$parsers.splice 0, 0, ensureHttpPrefix
    return

.directive "ngInitial", ->
  restrict: "A"
  controller: [
    "$scope"
    "$element"
    "$attrs"
    "$parse"
    ($scope, $element, $attrs, $parse) ->
      getter = undefined
      setter = undefined
      val = undefined
      val = $attrs.ngInitial or $attrs.value
      getter = $parse($attrs.ngModel)
      setter = getter.assign
      setter $scope, val
  ]

#Author by Quoc Co: modified validate
.directive "ngMatch", [->
  require: "ngModel"
  link: (scope, elem, attrs, ctrl) ->
    ctrl.$setValidity "", false
    firstPassword = '[name="' + attrs.ngMatch + '"]'
    elem.on "focusout", ->
      scope.$apply ->
        v = elem.val() is $(firstPassword).val()
        if v == false
          elem.addClass('invalid-mod')
        ctrl.$setValidity "match", v
        ctrl.$setValidity "", v
        return
      return

    elem.on "focusin", ->
      scope.$apply ->
        elem.removeClass('invalid-mod')
        ctrl.$setValidity "match", true
        return
      return
    return
]

.directive "ngRequiredMod", [->
  scope:
    data: '=rqSource'
  require: "ngModel"
  link: (scope, elem, attrs, ctrl) ->
    # @: The Anh - 141217 - fix case input has data already
    scope.$watch 'data',()->
      valid = false
      valid = true if scope.data && scope.data != ''
      ctrl.$setValidity "", valid
    # end The Anh

    elem.on "focusout", ->
      scope.$apply ->
        v = elem.val().length > 0
        if v == false
          elem.addClass('invalid-mod')
        ctrl.$setValidity "", v
        ctrl.$setValidity "requiredMod", v
        return
      return

    elem.on "focusin", ->
      scope.$apply ->
        elem.removeClass('invalid-mod')
        ctrl.$setValidity "requiredMod", true
        return
      return

    return
]

.directive "ngModEmail", ["$http", "$rails"
  (async, $rails) ->
    return (
      require: "ngModel"
      link: (scope, elem, attrs, ctrl) ->
        # @: The Anh - 141217 - fix case input has data already
        scope.$watch attrs.ngModel, (new_val)->
          valid = false
          valid = true if new_val && new_val != ''
          ctrl.$setValidity "", valid
        # end The Anh

        EMAIL_REGEXP = /^[a-z0-9!#$%&'*+\/=?^_`{|}~.-]+@[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)*$/i
        elem.on "focusout", ->
          scope.$apply ->
            val = elem.val()
            v = EMAIL_REGEXP.test(val)
            if v == false
              elem.addClass('invalid-mod')
            else
              # call api
              req =
                email: val
              ajaxConfiguration =
                method: "POST"
                url: $rails.root_url + 'api/v1/api_email_exist'
                data: req
              async(ajaxConfiguration).success (data) ->
                result = data
                ve = result.status == 1 ? true : false
                if ve == false
                  elem.addClass('invalid-mod')
                ctrl.$setValidity "modEmailExist", ve
                ctrl.$setValidity "", ve
                return
            ctrl.$setValidity "modEmail", v
            ctrl.$setValidity "", v
            return
          return

        elem.on "focusin", ->
          scope.$apply ->
            elem.removeClass('invalid-mod')
            ctrl.$setValidity "modEmail", true
            return
          return
        return
    )
]

.directive "ngMaxlengthMod", [->
  require: "ngModel"
  link: (scope, elem, attrs, ctrl) ->
    ctrl.$setValidity "", false
    elem.on "focusout", ->
      scope.$apply ->
        v = elem.val().length <= parseInt(elem.attr("ng-maxlength-mod"))
        if v == false
          elem.addClass('invalid-mod')
        ctrl.$setValidity "maxLengthMod", v
        ctrl.$setValidity "", v
        return
      return

    elem.on "focusin", ->
      scope.$apply ->
        elem.removeClass('invalid-mod')
        ctrl.$setValidity "maxLengthMod", true
        return
      return
    return
]

.directive "ngMinlengthMod", [->
  require: "ngModel"
  link: (scope, elem, attrs, ctrl) ->
    ctrl.$setValidity "", false
    elem.on "focusout", ->
      scope.$apply ->
        v = elem.val().length >= parseInt(elem.attr("ng-minlength-mod"))
        if v == false
          elem.addClass('invalid-mod')
        ctrl.$setValidity "minLengthMod", v
        ctrl.$setValidity "", v
        return
      return

    elem.on "focusin", ->
      scope.$apply ->
        elem.removeClass('invalid-mod')
        ctrl.$setValidity "minLengthMod", true
        return
      return
    return
]

.directive 'scroll', ($window) ->
  (scope, element, attrs) ->
    angular.element($window).bind 'scroll', ->
      if @pageYOffset >= 300
        scope.show_when_scroll = true
      else
        scope.show_when_scroll = false
      scope.$apply()
      return
    return