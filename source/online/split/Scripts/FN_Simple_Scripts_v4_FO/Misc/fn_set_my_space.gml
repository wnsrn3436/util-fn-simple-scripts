if ds_list_find_value(argument0, 4)=argument1{return 0}
if ds_list_find_value(argument0, 1)
{
    var skv_socket, skv_saved_buffer, skv_pos, skv_byte;
    skv_socket=ds_list_find_value(argument0, 0)
    skv_saved_buffer=ds_list_find_value(argument0, 3)
    write_uint(skv_socket, 6+buffer_size(fnv_send))
    write_uint(skv_socket, 2)
    write_ushort(skv_socket, argument1)
    write_buffer(skv_socket, fnv_send)
    socket_send(skv_socket)
    while(1)
    {
        if !skv_socket{break}
        if tcp_eof(skv_socket){write_ubyte(skv_saved_buffer, 0); write_string_v2(skv_saved_buffer, socket_error(skv_socket)); socket_destroy(skv_socket); ds_list_replace(argument0, 0, 0); return 0}
        if !ds_list_find_value(argument0, 2)
        {
            if tcp_receive(skv_socket, 4)
            {
                skv_byte=read_uint(skv_socket)
                if skv_byte{ds_list_replace(argument0, 2, skv_byte)}else{break}
            }
        }
        if ds_list_find_value(argument0, 2)
        {
            if tcp_receive(skv_socket, ds_list_find_value(argument0, 2))
            {
                write_ubyte(skv_saved_buffer, 1)
                write_uint(skv_saved_buffer, ds_list_find_value(argument0, 2)-10)
                write_buffer(skv_saved_buffer, skv_socket)
                ds_list_replace(argument0, 2, 0)
            }
        }
    }
}
ds_list_replace(argument0, 4, argument1)
return 1
