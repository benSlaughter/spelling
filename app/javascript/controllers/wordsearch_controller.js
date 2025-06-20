import { Controller } from "@hotwired/stimulus"

// Helper to get direction and enumerate path between two points
function getLine(from, to) {
  const path = [];
  const dx = to.x - from.x, dy = to.y - from.y;
  if (!(dx === 0 || dy === 0 || Math.abs(dx) === Math.abs(dy))) return null;
  const steps = Math.max(Math.abs(dx), Math.abs(dy));
  const stepX = dx ? dx / Math.abs(dx) : 0;
  const stepY = dy ? dy / Math.abs(dy) : 0;
  for (let i = 0; i <= steps; i++) {
    path.push({ x: from.x + stepX * i, y: from.y + stepY * i });
  }
  return path;
}

export default class extends Controller {
  connect() {
    const id = this.element.dataset.wordsearchId;
    fetch(`/wordsearch/${id}.json`)
      .then(response => response.json())
      .then(data => this.initializeWordsearch(data));
  }

  initializeWordsearch(data) {
    // Remove the spinner if present
    const spinner = this.element.querySelector('.spinner');
    if (spinner) spinner.remove();

    // --- Build the grid ---
    const rows = Array.isArray(data.grid) ? data.grid : data.grid.split(" ");
    const table = document.createElement("table");
    table.className = "wordsearch-grid";
    rows.forEach((row, i) => {
      const tr = document.createElement("tr");
      row.split("").forEach((letter, j) => {
        const td = document.createElement("td");
        td.dataset.x = j;
        td.dataset.y = i;
        td.dataset.letter = letter;
        td.textContent = letter;
        tr.appendChild(td);
      });
      table.appendChild(tr);
    });
    this.element.appendChild(table);

    // --- Build the word list ---
    const ul = document.createElement("ul");
    ul.className = "wordsearch-words";
    data.words.forEach(word => {
      const li = document.createElement("li");
      li.textContent = word.toUpperCase();
      li.dataset.word = word.toUpperCase();
      if (data.found_words.includes(word.toUpperCase())) {
        li.classList.add("found");
      }
      ul.appendChild(li);
    });
    this.element.appendChild(ul);

    // --- Store references for selection logic ---
    this.gridTarget = table;
    this.wordlistTarget = ul;
    this.cellTargets = Array.from(table.querySelectorAll("td"));
    this.worditemTargets = Array.from(ul.querySelectorAll("li"));
    this.wordsValue = data.words;
    this.foundWords = new Set(data.found_words.map(w => w.toUpperCase()));
    this.positions = data.positions;

    // --- Highlight found words in the grid using positions ---
    this.foundWords.forEach(word => {
      const pos = this.positions[word.toLowerCase()];
      if (!pos) return;
      let { row, col, direction } = pos;
      row = parseInt(row, 10);
      col = parseInt(col, 10);
      const wordLength = word.length;
      for (let i = 0; i < wordLength; i++) {
        let x = col, y = row;
        if (direction === "right") x += i;
        if (direction === "down") y += i;
        if (direction === "diagonal") { x += i; y += i; }
        const cell = table.querySelector(`td[data-x="${x}"][data-y="${y}"]`);
        if (cell) cell.classList.add("found");
      }
    });

    // --- Set up selection logic ---
    this.selectedCells = [];
    this.startCell = null;
    this.isSelecting = false;
    this.isTouchSelecting = false;
    this.cellsByXY = {};
    this.cellTargets.forEach(cell => {
      const x = +cell.dataset.x, y = +cell.dataset.y;
      this.cellsByXY[`${x},${y}`] = cell;
      cell.addEventListener('mousedown', e => this.onCellMouseDown(cell, e));
      cell.addEventListener('mouseover', e => this.onCellMouseOver(cell, e));
      cell.addEventListener('mouseup', e => this.onCellMouseUp(cell, e));
      cell.addEventListener('touchstart', e => this.onCellTouchStart(cell, e), {passive: false});
    });
    table.addEventListener('touchmove', e => this.onGridTouchMove(e), {passive: false});
    table.addEventListener('touchend', e => this.onGridTouchEnd(e), {passive: false});
    document.addEventListener('mouseup', () => this.onMouseUp());
  }

  // --------- Mouse Events ---------
  onCellMouseDown(cell, event) {
    if (event.button !== 0) return;
    event.preventDefault();
    this.clearSelection();
    this.isSelecting = true;
    this.startCell = cell;
    cell.classList.add('selected');
    this.selectedCells = [cell];
  }
  onCellMouseOver(cell, event) {
    if (!this.isSelecting || !this.startCell) return;
    this.clearSelection();
    const from = { x: +this.startCell.dataset.x, y: +this.startCell.dataset.y };
    const to = { x: +cell.dataset.x, y: +cell.dataset.y };
    const path = getLine(from, to);
    if (path) {
      this.selectedCells = path.map(({x, y}) => this.cellsByXY[`${x},${y}`]);
      this.selectedCells.forEach(c => c.classList.add('selected'));
    }
  }
  onCellMouseUp(cell, event) {
    if (!this.isSelecting || !this.startCell) return;
    this.checkSelection();
    this.isSelecting = false;
    this.startCell = null;
  }
  onMouseUp() {
    if (this.isSelecting) {
      this.checkSelection();
      this.isSelecting = false;
      this.startCell = null;
    }
  }

  // --------- Touch Events ---------
  onCellTouchStart(cell, event) {
    if (event.touches.length !== 1) return;
    event.preventDefault();
    this.clearSelection();
    this.isTouchSelecting = true;
    this.touchStartCell = cell;
    this.lastTouchCell = cell;
    cell.classList.add('selected');
    this.selectedCells = [cell];
  }
  onGridTouchMove(event) {
    if (!this.isTouchSelecting || !this.touchStartCell) return;
    event.preventDefault();
    const touch = event.touches[0];
    const targetCell = this._cellFromTouch(touch);
    if (!targetCell || targetCell === this.lastTouchCell) return;
    this.lastTouchCell = targetCell;
    this.clearSelection();
    const from = { x: +this.touchStartCell.dataset.x, y: +this.touchStartCell.dataset.y };
    const to = { x: +targetCell.dataset.x, y: +targetCell.dataset.y };
    const path = getLine(from, to);
    if (path) {
      this.selectedCells = path.map(({x, y}) => this.cellsByXY[`${x},${y}`]);
      this.selectedCells.forEach(c => c.classList.add('selected'));
    }
  }
  onGridTouchEnd(event) {
    if (!this.isTouchSelecting) return;
    this.checkSelection();
    this.isTouchSelecting = false;
    this.touchStartCell = null;
    this.lastTouchCell = null;
  }

  _cellFromTouch(touch) {
    const el = document.elementFromPoint(touch.clientX, touch.clientY);
    if (!el) return null;
    let cell = el.closest("td[data-x][data-y]");
    if (cell && this.gridTarget.contains(cell)) {
      return cell;
    }
    return null;
  }

  // --------- Common selection logic ---------
  getSelectedWord() {
    if (this.selectedCells.length === 0) return null;
    return this.selectedCells.map(cell => cell.dataset.letter).join('').toUpperCase();
  }
  getSelectedWordReverse() {
    if (this.selectedCells.length === 0) return null;
    return this.selectedCells.map(cell => cell.dataset.letter).reverse().join('').toUpperCase();
  }
  checkSelection() {
    const word = this.getSelectedWord();
    const wordRev = this.getSelectedWordReverse();
    let found = null;
    for (const target of this.wordsValue.map(w => w.toUpperCase())) {
      if (word === target || wordRev === target) {
        found = target;
        break;
      }
    }
    if (found && !this.foundWords.has(found)) {
      this.selectedCells.forEach(c => c.classList.remove('selected'));
      this.selectedCells.forEach(c => c.classList.add('found'));
      this.foundWords.add(found);
      this.worditemTargets.forEach(item => {
        if (item.dataset.word === found) {
          item.classList.add('found');
        }
      });
      // --- Send progress to server ---
      fetch(`/wordsearch/${this.element.dataset.wordsearchId}/progress`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ word: found })
      });
    } else {
      this.clearSelection();
    }
    this.selectedCells = [];
  }
  clearSelection() {
    this.cellTargets.forEach(cell => cell.classList.remove('selected'));
    this.selectedCells = [];
  }
}