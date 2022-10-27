import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["addFriend", "sendMessage"];
  connect() {
    this.token = document.querySelector('meta[name="csrf-token"]').content;
  }

  swap(e) {
    fetch("/set_friends", {
      method: "POST",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        id: e.target.getAttribute("data-user"),
        selected: e.target.getAttribute("data-selected"),
      }),
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }

  changeActive(e) {
    const selected = e.target.getAttribute("data-selected");
    this.removeActive();
    if (selected == "all") {
      this.allTarget.classList.add("active");
    } else if (selected == "mutual") {
      this.mutualTarget.classList.add("active");
    }
  }

  removeActive() {
    this.allTarget.classList.remove("active");
    this.mutualTarget.classList.remove("active");
  }
}
