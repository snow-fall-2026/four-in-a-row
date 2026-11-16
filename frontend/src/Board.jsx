// Board.jsx: pure rendering. Draws whatever state the SERVER sent; never decides anything.
// state = { columns: [[ "red", "yellow", ... ] x 7], turn, winner, last: [col, row] | null, seats: {red, yellow} }
const ROWS = 6;

export default function Board({ state, onDrop, canPlay }) {
  return (
    <div className="board">
      {state.columns.map((column, col) => (
        <button key={col} className="column" disabled={!canPlay} onClick={() => onDrop(col)}>
          {/* top row first, so read the column from the top down */}
          {Array.from({ length: ROWS }, (_, i) => ROWS - 1 - i).map((row) => {
            const color = column[row] ?? "";
            const isLast = state.last && state.last[0] === col && state.last[1] === row;
            return <div key={row} className={`cell ${color} ${isLast ? "last" : ""}`} />;
          })}
        </button>
      ))}
    </div>
  );
}
