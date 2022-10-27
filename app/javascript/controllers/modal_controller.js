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
        post_id: e.target.getAttribute("data-post"),
        comment_id: e.target.getAttribute("data-comment"),
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

  hideModal() {
    this.modal.classList.add("hidden");
  }
}
