# ----------------------------------------------------------
# @: The Anh
# d: 141120
# f: Modal module
# ----------------------------------------------------------
'use strict'
angular.module('ModalModule', []).factory 'Modal',  ($modal) ->
  # -----------------------------------
  #  init variable
  # -- static

  # -----------------------------------
  #  class
  Modal = (template_url, title, open, controller, callback, share_variable) ->
    # -- private
    _prop =
      template_url: template_url || 'pages/template/dialog/modal.html'
      template_alert_url: 'pages/template/dialog/alert.html'
      modalInstance: null
      modal_class: {}
      size: null # 'lg'/'sm'
      controller: controller || ''
      title: title || ''
      share_variable: share_variable || {}

    # -- public
    modal =
#      getSelected: -> selected

      bindEvent: () ->
        angular.element()

      open: (custom_size, modal_class, backdrop) ->
        _prop.modalInstance = $modal.open(
          templateUrl: _prop.template_url
          controller: _prop.controller
          size: custom_size || _prop.size
          windowClass: modal_class || _prop.modal_class
          backdrop: backdrop
          resolve:
            constants: ->
              title: _prop.title
              share_variable: _prop.share_variable
        )

        # call callback function after
        _prop.modalInstance.opened.then callback

        _prop.modalInstance.result.then ((res) ->
          return res
        ), ->
          console.log  'Modal dismissed at: ' + new Date()
          return

        return

      ok: () ->
        _prop.modalInstance.close()

      close: () ->
        _prop.modalInstance.dismiss 'cancel'

      alert: () ->
        _prop.modalInstance = $modal.open(
          templateUrl: _prop.template_alert_url
          controller: _prop.controller
          size: _prop.size
          backdrop: false
          resolve:
            constants: ->
              title: _prop.title
        )

        # call callback function after
        _prop.modalInstance.opened.then callback

        _prop.modalInstance.result.then ((res) ->
          return res
        ), ->
          console.log  'Modal dismissed at: ' + new Date()
          return

        return

    if open
      modal.open()

    return modal

  Modal