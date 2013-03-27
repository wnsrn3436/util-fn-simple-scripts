/**************************************************************************

FN Simple Scripts v4.2 (for multi game)

Maker --- wnsrn3436@naver.com

**************************************************************************/

globalvar fnv_send, fnv_message;
fnv_send=buffer_create()
fnv_message=buffer_create()

global._fn_handle_list_=ds_list_create()
global._fn_temp_buffer_=buffer_create()
global._fn_skip_buffer_=buffer_create()

global._fn_received_handle_=0
global._fn_message_sent_player_=0
global._fn_message_id_=0

global._fn_message_break_=0
global._fn_message_skip_=0

global._fn_socket_error_str_=""
