'use strict'
angular.module("AppSurvey")
# ----------------------------------------------------------------------------------------
# @: The Anh
# d: 150329
# f: Directive Scroll To Top
# ----------------------------------------------------------------------------------------
.directive 'scroll', [
  '$window',
  ($window) ->
    link: (scope, element, attrs) ->
      angular.element($window).bind 'scroll', ->
        if @pageYOffset >= 300
          scope.show_when_scroll = true
        else
          scope.show_when_scroll = false
        scope.$apply()

        return

      return
]

# ----------------------------------------------------------------------------------------
# @: The Anh
# d: 150329
# f: Directive handle form submit: 
# --- only submit if form valid
# --- auto focus on the first invalid element
# LR: 
# --- 1. http://blog.projectnibble.org/2014/01/10/advanced-form-control-with-angularjs-and-bootstrap3
# --- 2. http://stackoverflow.com/questions/20365121/set-focus-on-first-invalid-input-in-angularjs-form
# ----------------------------------------------------------------------------------------
.directive 'validSubmit', [
  '$parse'
  ($parse) ->
    require: 'form'
    link: (scope, elem, iAttrs, form) ->
      form.$submitted = false
      # get a hold of the function that handles submission when form is valid
      fn = $parse(iAttrs.validSubmit)
      # register DOM event handler and wire into Angular's lifecycle with scope.$apply
      elem.on 'submit', (event) ->
        scope.$apply ->
          # on submit event, set submitted to true (like the previous trick)
          form.$submitted = true
          # if form is valid, execute the submission handler function and reset form submission state
          if form.$valid
            fn scope, $event: event
            form.$submitted = false
          else
            # timeout is needed for Chrome (is a bug in Chrome)
            setTimeout ()->
              # auto focus on the first invalid element!
              frt_invalid = elem.find('.ng-invalid')[0]
              if frt_invalid
                frt_invalid.focus()

              return false
            , 1

          return

        return
        
      return
]