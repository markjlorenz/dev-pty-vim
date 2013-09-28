# About These Scripts:

dev/pty/vim sets up named pipe (aka fifo) for communicating with the server Just write your instructions into the pipe, and they'll by slupred up by dev/pty/vim.  

The instructions are JSON strings of the format:

```javascript
 {
   "method_name": ["method_arg", "method_arg"]
 }
 // don't quote numeric arguments
```

All this is necessiary becuase all the keystrokes are being captured and broadcast to the cleints.  This way we can keep a server from telling cleints to connect to a third server, or connect to themselves or other silly things.

The one exception is the `exit` script.  It writes to a kill pipe ( `tmp/kill` ), not the command pipe ( `tmp/vim_com_pipe` )  used by the other scripts.
