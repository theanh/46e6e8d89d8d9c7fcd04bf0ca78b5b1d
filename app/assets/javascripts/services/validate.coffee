# --------------------------------------------------
# @: The Anh
# d: 141119
# f: validate data return from server api
# --------------------------------------------------
angular.module('ValidateService', []).factory 'Validate',  () ->
  'use strict'
  # ---------------------------------------------
  # static variable

  # ---------------------------------------------
  # public class
  Validate = () ->
    validate =
      parseResult: (result, is_simple) ->
        result = result.data unless is_simple
        res =
          status: 1
          message: result.message
          data: {}
        unless typeof(result.status) is 'undefined'
          if result.status == 1
            res.data = result.data
          else
            res.status = result.status
            res.message = result.message
        else
          res.status = 0
          res.message = 'Error!'

        return res

  Validate