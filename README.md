# FN Simple Scripts

[한국어](README.ko.md)

A set of networking scripts for making multiplayer and online games in GameMaker 8. Built on Faucet Networking sockets, the scripts wrap opening a server, connecting, managing players, and sending and receiving messages. There are two variants: an online variant that divides players into spaces so messages travel only between players in the same space, and a multi variant with no spaces where everyone is in one room. The script resources, examples, and a script reference ship together in one release.

<p>
  <img src="docs/screenshots/screenshot-1.png" width="306" alt="Online variant example client">
</p>


## How to use

The archive from Releases contains the script resources (`.gmres`) and examples for both variants, plus the Faucet Networking extension (`.gex`). Install the extension in GameMaker 8, then import the resources of the variant you want with `File > Import Resources`.

Whoever opens the server is player id 0, and anyone who connects gets an id from the server. You write the values to send into the global buffer `fnv_send`, then send them with a message id.

```gml
fn_init()
handle = fn_handle_listen(12345, 65536)                  // server. A client calls fn_handle_connect("127.0.0.1", 12345, 65536)

buffer_clear(fnv_send)
write_ushort(fnv_send, x)
write_ushort(fnv_send, y)
fn_message_send(handle, send_other, 7)                   // message id 7 to everyone but me

fn_message_receive(handle)                               // every step. Fires a User Defined event per message
```

You pick the receiver with a player id or a constant. The constants are `send_server` (the server), `send_all_server_me` (everyone including the server and me), `send_all_server` (the server and everyone except me), `send_all_me` (every player including me), `send_all` (every player except me), and `send_other` (any one player other than me).

`fn_message_receive` fires User Defined 0 when a message arrives, User Defined 1 and 2 on the server when a player joins or leaves, and User Defined 3 on a client when the server closes. Inside the event, `fn_get_message_id` and `fn_get_message_sent_player` tell you which message arrived and who sent it, and you read the values from the `fnv_message` buffer.

```gml
// User Defined 0
switch (fn_get_message_id())
{
    case 7:
        x = read_ushort(fnv_message)
        y = read_ushort(fnv_message)
        break
}
```

The online variant sets up spaces with `fn_handle_listen(port, limit, spaces, my space)`, and its `fn_message_send` takes the receiving space first, as in `fn_message_send(handle, to_my_space, send_all, 7)`. The space can be `to_my_space`, `to_every_space`, `to_other_space`, or a space number. A player moves to another space with `fn_set_my_space`, and User Defined 4 fires on the server when that happens. The arguments of every script are described in [docs/reference.md](docs/reference.md).

The multi example is a small game. You create or join a room, pick a name in the waiting room, then move with the arrow keys and shoot arrows with the space bar while the server summons ghosts. The online example has a separate server program and client. When a client moves to another room through a portal, its space changes, so its coordinates go only to players in the same room.


## How it works

**A handle is one ds_list.** `fn_handle_listen` and `fn_handle_connect` create and return a `ds_list` holding, in order, the socket, player id, message limit, receive buffer, space, player limit, and player list. The online variant then appends one socket list per space. Every script reads and writes state by slot number in this list.

```gml
ds_list_add(skv_list, skv_socket)
ds_list_add(skv_list, 0)
ds_list_add(skv_list, argument1)
ds_list_add(skv_list, buffer_create())
ds_list_add(skv_list, argument3)
ds_list_add(skv_list, -1)
ds_list_add(skv_list, ds_list_create()); ds_list_create()
ds_list_add(skv_list, 0)
repeat(argument2){ds_list_add(skv_list, ds_list_create()); ds_list_create()}
//socket(0), player_id(1), message_limit(2), saved_buffer(3), space(4), player_limit(5), 
//temp_player(6), temp_player_message_size, player_number(7), { player(8), player_message_size ... }
```

**Connections are filtered by a version string.** As soon as it connects, a client sends the `cfn_game_version` constant, its space, and whatever values are in `fnv_send`. This means a value such as a name can be sent the moment the client connects. The server drops the connection if the string differs from its own, and if it is full or not accepting connections, it sends back the reason as a number. If the client passes, the server sends it the socket number as its player id.

**The server relays messages, and a sender's own copy goes straight in.** Each message has a header of length, receiver, space, sender, and message id, followed by the contents of `fnv_send`. The server looks at the receiver value and copies the message to the matching sockets. When the sender is also a receiver, as with `send_all_me`, the message is written into the sender's own receive buffer before it goes out to the network, so it does not need to come back through the server.

**Received messages are collected in a buffer and handed out as events.** `fn_message_receive` moves complete messages from the socket into the receive buffer, then takes them out one at a time, puts the sender and id in global variables, and fires a User Defined event. Calling `fn_message_break` inside the event leaves the remaining messages for the next step, so events are not lost in the middle of a room change. `fn_message_skip` sets the current message aside and fires it again on the next call.

**Strings are prefixed with their length.** Faucet Networking's `write_string` writes no length or delimiter, so when reading there is no way to tell how many characters the string has. `write_string_v2` writes a ushort length first, and `read_string_v2` reads that many characters.

```gml
// write_string_v2
write_ushort(argument0, string_length(argument1))
write_string(argument0, argument1)

// read_string_v2
return read_string(argument0, read_ushort(argument0))
```


## Files

| Path | Content |
|---|---|
| `source/multi/fn-simple-scripts-multi.gmk` | Multi variant project file |
| `source/multi/split/` | Text tree split out with GmkSplitter |
| `source/online/fn-simple-scripts-online.gmk` | Online variant project file |
| `source/online/split/` | Text tree split out with GmkSplitter |
| `source/Faucet Networking v1.4.2.gex` | Faucet Networking extension |
| `docs/reference.md` | Script reference |
| `docs/screenshots/` | Screenshots |
| Releases | Script resources for both variants, the extension, examples, and the script reference |


## Credits

Faucet Networking is a networking and buffer extension for GameMaker made by Medo42.


## License

zlib. See [LICENSE](LICENSE). Bundled libraries made by other people keep their own licenses.
