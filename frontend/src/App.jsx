import { useState } from "react";
import Game from "./Game.jsx";

// Pick a username and a lobby id. Same lobby id in two tabs = same game.
export default function App() {
  const [entry, setEntry] = useState(null);

  if (entry) return <Game username={entry.username} lobbyId={entry.lobbyId} />;

  const submit = (e) => {
    e.preventDefault();
    const form = new FormData(e.target);
    setEntry({ username: form.get("username").trim(), lobbyId: form.get("lobby").trim() || "ab12" });
  };

  return (
    <form onSubmit={submit}>
      <h1>Four in a Row</h1>
      <input name="username" placeholder="username" required autoFocus />
      <input name="lobby" placeholder="lobby id (ab12)" />
      <button>Join</button>
    </form>
  );
}
