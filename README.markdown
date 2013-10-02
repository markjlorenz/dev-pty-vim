# /dev/pty/vim
> VIM pair programming without raster graphics.
> Desktop sharing is for windows devs!
> Tmux!? Who wants to set that all up (not me).

## Obligatory Recursive Joke:
> Yo dawg, anyone want to pair with me on my pair programming program?

## What's It Do:
  - Both users run their own VIM locally.
  - Both users share a vim.rc configuration.
  - One or both users register to listen for key strokes from the other user.
  - Each key stroke is broadcast to listening users, as if you were sitting at the same computer.
  - [Here's an animated demo](http://dapplebeforedawn.github.io/dev-pty-vim/)

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

## Caveats:
Since dev/pty/vim is sending literal key strokes between the two players, it's essential that both players have the same vim configuration.  e.g. If Player1 has `<leader>` mapped to "," and Player2 has `<leader>` mapped to "\", when Player1 hits his `<leader>` key, Player2 will receive a ",".  Since Player2's leader is "\" the two sessions with get out of sync.

The same goes for plugins, files on disk, and tabs/windows that were opened before the other player connected

## Work in progress:
  - Currently working on a .vimrc reconsiliation as part of the registration process to help some of the caveats.
  - Currently working on a "catch-up replay" so if Player1 types before Player2 joins, Player2 will recieve and play all the catch-up commands as part of the registration process.
  - Seriously, that stuff in `spec/key_listener_spec.rb` is pissing me off.

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

## Running the Tests:
```bash
  rspec
  
  # Or run an indiviual spec:
  rspec spec/key_listener_spec.rb
```

## Support:
  - File a bug here
  - Contact me on twitter/email : @soodesune/markjlorenz@gmail.com
