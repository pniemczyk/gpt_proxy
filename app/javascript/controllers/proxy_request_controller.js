import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  onClick(event) {
    event.preventDefault()

    const value = prompt(this.promptMessage)
    if (!value) {
      alert("You must enter something :D")
      return
    }

    this.submitForm(value)
  }

  submitForm(value) {
    const form = document.createElement('form')
    form.method = this.method || "POST"
    form.action = this.url

    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    const csrfInput = document.createElement('input')
    csrfInput.type = 'hidden'
    csrfInput.name = 'authenticity_token'
    csrfInput.value = csrfToken
    form.appendChild(csrfInput)
    if (this.payload) {
      const json = JSON.parse(this.element.dataset.payload.replace(this.promptKey, value))
      Object.entries(json).forEach(([key, value]) => {
        this.createInputForKey(form, key, value)
      })
    } else {
      const questionInput = document.createElement('input')
      questionInput.type = 'hidden'
      questionInput.name = this.promptKey
      questionInput.value = value
      form.appendChild(questionInput)
    }

    document.body.appendChild(form)
    form.submit()
  }

  createInputForKey(form, key, value, parentKey = null) {
    const name = parentKey ? `${parentKey}[${key}]` : key

    if (Array.isArray(value)) {
      value.forEach((item, _index) => {
        this.createInputForKey(form, '', item, name)
      })
    } else if (typeof value === 'object' && value !== null) {
      Object.entries(value).forEach(([nestedKey, nestedValue]) => {
        this.createInputForKey(form, nestedKey, nestedValue, name)
      })
    } else {
      const input = document.createElement('input')
      input.type = 'hidden'
      input.name = name
      input.value = value
      form.appendChild(input)
    }
  }

  get method() {
    return this.element.dataset.method || "POST"
  }

  get promptKey() {
    return this.element.dataset.prompt || 'value'
  }

  get promptMessage() {
    return this.element.dataset.message || `Please enter your value for ${promptKey}:`
  }

  get payload() {
    return this.element.dataset.payload
  }

  get url() {
    return this.element.getAttribute('href') || this.element.dataset.url
  }
}
