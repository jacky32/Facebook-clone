import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["reply"];
  toggleReply() {
    this.replyTarget.classList.toggle("hidden");
  }
}
