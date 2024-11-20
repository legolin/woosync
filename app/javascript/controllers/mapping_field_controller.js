import { Controller } from "@hotwired/stimulus";

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
    if (this.checkboxTarget.checked) {
      this.optionsTarget.hidden = false;
    } else {
      this.optionsTarget.hidden = true;
    }
    this.updateSampleData();
  }

  updateImportMethod() {
    const importMethodRadioButton = this.optionsTarget.querySelector('.feed_mappings_import_method input:checked');
    if (!importMethodRadioButton) return;

    const selectedValue = this.optionsTarget.querySelector('.feed_mappings_import_method input:checked').value;
    this.optionsTarget.querySelectorAll('.import_method').forEach(el => {
      const importMethod = el.getAttribute('data-import-method');
      el.hidden = (importMethod != selectedValue);
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
          sampleData = this.sampleDataValue[0][this.inputFieldTarget.value];
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
          sampleData = this.sampleDataValue[0][this.inputFieldTarget.value];
          const arraySeparator = this.optionsTarget.querySelector('.feed_mappings_array_separator input').value;
          if (arraySeparator) {
            sampleData = `<ul class="split-string-sample"><li>${sampleData.split(arraySeparator).map((entry) => entry.trim()).join("</li><li>")}</ul>`;
          }
        } else {
          sampleData = "";
        }
        break;
    }
    this.sampleDataTarget.innerHTML = sampleData;
  }
}
