import {Application} from "@hotwired/stimulus"
import EndpointController from 'controllers/endpoint_controller'
import DismissController from 'controllers/dismiss_controller'
import CurlBoxController from 'controllers/curl_box_controller'
import CollapseBoxController from 'controllers/collapse_box_controller'
import ProxyRequestController from 'controllers/proxy_request_controller'

import {railsEnv} from 'env'

const application = Application.start()
if (railsEnv === 'development') {
  application.debug = true
  application.handleError = (error, message, detail) => {
    console.warn(error, message, detail)
  }
} else {
  application.debug = false
}
application.register('endpoint', EndpointController)
application.register('dismiss', DismissController)
application.register('curl-box', CurlBoxController)
application.register('collapse-box', CollapseBoxController)
application.register('proxy-request', ProxyRequestController)

window.Stimulus = application

export {application}
