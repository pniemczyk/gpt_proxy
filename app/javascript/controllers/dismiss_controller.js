
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  onDismiss(event) {
    this.containerTarget.remove()
  }
}
