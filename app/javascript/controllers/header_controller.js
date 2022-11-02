import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "profileDropdown",
    "profileButton",
    "messagesDropdown",
    "messagesButton",
    "notificationsDropdown",
    "notificationsButton",
  ];

  connect() {
    document.addEventListener("click", (e) => {
      if (
        (!this.profileDropdownTarget.contains(e.target) &&
          !this.profileButtonTarget.contains(e.target)) ||
        this.profileDropdownTarget.children[0].contains(e.target) ||
        this.profileDropdownTarget.children[1].contains(e.target) ||
        this.profileDropdownTarget.children[2].contains(e.target)
      ) {
        this.hideDropdown("profile");
      }
      if (
        !this.notificationsDropdownTarget.contains(e.target) &&
        !this.notificationsButtonTarget.contains(e.target) //||
        // this.notificationsDropdownTarget.children[0].contains(e.target) ||
        // this.notificationsDropdownTarget.children[1].contains(e.target) ||
        // this.notificationsDropdownTarget.children[2].contains(e.target)
      ) {
        this.hideDropdown("notifications");
      }
      if (
        !this.messagesDropdownTarget.contains(e.target) &&
        !this.messagesButtonTarget.contains(e.target) //||
        // this.messagesDropdownTarget.children[0].contains(e.target) ||
        // this.messagesDropdownTarget.children[1].contains(e.target) ||
        // this.messagesDropdownTarget.children[2].contains(e.target)
      ) {
        this.hideDropdown("messages");
      }
    });
  }

  hideDropdown(option) {
    switch (option) {
      case "profile":
        this.profileDropdownTarget.classList.add("hidden");
        break;
      case "messages":
        this.messagesDropdownTarget.classList.add("hidden");
        break;
      case "notifications":
        this.notificationsDropdownTarget.classList.add("hidden");
        break;

      default:
        break;
    }
  }

  toggleDropdown(e) {
    const dropdown = e.target.getAttribute("data-dropdown");
    switch (dropdown) {
      case "profile":
        this.profileDropdownTarget.classList.toggle("hidden");
        break;
      case "messages":
        this.messagesDropdownTarget.classList.toggle("hidden");
        break;
      case "notifications":
        this.notificationsDropdownTarget.classList.toggle("hidden");
        break;

      default:
        break;
    }
  }
}
