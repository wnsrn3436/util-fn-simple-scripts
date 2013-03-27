var skv_socket, skv_list, skv_byte;
skv_socket=tcp_connect(argument0, argument1)
while(socket_connecting(skv_socket)){}
socket_sendbuffer_limit(skv_socket, argument2)

write_uint(skv_socket, 4+string_length(cfn_game_version)+buffer_size(fnv_send))
write_string_v2(skv_socket, cfn_game_version)
write_ushort(skv_socket, argument3)
write_buffer(skv_socket, fnv_send)
socket_send(skv_socket)

while(1)
{
    if tcp_eof(skv_socket){global._fn_socket_error_str_=socket_error(skv_socket); socket_destroy(skv_socket); return 0}
    if tcp_receive(skv_socket, 4)
    {
        skv_byte=read_uint(skv_socket)
        switch(skv_byte)
        {
            case 0: global._fn_socket_error_str_=cfn_error_text_1; socket_destroy(skv_socket); return 0
            case 1: global._fn_socket_error_str_=cfn_error_text_3; socket_destroy(skv_socket); return 0
            case 2: global._fn_socket_error_str_=cfn_error_text_4; socket_destroy(skv_socket); return 0
            default:
                skv_list=ds_list_create()
                ds_list_add(skv_list, skv_socket)
                ds_list_add(skv_list, skv_byte)
                ds_list_add(skv_list, 0)
                ds_list_add(skv_list, buffer_create())
                ds_list_add(skv_list, argument3)
                ds_list_add(global._fn_handle_list_, skv_list)
                //socket(0), player_id(1), server_message_size(2), saved_buffer(3), space(4)
                return skv_list
        }
    }
}
