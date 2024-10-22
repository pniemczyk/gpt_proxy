import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    Prism?.highlightAll();
  }

  ui = {
    hidden: "hidden",
    activeColor: "text-gray-200",
    inactiveColor: "text-gray-400",
  }
  attrs = {
    selected: "aria-selected",
    index: "tabindex",
  }

  qSelector = {
    highlight: '[data-curl-box-target="highlight"]',
    copiedIcon: '[data-icon="copied"]',
    copyIcon: '[data-icon="copy"]',
    copyTitle: '[data-title="copy"]',
  }

  clearTabs() {
    this.tabTargets.forEach((tab, index) => {
      tab.setAttribute(this.attrs.selected, "false")
      tab.classList.remove(this.ui.activeColor)
      tab.classList.add(this.ui.inactiveColor)
      tab.querySelector(this.qSelector.highlight).classList.add(this.ui.hidden)
    })
  }

  clearPanels() {
    this.panelTargets.forEach((panel) => {
      panel.classList.add(this.ui.hidden)
    })
  }

  makeActiveTab(tab) {
    tab.setAttribute(this.attrs.selected, "true")
    tab.classList.remove(this.ui.inactiveColor)
    tab.classList.add(this.ui.activeColor)
    tab.querySelector(this.qSelector.highlight).classList.remove(this.ui.hidden)
  }

  makeActivePanel(index) {
    this.panelTargets.forEach((panel, i) => {
      if (panel.getAttribute(this.attrs.index) === index) {
        panel.classList.remove(this.ui.hidden)
      }
    });
  }

  onSelectTab(event) {
    event.preventDefault()
    this.clearTabs()
    this.clearPanels()
    const clickedTab = event.currentTarget
    this.makeActiveTab(clickedTab)
    const selectedIndex = clickedTab.getAttribute(this.attrs.index)
    this.makeActivePanel(selectedIndex)
  }

  onCopy(event) {
    event.preventDefault()
    event.stopPropagation()
    const target = event.currentTarget
    const copiedIcon = target.querySelector(this.qSelector.copiedIcon)
    const copyIcon = target.querySelector(this.qSelector.copyIcon)
    const titleElem = target.parentElement.querySelector(this.qSelector.copyTitle)
    const type = target.dataset.target
    const selectedIndex = this.selectedTabIndex().toString()
    this.panelTargets.forEach((panel, i) => {
      if (panel.getAttribute(this.attrs.index) === selectedIndex && panel.dataset?.type === type) {
        const text = panel.innerText.trim()
        navigator.clipboard.writeText(text).then(() => {
          titleElem.innerText = "Copied!"
          copiedIcon.classList.remove(this.ui.hidden)
          copyIcon.classList.add(this.ui.hidden)

          setTimeout(() => {
            copiedIcon.classList.add(this.ui.hidden)
            copyIcon.classList.remove(this.ui.hidden)
            titleElem.innerText = "Copy"
          }, 1000)
        }).catch(err => {
          console.error("Failed to copy: ", err)
        });
      }
    });
  }

  selectedTabIndex() {
    return this.tabTargets.findIndex(tab => tab.getAttribute(this.attrs.selected) === "true")
  }
}
