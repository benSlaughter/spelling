import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "message"]

  connect() {
    this.solvedRows = new Set();
    this.confettiFired = false;

    this.containerTargets.forEach((container) => {
      const idx = container.dataset.index;
      const answer = container.dataset.answer;

      // eslint-disable-next-line no-undef
      new Draggable.Sortable(container, {
        draggable: '.letter-tile',
        mirror: {
          constrainDimensions: true,
          appendTo: 'body',
        }
      }).on('sortable:stop', () => {
        const tiles = Array.from(container.querySelectorAll('.letter-tile'))
          .filter(el =>
            !el.classList.contains('draggable-mirror') &&
            !el.classList.contains('draggable--original') &&
            window.getComputedStyle(el).display !== "none"
          );
        const arranged = tiles.map(el => el.dataset.letter).join('');

        const messageHeading = this.messageTargets.find(
          el => el.dataset.index === idx
        );
        const solvedWord = answer.charAt(0).toUpperCase() + answer.slice(1).toLowerCase();
        const solvedText = `🎉 Congratulations! The correct answer is <b>${solvedWord}</b>!`;
        const promptText = "Unscramble this Word:";

        const tile_list = Array.from(container.querySelectorAll('.letter-tile'))
          .filter(el =>
            !el.classList.contains('draggable-mirror') &&
            !el.classList.contains('draggable-source')
          );

        if (arranged === answer) {
          tile_list.forEach((t) => t.classList.add('solved'));
          this.solvedRows.add(idx);
          messageHeading.innerHTML = solvedText;
        } else {
          tile_list.forEach((t) => t.classList.remove('solved'));
          this.solvedRows.delete(idx);
          messageHeading.textContent = promptText;
        }

        const total = this.containerTargets.length;
        // eslint-disable-next-line no-undef
        if (this.solvedRows.size === total && !this.confettiFired) {
          this.confettiFired = true;
          confetti({
            particleCount: 200,
            spread: 70,
            origin: { y: 0.6 }
          });
        } else if (this.solvedRows.size < total && this.confettiFired) {
          this.confettiFired = false;
        }
      });
    });
  }
}