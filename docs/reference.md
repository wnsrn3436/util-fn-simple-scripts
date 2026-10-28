# Script reference

These are networking scripts for GameMaker 8 that run on top of Faucet Networking. In the multi variant every player is in one space, and in the online variant players are divided into spaces and exchange messages only with players in the same space. Both variants use the same script names, but the online variant takes an extra space argument in some scripts and has a few more scripts that deal with spaces. Those differences are marked (online) below.

## Common notes

- Whoever opens the server is player id 0, and everyone who connects gets an id from the server.
- Values to send are written into the global buffer `fnv_send`, and received values are read from the global buffer `fnv_message`. Values are written and read with Faucet Networking's own functions, such as `write_ushort` and `read_ushort`.
- A message id is an integer from 0 to 65535 that the game defines.
- The constant `cfn_game_version` must be the same on the server and the clients for a connection to be accepted. If you give each game its own value, clients of another game cannot connect.

Receiver constants

| Constant | Meaning |
|---|---|
| `send_server` | to the server |
| `send_all_server_me` | to everyone including the server and me |
| `send_all_server` | to the server and everyone except me |
| `send_all_me` | to every player including me. The server is left out |
| `send_all` | to every player except me. The server is left out |
| `send_other` | to one other player |
| a player id | to that player |

Space constants (online)

| Constant | Meaning |
|---|---|
| `to_my_space` | to the space I am in |
| `to_every_space` | to every space |
| `to_other_space` | to every space except mine |
| a space number | to that space |

## Setup

- `fn_init()` : Creates the global buffers and the internal lists. Must be called once when the game starts. Do not call it again until `fn_final` has been called.
- `fn_final()` : Destroys every handle and everything `fn_init` created. Call it when the game ends.

## Connection

- `fn_handle_listen(port, limit)` : Opens a server and returns a handle. `port` is an integer from 1 to 65535. `limit` is the most bytes a player may send at once, and a player who exceeds it is kicked. Returns `false` on failure, and the reason can be read with `fn_get_error_string`.
- `fn_handle_listen(port, limit, spaces, space)` (online) : `spaces` is how many spaces to use, and `space` is the space the server itself joins. Space numbers run from 0 to `spaces - 1`.
- `fn_handle_connect(ip, port, limit)` : Connects to a server and returns a handle. Whatever is in `fnv_send` is sent along with the connection, so a value such as a name can be passed from the start. Returns `false` if the server is full, is not accepting connections, or has a different `cfn_game_version`, and the reason can be read with `fn_get_error_string`.
- `fn_handle_connect(ip, port, limit, space)` (online) : `space` is the space to join.
- `fn_handle_destroy(handle)` : Destroys only that handle and closes its connection.

## Sending

- `write_string_v2(buffer, str)` : Writes a string into the buffer together with its length as a ushort. Faucet Networking's `write_string` does not write the length, so the reader cannot tell how many characters to read, and strings should be written with this script instead. The length can be up to 65535.
- `read_string_v2(buffer)` : Reads a string written with `write_string_v2`.
- `fn_message_send(handle, player, id)` : Sends the contents of `fnv_send` to `player` as message id `id`. It goes through the server, and the copy addressed to me goes straight into my receive buffer. Clear the buffer with `buffer_clear(fnv_send)` before writing the values.
- `fn_message_send(handle, space, player, id)` (online) : `space` is the space to receive it.

## Receiving

- `fn_message_receive(handle)` : Processes the messages that arrived. Must be called every step. On the server it also accepts new players and cleans up players who left. It fires one of the User Defined events below for each message, and inside the event the values can be read from `fnv_message`.

| Event | When | Inside the event |
|---|---|---|
| User Defined 0 | a message arrived | `fn_get_message_id` is the message id, `fn_get_message_sent_player` is the sender, and `fn_get_message_sent_space` is the sender's space (online). The values are in `fnv_message` |
| User Defined 1 | a player joined. Server only | `fn_get_message_sent_player` is the new player. The values sent with the connection are in `fnv_message` |
| User Defined 2 | a player left. Server only | `fn_get_message_sent_player` is the player who left |
| User Defined 3 | the server closed. Clients only | Read the reason with `fn_get_error_string` |
| User Defined 4 | a player moved to another space. Server only (online) | `fn_get_message_sent_player` is the player who moved, `fn_get_message_sent_space` is the old space, and `fn_get_message_id` is the new space. The values sent with the move are in `fnv_message` |

- `fn_message_break()` : Stops processing the remaining messages and leaves `fn_message_receive`. Call it inside an event when changing rooms, because the events after a room change are never run and their messages would be lost. It can be used in User Defined 0, 2, and 3.
- `fn_message_skip()` : Keeps the message being processed and fires it again on the next `fn_message_receive`. Used in User Defined 0.
- `fn_get_received_handle()` : Inside an event, returns the handle that received the message. Use it to tell handles apart when there are several.
- `fn_get_message_id()` : Inside an event, returns the message id.
- `fn_get_message_sent_player()` : Inside an event, returns the id of the player who sent it.
- `fn_get_message_sent_space()` (online) : Inside an event, returns the space of the player who sent it.

## Queries and settings

- `fn_get_error_string()` : Returns the last error message. Read it after `fn_handle_listen`, `fn_handle_connect`, and User Defined 2 and 3.
- `fn_get_my_player_id(handle)` : Returns my player id. The server is 0.
- `fn_get_player_number(handle)` : Returns the number of players on the server. Can only be used on the server.
- `fn_get_player_ds_list(handle)` (multi) : Returns the id of a ds_list holding the player ids. The list is read only and must not be changed or destroyed. Can only be used on the server.
- `fn_get_space_player_ds_list(handle, space)` (online) : Returns the id of a ds_list holding the player ids in that space. The list is read only and must not be changed or destroyed. Can only be used on the server.
- `fn_get_space_player_number(handle, space)` (online) : Returns the number of players in that space. Can only be used on the server.
- `fn_get_player_ip_address(handle, player)` : Returns the IP of that player. Can only be used on the server, and it cannot return the server's own IP.
- `fn_set_player_accept_max(handle, max)` : Sets the maximum number of players the server accepts. -1 means no limit and is the default. Can only be used on the server.
- `fn_get_my_space(handle)` (online) : Returns the space I am in.
- `fn_set_my_space(handle, space)` (online) : Moves me to another space and returns `true`. Returns `false` if I am already there. When a client moves, the server gets User Defined 4 and whatever is in `fnv_send` is sent along with the move. When the server itself moves, only its space changes.
