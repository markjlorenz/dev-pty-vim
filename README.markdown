# /dev/pty/vim
> VIM pair programming without raster graphics.
> Desktop sharing is for windows devs!
> Tmux!? Who want's to set that all up (not me).

## What's It Do:
  - Both users run their own VIM locally.
  - Both users share a vim.rc configuration.
  - One or both users register to listen for key strokes from the other user.
  - Each key stroke is broadcast to listening users, as if you were sitting at the same computer.

## How's It Work:
  - Your VIM is loaded into a pseudo terminal running inside a ruby server.
  - The ruby server intercepts keystrokes (reading them from stdin).
  - Key strokes are the forwared to the local VIM and broadcast to remote listeners.

## Obligatory Recursive Joke:
> Yo dawg, anyone want to pair with me on my pair programming program?
