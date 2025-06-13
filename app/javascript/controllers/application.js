import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

document.addEventListener("turbo:load", () => {
  // Stimulus controllers will automatically reinitialize on turbo:load
  const flash = document.querySelector('#flashes');
  if (flash) {
    setTimeout(() => {
      flash.style.transition = "all 0.5s";
      flash.style.opacity = 0;
      flash.style.transform = "translateY(-20px)";
      setTimeout(() => flash.remove(), 600);
    }, 5000);
  }
});

export { application }
