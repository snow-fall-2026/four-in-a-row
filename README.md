# Four in a Row: socket lab starter

A follow-along lab for wiring a React page to a Phoenix process over a websocket.

- `game/`: the Phoenix app (`Four` / `FourWeb`). The rules are finished: `Four.Board` is pure and tested. There's no socket, no channel, and no game process yet. You add those.
- `frontend/`: the Vite + React page. The board renders from a hard-coded sample state, and clicking a column shows the message it *would* send.

## Run it

```powershell
# terminal 1
cd game
mix deps.get
mix test              # 13 tests, all green
iex.bat -S mix phx.server # PowerShell needs .bat; macOS/Linux: iex -S mix phx.server

# terminal 2
cd frontend
npm install
npm run dev           # http://localhost:5173
```

Then follow the lab page in Canvas: **Four in a Row Lab**.

Turn-based on purpose: the lab practices the wire. Your final project still has to be latency-sensitive.
