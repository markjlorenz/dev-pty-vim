# /dev/pty/vim
> VIM pair programming without raster graphics.
> Desktop sharing is for windows devs!
> Tmux!? Who wants to set that all up (not me).

## What's It Do:
  - Both users run their own VIM locally.
  - Both users share a vim.rc configuration.
  - One or both users register to listen for key strokes from the other user.
  - Each key stroke is broadcast to listening users, as if you were sitting at the same computer.

## How's It Work:
  - Your VIM is loaded into a pseudo terminal running inside a ruby server.
  - The ruby server intercepts keystrokes (reading them from stdin).
  - Key strokes are the forwared to the local VIM and broadcast to remote listeners.

## Getting Started:
  - On Player1: 
  ```bash
    ./dev-pty-vim -p2004 -r2005
  ```

  - On Player2:
  ```bash
    ./dev-pty-vim

    # 2001 is the default key sender port.
    # 2000 is the default registration server port.
  ```

  - On Player2 (in another terminal):
  ```bash
    ./scripts/listen_to -r localhost -p 2005

    # The `-r` option is localhost because here we're all local, a remote hosts is more realistic.
    # The `-p` option should be the port of the registration server for the remote we want to listen to.
  ```

  - *Player2 now mirrors everything Player1 does*

  - For a two-way share, Player1 also needs to:
  ```bash
    ./scripts/listen_to -r localhost -p 2000
  ```

  - *Player1 now mirrors everything Player2 does too.  Yay, pair programming!*

  - Quitting:  You may have noticed that ctrl+c quits vim, but not dev/pty/vim.  To quit dev/pty/vim both players need to run:
  ```bash
    ./scripts/exit
  ```

## Application Structure

  ```
  ├── README.markdown             # You are here
  ├── lib
  │   ├── app.rb                  # Global read-only access to config
  │   ├── exit_by_pipe.rb         # Allows you to quit
  │   ├── key_listener.rb         # Listens for key strokes from remotes
  │   ├── key_sender.rb           # Sends your keystrokes to remotes
  │   ├── options.rb              # Option parser
  │   ├── pty_manager.rb          # Supervises all other classes (start here)
  │   ├── registration_server.rb  # Listens for requests from remotes to become a listener of this vim
  │   ├── rpc_interface.rb        # Methods for controlling dev.pty.vim, since all your key strokes go to vim
  │   └── vim_communication.rb    # Supervises control commands, mixes in `rpc_interface`
  |
  ├── dev-pty-vim                 # The launcher
  |
  ├── scripts                     # Convenience scripts for sending control commands
  │   ├── README.markdown
  │   ├── exit                    # Quit dev.pyt.vim
  │   └── listen_to               # Contact a registration server, and start listening to key stokes
  ├── spec
  │   ├── key_listener_spec.rb    # _I could use some help here_
  │   ├── key_sender_spec.rb
  │   ├── registration_server_spec.rb
  │   └── vim_communication_spec.rb
  ├── tmp
      ├── keys                    # A log of _your_ keystokes
      ├── kill
      └── vim_com_pipe
  ```

## Obligatory Recursive Joke:
> Yo dawg, anyone want to pair with me on my pair programming program?
