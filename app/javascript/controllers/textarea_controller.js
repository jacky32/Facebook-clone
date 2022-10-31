import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  resize(e) {
    e.target.style.height = "auto";
    e.target.style.height = e.target.scrollHeight + "px";
  }

  send(e) {
    if (e.key == "Enter") {
      const test = e.target.parentNode.children;
      for (let i = 0; i < test.length; i++) {
        if (test[i].tagName == "BUTTON") {
          test[i].click();
        }
      }
    }
  }
}
