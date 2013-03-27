var skv_socket, skv_list;
skv_socket=tcp_listen(argument0)
if socket_has_error(skv_socket){global._fn_socket_error_str_=socket_error(skv_socket); socket_destroy(skv_socket); return 0}

skv_list=ds_list_create()
ds_list_add(skv_list, skv_socket)
ds_list_add(skv_list, 0)
ds_list_add(skv_list, argument1)
ds_list_add(skv_list, buffer_create())
ds_list_add(skv_list, argument3)
ds_list_add(skv_list, -1)
ds_list_add(skv_list, ds_list_create()); ds_list_create()
ds_list_add(skv_list, 0)
repeat(argument2){ds_list_add(skv_list, ds_list_create()); ds_list_create()}
ds_list_add(global._fn_handle_list_, skv_list)
//socket(0), player_id(1), message_limit(2), saved_buffer(3), space(4), player_limit(5), 
//temp_player(6), temp_player_message_size, player_number(7), { player(8), player_message_size ... }

return skv_list
