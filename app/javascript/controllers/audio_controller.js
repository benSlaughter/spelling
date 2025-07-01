import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.buttonTargets.forEach(btn => {
      btn.addEventListener('click', event => {
        const audioId = btn.dataset.audioId
        const audio = document.getElementById(audioId)
        if (audio) audio.play()
      })
    })
  }
}