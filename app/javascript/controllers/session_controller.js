import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  checkInputValids(e) {
    if (!e.detail.formSubmission.validity.valid) {
      this.showErrors();
      e.detail.formSubmission.stop();
    }
  }

  showErrors() {
    document.getElementById("new_user").children.forEach((div) => {
      this.checkValid(div.firstChild, div.firstChild.placeholder.toLowerCase());
    });
  }

  checkSelf(e) {
    this.checkValid(e.target, e.target.placeholder.toLowerCase());
  }

  checkValid(target, message) {
    if (target.validity.valueMissing) {
      target.setCustomValidity(`You must enter your ${message}`);
      target.classList.add("error");
      target.reportValidity();
    } else if (target.validity.typeMismatch) {
      target.setCustomValidity(`Please enter your ${message}`);
      target.classList.add("error");
      target.reportValidity();
    } else if (target.validity.tooShort) {
      target.setCustomValidity(
        "Too short! The password must be at least 6 characters long."
      );
      target.classList.add("error");
      target.reportValidity();
    } else {
      target.classList.remove("error");
      target.setCustomValidity("");
    }
  }
}
