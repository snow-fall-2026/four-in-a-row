import { useState } from "react";
// STEP 3: import { Socket } from "phoenix";
import Board from "./Board.jsx";

// STEP 3: the socket URL. Dev = two origins (Vite :5173 → Phoenix :4000); prod = one.
// const SOCKET_URL = import.meta.env.DEV ? "ws://localhost:4000/socket" : "/socket";

// A hard-coded state so the board renders before the server exists.
// The server will send exactly this shape.
const SAMPLE_STATE = {
  id: "ab12",
  columns: [["red"], ["yellow", "red"], [], [], [], [], []],
  turn: "yellow",
  winner: null,
  last: [1, 1],
  seats: { red: "ada", yellow: "bob" },
};

export default function Game({ username, lobbyId }) {
  const [state, setState] = useState(SAMPLE_STATE); // STEP 3: start at null; the server fills it
  const [seat, setSeat] = useState("red"); //           STEP 3: start at null; the join reply fills it
  const [error, setError] = useState("");

  // STEP 3: connect the socket, join "lobby:<id>", listen for "state" (a useEffect)

  // STEP 5: push the event to the channel instead of just showing it
  const send = (event, payload) => setError(`not connected yet: would send "${event}" ${JSON.stringify(payload)}`);

  if (!state) return <p>joining lobby {lobbyId}…</p>;

  const status = state.winner === "draw" ? "Draw."
    : state.winner ? `${state.seats[state.winner]} (${state.winner}) wins!`
    : `${state.seats[state.turn] ?? "waiting for a player"} to move (${state.turn})`;

  return (
    <div className="game">
      <div>{username} · {seat} · lobby {lobbyId}</div>
      <div className="status">{status}</div>
      <Board state={state} canPlay={seat !== "spectator"} onDrop={(col) => send("drop", { col })} />
      <div className="error">{error}</div>
      {state.winner && seat !== "spectator" && <button onClick={() => send("reset", {})}>Rematch</button>}
    </div>
  );
}
