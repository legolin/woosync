import { Controller } from "@hotwired/stimulus";
import { renderSampleList } from "../helpers/mapping_field_helpers";
import { sanitizeText } from "../helpers/sanitize_helpers";

export default class extends Controller {
  static targets = ["inputField", "outputField", "message", "checkbox", "options", "importMethod", "sampleData"]
  static values = {
    sampleData: Array,
  };

  connect() {
    if (this.outputFieldTarget.value == 'sku') {
      this.checkboxTarget.checked = true;
      this.checkboxTarget.disabled = true;
    }

    this.optionsTarget.hidden = !this.checkboxTarget.checked;
    this.updateImportMethod();
    this.updateSampleData();
  }

  clickCheckbox() {
    const checked = this.checkboxTarget.checked;

    this.optionsTarget.hidden = !checked;
    this.optionsTarget.querySelectorAll('input, select').forEach(el => el.disabled = !checked)

    this.updateSampleData();
  }

  updateImportMethod() {
    const importMethodRadioButton = this.optionsTarget.querySelector('.feed_mappings_import_method input:checked');
    if (!importMethodRadioButton) return;

    const selectedValue = this.optionsTarget.querySelector('.feed_mappings_import_method input:checked').value;
    this.optionsTarget.querySelectorAll('.import_method').forEach(el => {
      const importMethod = el.getAttribute('data-import-method');
      const disabled = (importMethod != selectedValue);
      el.hidden = disabled;
      el.querySelectorAll('input, select').forEach(el => el.disabled = disabled)
    });
    this.updateSampleData();
  }

  updateSampleData() {
    let importMethod = "simple";
    const importMethodRadioButton = this.optionsTarget.querySelector('.feed_mappings_import_method input:checked');
    if (importMethodRadioButton) {
      importMethod = importMethodRadioButton.value;
    };

    let sampleData = "";
    switch (importMethod) {
      case "simple":
        if (this.inputFieldTarget.value) {
          sampleData = sanitizeText(this.sampleDataValue[0][this.inputFieldTarget.value]);
        } else {
          sampleData = "";
        }
        break;
      case "multi_source_array":
        break;
      case "multi_source_text":
        break;
      case "split_string":
        if (this.inputFieldTarget.value) {
          const rawSampleData = this.sampleDataValue[0][this.inputFieldTarget.value];
          const arraySeparator = this.optionsTarget.querySelector('.feed_mappings_array_separator input').value;
          if (!rawSampleData) {
            sampleData = `Unable to turn entry into list<br />Entry: "${sanitizeText(rawSampleData)}"`;
          } else if (arraySeparator) {
            const entries = rawSampleData.split(arraySeparator).map((entry) => entry.trim());
            sampleData = renderSampleList(entries);
          }
        } else {
          sampleData = "";
        }
        break;
    }
    this.sampleDataTarget.innerHTML = sampleData;
  }
}
