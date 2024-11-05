// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import consumer from 'channels/consumer'
import CableReady from 'cable_ready'

CableReady.initialize({ consumer })

import NestedFormController from "./nested_form_controller"
application.register("nested-form", NestedFormController)
