import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["inputField", "outputField", "message", "checkbox"]

  connect() {
    if (this.outputFieldTarget.value == 'sku') {
      this.checkboxTarget.checked = true;
      this.checkboxTarget.disabled = true;
    }

    this.inputFieldTarget.hidden = !this.checkboxTarget.checked;
  }

  clickCheckbox() {
    if (this.checkboxTarget.checked) {
      this.inputFieldTarget.hidden = false;
    } else {
      this.inputFieldTarget.hidden = true;
    }
  }
}
