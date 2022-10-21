import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "comments",
    "commentOverflow",
    "innerCommentElement",
    "displayComments",
  ];
  static values = {
    defaultHeight: "240px",
    enabledHeight: "none",
    defaultCommentsShownText: "Display all comments",
    shownAllCommentsText: "Hide extra comments",
    showAllComments: false,
  };

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
