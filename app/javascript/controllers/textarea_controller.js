import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  resize(e) {
    e.target.style.height = "auto";
    e.target.style.height = e.target.scrollHeight + "px";
  }
}
