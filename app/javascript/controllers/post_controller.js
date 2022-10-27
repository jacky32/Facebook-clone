import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "comments",
    "commentOverflow",
    "innerCommentElement",
    "displayComments",
    "editButton",
    "editDropdown",
  ];
  static values = {
    defaultHeight: "240px",
    enabledHeight: "none",
    defaultCommentsShownText: "Display all comments",
    shownAllCommentsText: "Hide extra comments",
    showAllComments: false,
  };

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

  toggleComments() {
    this.commentsTarget.classList.toggle("hidden");
  }

  showComments() {
    if (this.commentsTarget.classList.contains("hidden")) {
      this.commentsTarget.classList.remove("hidden");
    }
    this.commentsTarget.firstElementChild.childNodes[3][1].focus();
  }

  toggleOverflow(e) {
    this.showAllCommentsValue = !this.showAllCommentsValue;
    if (this.showAllCommentsValue) {
      this.displayCommentsTarget.textContent = this.shownAllCommentsTextValue;
      this.commentOverflowTarget.style.overflow = "visible";
      this.commentOverflowTarget.style.maxHeight = this.enabledHeightValue;
    } else {
      this.displayCommentsTarget.textContent =
        this.defaultCommentsShownTextValue;
      this.commentOverflowTarget.style.overflow = "auto";
      this.commentOverflowTarget.style.maxHeight = this.defaultHeightValue;
    }
  }
}
