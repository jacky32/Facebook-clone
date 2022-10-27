import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["reply", "editButton", "editDropdown"];

  connect() {
    document.addEventListener("click", (e) => {
      const chld = this.editDropdownTarget.children.length;
      if (chld == 2) {
        if (
          (!this.editDropdownTarget.contains(e.target) &&
            !this.editButtonTarget.contains(e.target)) ||
          this.editDropdownTarget.children[0].contains(e.target) ||
          this.editDropdownTarget.children[1].contains(e.target)
        ) {
          this.hideDropdown();
        }
      } else if (chld == 1) {
        if (
          (!this.editDropdownTarget.contains(e.target) &&
            !this.editButtonTarget.contains(e.target)) ||
          this.editDropdownTarget.children[0].contains(e.target)
        ) {
          this.hideDropdown();
        }
      }
    });
  }

  hideDropdown() {
    this.editDropdownTarget.classList.add("hidden");
  }

  toggleDropdown() {
    this.editDropdownTarget.classList.toggle("hidden");
  }

  toggleReply() {
    this.replyTarget.classList.toggle("hidden");
  }
}
