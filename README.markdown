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
  │   ├── key_listener_spec.rb
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
