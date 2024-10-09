// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import consumer from '../channels/consumer'
import CableReady from 'cable_ready'

CableReady.initialize({ consumer })
