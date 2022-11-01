import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.token = document.querySelector('meta[name="csrf-token"]').content;
    this.chat = document.getElementById("chat");
    // this.chat.firstChild.addEventListener("click", (e) => {
    //   if (!document.getElementById("modal-box").contains(e.target)) {
    //     this.minimizeChat();
    //   }
    // });
  }

  loadChat(e) {
    fetch("/chat", {
      method: "POST",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        user_id: e.target.getAttribute("data-user"),
      }),
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }

  showChat(e) {
    this.loadChat(e);
    this.chat.classList.remove("hidden");
    this.maximizeChat();
  }

  maximizeChat() {
    this.chat.classList.remove("minimized");
  }

  minimizeChat() {
    this.chat.classList.toggle("minimized");
  }

  hideChat() {
    this.chat.classList.add("hidden");
  }
}
