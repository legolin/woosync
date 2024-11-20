// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "./application"

import consumer from '../channels/consumer'
import CableReady from 'cable_ready'

CableReady.initialize({ consumer })

import NestedFormController from "./nested_form_controller"
application.register("nested-form", NestedFormController)

import SidebarController from "./sidebar_controller";
application.register("sidebar", SidebarController)

import MappingFieldController from "./mapping_field_controller";
application.register("mapping-field", MappingFieldController)
