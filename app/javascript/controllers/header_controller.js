import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["profileDropdown", "profileButton"];

  connect() {
    document.addEventListener("click", (e) => {
      if (
        !this.profileDropdownTarget.contains(e.target) &&
        !this.profileButtonTarget.contains(e.target)
      ) {
        this.hideDropdown();
      }
    });
  }

  hideDropdown() {
    this.profileDropdownTarget.classList.add("hidden");
  }

  toggleDropdown() {
    this.profileDropdownTarget.classList.toggle("hidden");
  }
}
