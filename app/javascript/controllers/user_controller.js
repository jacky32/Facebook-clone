import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["posts", "about", "friends"];
  connect() {
    this.token = document.querySelector('meta[name="csrf-token"]').content;
  }

  swap(e) {
    fetch("/set_profile", {
      method: "POST",
      headers: {
        "X-CSRF-Token": this.token,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        id: e.target.getAttribute("data-user"),
        change: e.target.getAttribute("data-change"),
      }),
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }

  changeActive(e) {
    const change = e.target.getAttribute("data-change");
    this.removeActive();
    if (change == "posts") {
      this.postsTarget.classList.add("active");
    } else if (change == "about") {
      this.aboutTarget.classList.add("active");
    } else if (change == "friends") {
      this.friendsTarget.classList.add("active");
    }
  }

  removeActive() {
    this.postsTarget.classList.remove("active");
    this.aboutTarget.classList.remove("active");
    this.friendsTarget.classList.remove("active");
  }

  editProfile() {}

  sendMessage(e) {}

  addFriend(e) {}

  removeFriend(e) {}

  unsendFriendRequest() {}
}
