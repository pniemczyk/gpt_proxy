import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["defaultIcon", "successIcon", "path"]
  ui = {
    hidden: "hidden",
  }
  onCopy(event) {
    // when target tag is a or button we do not copy the text and we do not prevent the default action
    if (event.target.tagName === "A" || event.target.tagName === "BUTTON") { return }
    event.preventDefault()

    const pathText = this.pathTarget.innerText.trim()

    navigator.clipboard.writeText(pathText).then(() => {
      this.defaultIconTarget.classList.add(this.ui.hidden)
      this.successIconTarget.classList.remove(this.ui.hidden)

      setTimeout(() => {
        this.successIconTarget.classList.add(this.ui.hidden)
        this.defaultIconTarget.classList.remove(this.ui.hidden)
      }, 1000)
    }).catch(err => {
      console.error("Failed to copy: ", err)
    })
  }
}
