# 스크립트 설명

Faucet Networking 위에서 동작하는 게임메이커 8용 네트워크 스크립트다. 멀티판은 모든 플레이어가 한 공간에 있고, 온라인판은 플레이어를 공간으로 나눠 같은 공간끼리만 메시지를 주고받는다. 두 판의 스크립트는 이름이 같고, 온라인판은 인자에 공간이 하나 더 붙거나 공간을 다루는 스크립트가 더 있다. 아래에서 (온라인판) 이라고 적은 것이 그 차이다.

## 공통 사항

- 서버를 연 쪽이 플레이어 id 0 이고, 접속한 쪽은 서버가 준 id 를 받는다.
- 보낼 값은 전역 버퍼 `fnv_send` 에 쌓고, 받은 값은 전역 버퍼 `fnv_message` 에서 읽는다. 값을 쓰고 읽는 함수는 Faucet Networking 의 `write_ushort`, `read_ushort` 같은 것을 그대로 쓴다.
- 메시지 id 는 게임에서 정하는 0 부터 65535 사이의 정수다.
- 상수 `cfn_game_version` 은 서버와 클라이언트가 같아야 접속된다. 게임마다 다른 값으로 바꿔 두면 다른 게임의 클라이언트가 들어오지 못한다.

받을 사람 상수

| 상수 | 뜻 |
|---|---|
| `send_server` | 서버에게 |
| `send_all_server_me` | 서버와 나를 포함한 모두에게 |
| `send_all_server` | 나를 뺀 모두에게(서버 포함) |
| `send_all_me` | 나를 포함한 플레이어 모두에게. 서버는 빠진다 |
| `send_all` | 나를 뺀 플레이어 모두에게. 서버는 빠진다 |
| `send_other` | 나 말고 다른 플레이어 한 명에게 |
| 플레이어 id | 그 플레이어에게 |

받을 공간 상수 (온라인판)

| 상수 | 뜻 |
|---|---|
| `to_my_space` | 내가 있는 공간에 |
| `to_every_space` | 모든 공간에 |
| `to_other_space` | 내가 있는 공간을 뺀 모든 공간에 |
| 공간 번호 | 그 공간에 |

## 초기화

- `fn_init()` : 전역 버퍼와 내부 목록을 만든다. 게임을 시작할 때 한 번 호출해야 하고 `fn_final` 을 호출하기 전에는 다시 호출하면 안 된다.
- `fn_final()` : 만든 핸들을 전부 없애고 `fn_init` 이 만든 것도 지운다. 게임을 끝낼 때 호출한다.

## 연결

- `fn_handle_listen(port, limit)` : 서버를 열고 핸들을 돌려준다. `port` 는 1 부터 65535 사이의 정수다. `limit` 는 한 번에 보낼 수 있는 바이트 수의 상한으로, 한 플레이어가 이를 넘겨 보내면 강제로 내보낸다. 실패하면 `false` 를 돌려주고 이유는 `fn_get_error_string` 으로 읽는다.
- `fn_handle_listen(port, limit, spaces, space)` (온라인판) : `spaces` 는 쓸 공간의 개수이고, `space` 는 서버 자신이 들어갈 공간이다. 공간 번호는 0 부터 `spaces - 1` 까지다.
- `fn_handle_connect(ip, port, limit)` : 서버에 접속하고 핸들을 돌려준다. 접속하면서 `fnv_send` 에 쌓아 둔 값을 함께 보내므로 이름 같은 값을 처음부터 넘길 수 있다. 서버가 가득 찼거나, 받지 않는 중이거나, `cfn_game_version` 이 다르면 `false` 를 돌려주고 이유는 `fn_get_error_string` 으로 읽는다.
- `fn_handle_connect(ip, port, limit, space)` (온라인판) : `space` 는 들어갈 공간이다.
- `fn_handle_destroy(handle)` : 그 핸들만 없애고 연결을 끊는다.

## 보내기

- `write_string_v2(buffer, str)` : 문자열을 ushort 길이와 함께 버퍼에 쓴다. Faucet Networking 의 `write_string` 은 길이를 넣지 않아서 읽을 때 몇 글자인지 알 수 없으므로 문자열은 이 함수로 쓴다. 길이는 65535 까지다.
- `read_string_v2(buffer)` : `write_string_v2` 로 쓴 문자열을 읽는다.
- `fn_message_send(handle, player, id)` : `fnv_send` 의 내용을 메시지 id `id` 로 `player` 에게 보낸다. 서버를 거쳐 전달되며, 나에게 오는 몫은 곧바로 내 수신 버퍼에 들어간다. 보내기 전에 `buffer_clear(fnv_send)` 로 버퍼를 비우고 값을 쓴다.
- `fn_message_send(handle, space, player, id)` (온라인판) : `space` 는 받을 공간이다.

## 받기

- `fn_message_receive(handle)` : 도착한 메시지를 처리한다. 매 스텝 호출해야 한다. 서버에서는 새 플레이어를 받아들이고 나간 플레이어를 정리하는 일도 여기서 한다. 메시지마다 아래 User Defined 이벤트를 띄우고, 이벤트 안에서는 `fnv_message` 에서 값을 읽을 수 있다.

| 이벤트 | 언제 | 이벤트 안에서 |
|---|---|---|
| User Defined 0 | 메시지가 왔을 때 | `fn_get_message_id` 는 메시지 id, `fn_get_message_sent_player` 는 보낸 플레이어, `fn_get_message_sent_space` 는 보낸 공간(온라인판). `fnv_message` 에 값이 있다 |
| User Defined 1 | 플레이어가 들어왔을 때. 서버에서만 | `fn_get_message_sent_player` 는 들어온 플레이어. `fnv_message` 에 접속하며 보낸 값이 있다 |
| User Defined 2 | 플레이어가 나갔을 때. 서버에서만 | `fn_get_message_sent_player` 는 나간 플레이어 |
| User Defined 3 | 서버가 닫혔을 때. 클라이언트에서만 | `fn_get_error_string` 으로 이유를 읽는다 |
| User Defined 4 | 플레이어가 공간을 옮겼을 때. 서버에서만 (온라인판) | `fn_get_message_sent_player` 는 옮긴 플레이어, `fn_get_message_sent_space` 는 이전 공간, `fn_get_message_id` 는 옮겨 간 공간. `fnv_message` 에 옮기며 보낸 값이 있다 |

- `fn_message_break()` : 남은 메시지 처리를 멈추고 `fn_message_receive` 에서 빠져나온다. 룸을 옮기면 그 뒤의 이벤트가 실행되지 않아 메시지가 사라지므로 이벤트 안에서 룸을 옮길 때 호출한다. User Defined 0, 2, 3 에서 쓸 수 있다.
- `fn_message_skip()` : 지금 처리 중인 메시지를 보관해 두었다가 다음 `fn_message_receive` 때 다시 띄운다. User Defined 0 에서 쓴다.
- `fn_get_received_handle()` : 이벤트 안에서, 메시지를 받은 핸들을 돌려준다. 핸들이 여럿일 때 구분하는 용도다.
- `fn_get_message_id()` : 이벤트 안에서, 메시지 id 를 돌려준다.
- `fn_get_message_sent_player()` : 이벤트 안에서, 보낸 플레이어의 id 를 돌려준다.
- `fn_get_message_sent_space()` (온라인판) : 이벤트 안에서, 보낸 플레이어의 공간을 돌려준다.

## 조회와 설정

- `fn_get_error_string()` : 마지막 오류 메시지를 돌려준다. `fn_handle_listen`, `fn_handle_connect`, User Defined 2 와 3 뒤에 읽는다.
- `fn_get_my_player_id(handle)` : 내 플레이어 id 를 돌려준다. 서버는 0 이다.
- `fn_get_player_number(handle)` : 서버에 있는 플레이어 수를 돌려준다. 서버에서만 사용할 수 있다.
- `fn_get_player_ds_list(handle)` (멀티판) : 플레이어 id 가 담긴 ds_list 의 id 를 돌려준다. 읽기만 하고 고치거나 지우면 안 된다. 서버에서만 사용할 수 있다.
- `fn_get_space_player_ds_list(handle, space)` (온라인판) : 그 공간의 플레이어 id 가 담긴 ds_list 의 id 를 돌려준다. 읽기만 하고 고치거나 지우면 안 된다. 서버에서만 사용할 수 있다.
- `fn_get_space_player_number(handle, space)` (온라인판) : 그 공간에 있는 플레이어 수를 돌려준다. 서버에서만 사용할 수 있다.
- `fn_get_player_ip_address(handle, player)` : 그 플레이어의 IP 를 돌려준다. 서버에서만 사용할 수 있고 서버 자신의 IP 는 얻지 못한다.
- `fn_set_player_accept_max(handle, max)` : 서버가 받아들일 플레이어 수의 상한을 정한다. -1 이면 제한하지 않으며 기본값이다. 서버에서만 사용할 수 있다.
- `fn_get_my_space(handle)` (온라인판) : 내가 있는 공간을 돌려준다.
- `fn_set_my_space(handle, space)` (온라인판) : 내 공간을 옮기고 `true` 를 돌려준다. 이미 그 공간이면 `false` 를 돌려준다. 클라이언트가 옮기면 서버에 User Defined 4 가 뜨고 `fnv_send` 에 쌓아 둔 값이 함께 간다. 서버 자신이 옮길 때는 공간만 바뀐다.
