import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "title", "iconDown", "iconUp", "button"]

  ui = {
    hidden: "hidden",
  }

  attrs = {
    collapsed: "aria-collapsed",
  }
  onToggle(event) {
    if (this.collapsed) {
      this.buttonTarget.setAttribute(this.attrs.collapsed, "false")
      this.contentTarget.setAttribute(this.attrs.collapsed, "false")
      this.contentTarget.classList.remove(this.ui.hidden)
      this.titleTarget.textContent = `Hide ${this.title}`
      this.iconDownTarget.classList.add(this.ui.hidden);
      this.iconUpTarget.classList.remove(this.ui.hidden);
    } else {
      this.buttonTarget.setAttribute(this.attrs.collapsed, "true")
      this.contentTarget.setAttribute(this.attrs.collapsed, "true")
      this.contentTarget.classList.add(this.ui.hidden)
      this.titleTarget.textContent = `Show ${this.title}`
      this.iconDownTarget.classList.remove(this.ui.hidden);
      this.iconUpTarget.classList.add(this.ui.hidden);
    }
  }

  get title() {
    return this.titleTarget.dataset.title
  }
  get collapsed() {
    return this.buttonTarget.getAttribute(this.attrs.collapsed) === "true"
  }
}
