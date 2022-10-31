import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.token = document.querySelector('meta[name="csrf-token"]').content;
    this.modal = document.getElementById("modal-background");
    this.modal.addEventListener("click", (e) => {
      if (!document.getElementById("modal-box").contains(e.target)) {
        this.hideModal();
      }
    });
  }

  loadModal(e) {
    fetch("/modal", {
      method: "POST",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        option: this.decideOption(e).option,
        option_id: this.decideOption(e).id,
        selected: e.target.getAttribute("data-button"),
      }),
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }

  showModal(e) {
    this.loadModal(e);
    this.modal.classList.remove("hidden");
  }

  decideOption(e) {
    if (e.target.getAttribute("data-post") !== null) {
      return { option: "posts", id: e.target.getAttribute("data-post") };
    } else if (e.target.getAttribute("data-comment") !== null) {
      return { option: "comments", id: e.target.getAttribute("data-comment") };
    } else if (e.target.getAttribute("data-user") !== null) {
      return { option: "users", id: e.target.getAttribute("data-user") };
    } else if (e.target.getAttribute("data-community") !== null) {
      return {
        option: "communities",
        id: e.target.getAttribute("data-community"),
      };
    } else {
      return null;
    }
  }

  hideModal() {
    this.modal.classList.add("hidden");
  }
}
