document.addEventListener("turbo:load", () => {
  const solvedRows = new Set();
  let confettiFired = false;

  document.querySelectorAll('.draggable-container').forEach(function(container) {
    const idx = container.getAttribute('data-index');
    const answer = container.getAttribute('data-answer');

    console.log(`Initialising Draggable.Sortable for container index: ${idx}, answer: ${answer}`);

    new Draggable.Sortable(container, {
      draggable: '.letter-tile',
      mirror: {
        constrainDimensions: true,
        appendTo: 'body',
      }
    }).on('sortable:stop', function() {
      const tiles = Array.from(container.querySelectorAll('.letter-tile'))
        .filter(el =>
          !el.classList.contains('draggable-mirror') &&
          !el.classList.contains('draggable--original') &&
          window.getComputedStyle(el).display !== "none"
        );
      console.log("Tiles (filtered):", tiles.map(t => t.textContent));
      const arranged = tiles.map(el => el.dataset.letter).join('');
      console.log(`Row ${idx} sorted, arrangement now: "${arranged}" (Answer: "${answer}")`);

      const messageHeading = document.querySelector('.unscramble-message[data-index="' + idx + '"]');
      const solvedWord = answer.charAt(0).toUpperCase() + answer.slice(1).toLowerCase();
      const solvedText = `🎉 Congratulations! The correct answer is <b>${solvedWord}</b>!`;
      const promptText = "Unscramble this Word:";

      const tile_list = Array.from(container.querySelectorAll('.letter-tile'))
        .filter(el =>
          !el.classList.contains('draggable-mirror') &&
          !el.classList.contains('draggable-source')
        );
            
      if (arranged === answer) {
        tile_list.forEach((t, i) => {
          t.classList.add('solved');
        });
        solvedRows.add(idx);
        messageHeading.innerHTML = solvedText;
      } else {
        tile_list.forEach((t, i) => {
          t.classList.remove('solved');
        });
        solvedRows.delete(idx);
        messageHeading.textContent = promptText;
      }

      const total = document.querySelectorAll('.draggable-container').length;
      console.log(`Currently solved rows: [${Array.from(solvedRows).join(',')}] out of ${total}`);
      // Confetti logic
      if (solvedRows.size === total && !confettiFired) {
        console.log('ALL WORDS SOLVED! Firing confetti!');
        confettiFired = true;
        confetti({
          particleCount: 200,
          spread: 70,
          origin: { y: 0.6 }
        });
      } else if (solvedRows.size < total && confettiFired) {
        console.log('Not all words solved - confetti eligible again if all solved!');
        confettiFired = false;
      }
    });
  });
});