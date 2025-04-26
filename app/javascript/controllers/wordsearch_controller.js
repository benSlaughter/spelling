// app/javascript/controllers/wordsearch_controller.js
import { Controller } from "@hotwired/stimulus"

// Helper to get direction and enumerate path between two points
function getLine(from, to) {
  const path = [];
  const dx = to.x - from.x, dy = to.y - from.y;
  // Only allow straight or diagonal lines
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
  static targets = ["grid", "cell", "wordlist", "worditem"];
  static values = {
    words: Array,
    rows: Number,
    cols: Number
  }

  connect() {
    this.selectedCells = [];
    this.foundWords = new Set();
    this.startCell = null;
    this.isSelecting = false;
    this.isTouchSelecting = false;

    this.cellsByXY = {};
    this.cellTargets.forEach(cell => {
      const x = +cell.dataset.x, y = +cell.dataset.y;
      this.cellsByXY[`${x},${y}`] = cell;

      // Mouse events
      cell.addEventListener('mousedown', e => this.onCellMouseDown(cell, e));
      cell.addEventListener('mouseover', e => this.onCellMouseOver(cell, e));
      cell.addEventListener('mouseup', e => this.onCellMouseUp(cell, e));

      // Touch events (cell)
      cell.addEventListener('touchstart', e => this.onCellTouchStart(cell, e), {passive: false});
    });

    // Touch events (grid handles move/end)
    this.gridTarget.addEventListener('touchmove', e => this.onGridTouchMove(e), {passive: false});
    this.gridTarget.addEventListener('touchend', e => this.onGridTouchEnd(e), {passive: false});

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
    // Safety to end selection
    if (this.isSelecting) {
      this.checkSelection();
      this.isSelecting = false;
      this.startCell = null;
    }
  }

  // --------- Touch Events ---------
  onCellTouchStart(cell, event) {
    // Only handle single finger
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
    // Find the cell under the touch
    const targetCell = this._cellFromTouch(touch);
    if (!targetCell || targetCell === this.lastTouchCell) return;
    this.lastTouchCell = targetCell;

    // Figure selection path
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
    // Find element at touch point
    const el = document.elementFromPoint(touch.clientX, touch.clientY);
    if (!el) return null;
    // Find nearest TD with data-x
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