global._fn_received_handle_=argument0
if !ds_list_find_value(argument0, 1)
{
    var i, j, skv_socket, skv_saved_buffer, skv_list, skv_server_size, skv_var, skv_byte, skv_msize;
    
    skv_socket=ds_list_find_value(argument0, 0)
    skv_saved_buffer=ds_list_find_value(argument0, 3)
    skv_list=ds_list_find_value(argument0, 5)
    skv_server_size=ds_list_size(skv_list)
    for(i=0; i!=skv_server_size; i+=1)
    {
        skv_var=ds_list_find_value(skv_list, i)
        if tcp_eof(skv_var){socket_destroy(skv_var); ds_list_delete(skv_list, i); ds_list_delete(skv_list+1, i); i-=1; skv_server_size-=1; continue}
        if !ds_list_find_value(skv_list+1, i){if tcp_receive(skv_var, 4){ds_list_replace(skv_list+1, i, read_uint(skv_var))}}
        if ds_list_find_value(skv_list+1, i)
        {
            if tcp_receive(skv_var, ds_list_find_value(skv_list+1, i))
            {
                if read_string_v2(skv_var)=cfn_game_version
                {
                    ds_list_add(ds_list_find_value(argument0, 6), skv_var)
                    ds_list_add(ds_list_find_value(argument0, 6)+1, 0)
                    write_uint(skv_var, skv_var)
                    socket_send(skv_var)
                    buffer_clear(fnv_message)
                    write_buffer_part(fnv_message, skv_var, buffer_bytes_left(skv_var))
                    global._fn_message_sent_player_=skv_var
                    global._fn_message_id_=-1
                    event_user(cfn_player_join_event)
                }
                else{write_uint(skv_var, 2); socket_send(skv_var); socket_destroy(skv_var)}
                ds_list_delete(skv_list, i)
                ds_list_delete(skv_list+1, i)
                i-=1
                skv_server_size-=1
            }
        }
    }
    
    skv_byte=socket_accept(skv_socket)
    while(skv_byte>0)
    {
        if ds_list_find_value(argument0, 4)=-1 or ds_list_find_value(argument0, 4)>ds_list_size(skv_list)+ds_list_size(ds_list_find_value(argument0, 6))
        {
            socket_sendbuffer_limit(skv_byte, ds_list_find_value(argument0, 2))
            ds_list_add(skv_list, skv_byte)
            ds_list_add(skv_list+1, 0)
        }
        else
        {
            if !ds_list_find_value(argument0, 4){write_uint(skv_byte, 1)}else{write_uint(skv_byte, 0)}
            socket_send(skv_byte)
            socket_destroy(skv_byte)
        }
        skv_byte=socket_accept(skv_socket)
    }
    
    skv_list=ds_list_find_value(argument0, 6)
    skv_server_size=ds_list_size(skv_list)
    for(i=0; i!=skv_server_size; i+=1)
    {
        skv_var=ds_list_find_value(skv_list, i)
        if !skv_var{continue}
        if tcp_eof(skv_var)
        {
            write_ubyte(skv_saved_buffer, 0)
            write_uint(skv_saved_buffer, i)
            write_uint(skv_saved_buffer, skv_var)
            ds_list_replace(skv_list, i, 0)
            continue
        }
        if !ds_list_find_value(skv_list+1, i){if tcp_receive(skv_var, 4){ds_list_replace(skv_list+1, i, read_uint(skv_var))}}
        if ds_list_find_value(skv_list+1, i)
        {
            if tcp_receive(skv_var, ds_list_find_value(skv_list+1, i))
            {
                skv_byte=read_uint(skv_var)
                skv_msize=ds_list_find_value(skv_list+1, i)
                switch(skv_byte)
                {
                    case 0:
                        write_ubyte(skv_saved_buffer, 1)
                        write_uint(skv_saved_buffer, skv_msize-10)
                        write_buffer_part(skv_saved_buffer, skv_var, skv_msize)
                        for(j=0; j<i; j+=1)
                        {
                            buffer_set_readpos(skv_var, 4)
                            write_uint(ds_list_find_value(skv_list, j), skv_msize-4)
                            write_buffer_part(ds_list_find_value(skv_list, j), skv_var, skv_msize)
                            socket_send(ds_list_find_value(skv_list, j))
                        }
                        for(j=i+1; j<skv_server_size; j+=1)
                        {
                            buffer_set_readpos(skv_var, 4)
                            write_uint(ds_list_find_value(skv_list, j), skv_msize-4)
                            write_buffer_part(ds_list_find_value(skv_list, j), skv_var, skv_msize)
                            socket_send(ds_list_find_value(skv_list, j))
                        }
                        break
                    case 1:
                        for(j=0; j<i; j+=1)
                        {
                            buffer_set_readpos(skv_var, 4)
                            write_uint(ds_list_find_value(skv_list, j), skv_msize-4)
                            write_buffer_part(ds_list_find_value(skv_list, j), skv_var, skv_msize)
                            socket_send(ds_list_find_value(skv_list, j))
                        }
                        for(j=i+1; j<skv_server_size; j+=1)
                        {
                            buffer_set_readpos(skv_var, 4)
                            write_uint(ds_list_find_value(skv_list, j), skv_msize-4)
                            write_buffer_part(ds_list_find_value(skv_list, j), skv_var, skv_msize)
                            socket_send(ds_list_find_value(skv_list, j))
                        }
                        break
                    default:
                        if skv_byte!=2
                        {
                            skv_byte-=2
                            write_uint(skv_byte, skv_msize-4)
                            write_buffer_part(skv_byte, skv_var, skv_msize)
                            socket_send(skv_byte)
                        }
                        else
                        {
                            write_ubyte(skv_saved_buffer, 1)
                            write_uint(skv_saved_buffer, skv_msize-10)
                            write_buffer_part(skv_saved_buffer, skv_var, skv_msize)
                        }
                }
                ds_list_replace(skv_list+1, i, 0)
                i-=1
                continue
            }
        }
    }
    
    while(buffer_bytes_left(skv_saved_buffer))
    {
        if !global._fn_message_break_
        {
            if read_ubyte(skv_saved_buffer)
            {
                buffer_clear(fnv_message)
                skv_byte=read_uint(skv_saved_buffer)
                global._fn_message_sent_player_=read_uint(skv_saved_buffer)
                global._fn_message_id_=read_ushort(skv_saved_buffer)
                write_buffer_part(fnv_message, skv_saved_buffer, skv_byte)
                event_user(cfn_message_event)
            }
            else
            {
                i=read_uint(skv_saved_buffer)
                ds_list_delete(skv_list, i)
                ds_list_delete(skv_list+1, i)
                global._fn_message_sent_player_=read_uint(skv_saved_buffer)
                socket_destroy(global._fn_message_sent_player_)
                global._fn_message_id_=-1
                global._fn_socket_error_str_=cfn_error_text_2
                event_user(cfn_player_exit_event)
            }
        }
        else{break}
    }
    if !global._fn_message_break_{buffer_clear(skv_saved_buffer)}else{global._fn_message_break_=0}
}
else
{
    var skv_socket, skv_saved_buffer, skv_byte;
    skv_socket=ds_list_find_value(argument0, 0)
    skv_saved_buffer=ds_list_find_value(argument0, 3)
    while(1)
    {
        if !skv_socket{break}
        if tcp_eof(skv_socket){write_ubyte(skv_saved_buffer, 0); write_string_v2(skv_saved_buffer, socket_error(skv_socket)); socket_destroy(skv_socket); ds_list_replace(argument0, 0, 0); break}
        if !ds_list_find_value(argument0, 2){if tcp_receive(skv_socket, 4){ds_list_replace(argument0, 2, read_uint(skv_socket))}}
        if ds_list_find_value(argument0, 2)
        {
            if tcp_receive(skv_socket, ds_list_find_value(argument0, 2))
            {
                write_ubyte(skv_saved_buffer, 1)
                write_uint(skv_saved_buffer, ds_list_find_value(argument0, 2)-6)
                write_buffer(skv_saved_buffer, skv_socket)
                ds_list_replace(argument0, 2, 0)
                continue
            }
        }
        break
    }
    
    while(buffer_bytes_left(skv_saved_buffer))
    {
        if !global._fn_message_break_
        {
            if read_ubyte(skv_saved_buffer)
            {
                buffer_clear(fnv_message)
                skv_byte=read_uint(skv_saved_buffer)
                global._fn_message_sent_player_=read_uint(skv_saved_buffer)
                global._fn_message_id_=read_ushort(skv_saved_buffer)
                write_buffer_part(fnv_message, skv_saved_buffer, skv_byte)
                event_user(cfn_message_event)
            }
            else
            {
                global._fn_socket_error_str_=read_string_v2(skv_saved_buffer)
                event_user(cfn_server_error_event)
            }
        }
        else{break}
    }
    if !global._fn_message_break_{buffer_clear(skv_saved_buffer)}else{global._fn_message_break_=0}
}

if global._fn_message_skip_
{
    write_buffer(skv_saved_buffer, global._fn_skip_buffer_)
    buffer_clear(global._fn_skip_buffer_)
    global._fn_message_skip_=0
}
