import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "email",
    "password",
    "form",
    "firstName",
    "lastName",
    "passwordConfirmation",
  ];
  connect() {
    this.emailTarget.addEventListener("focusout", () =>
      this.checkValid(this.emailTarget, "e-mail")
    );
    this.passwordTarget.addEventListener("focusout", () =>
      this.checkValid(this.passwordTarget, "password")
    );
    this.emailTarget.addEventListener("focusout", () =>
      this.checkValid(this.firstNameTarget, "first name")
    );
    this.passwordTarget.addEventListener("focusout", () =>
      this.checkValid(this.lastNameTarget, "last name")
    );
    this.passwordTarget.addEventListener("focusout", () =>
      this.checkValid(this.passwordConfirmationTarget, "password confirmation")
    );
  }

  checkInputValidity(e) {
    if (!e.detail.formSubmission.validity.valid) {
      this.showErrors();
      e.detail.formSubmission.stop();
    }
  }

  showErrors() {
    this.checkValid(this.emailTarget, "e-mail");
    this.checkValid(this.passwordTarget, "password");
    this.checkValid(this.firstNameTarget, "first name");
    this.checkValid(this.lastNameTarget, "last name");
    this.checkValid(this.passwordConfirmationTarget, "password confirmation");
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
