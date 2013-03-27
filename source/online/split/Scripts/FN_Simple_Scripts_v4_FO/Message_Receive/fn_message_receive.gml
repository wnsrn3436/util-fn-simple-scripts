global._fn_received_handle_=argument0
if !ds_list_find_value(argument0, 1)
{
    var i, j, k, l, skv_socket, skv_saved_buffer, skv_list, skv_server_size, skv_server_size2, skv_var, skv_byte, skv_pos, skv_msize, skv_size;
    
    skv_socket=ds_list_find_value(argument0, 0)
    skv_saved_buffer=ds_list_find_value(argument0, 3)
    skv_list=ds_list_find_value(argument0, 6)
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
                    global._fn_message_sent_space_=read_ushort(skv_var)
                    skv_byte=ds_list_find_value(argument0, global._fn_message_sent_space_+8)
                    ds_list_add(skv_byte, skv_var)
                    ds_list_add(skv_byte+1, 0)
                    write_uint(skv_var, skv_var)
                    socket_send(skv_var)
                    ds_list_replace(argument0, 7, ds_list_find_value(argument0, 7)+1)
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
        if ds_list_find_value(argument0, 5)=-1 or ds_list_find_value(argument0, 5)>ds_list_size(skv_list)+ds_list_find_value(argument0, 7)
        {
            socket_sendbuffer_limit(skv_byte, ds_list_find_value(argument0, 2))
            ds_list_add(skv_list, skv_byte)
            ds_list_add(skv_list+1, 0)
        }
        else
        {
            if !ds_list_find_value(argument0, 5){write_uint(skv_byte, 1)}else{write_uint(skv_byte, 0)}
            socket_send(skv_byte)
            socket_destroy(skv_byte)
        }
        skv_byte=socket_accept(skv_socket)
    }
    
    skv_server_size=ds_list_size(argument0)
    for(i=8; i<skv_server_size; i+=1)
    {
        skv_list=ds_list_find_value(argument0, i)
        skv_server_size2=ds_list_size(skv_list)
        for(j=0; j!=skv_server_size2; j+=1)
        {
            skv_var=ds_list_find_value(skv_list, j)
            if !skv_var{continue}
            if tcp_eof(skv_var)
            {
                write_ubyte(skv_saved_buffer, 0)
                write_ushort(skv_saved_buffer, i)
                write_uint(skv_saved_buffer, j)
                write_uint(skv_saved_buffer, skv_var)
                ds_list_replace(skv_list, j, 0)
                continue
            }
            if !ds_list_find_value(skv_list+1, j){if tcp_receive(skv_var, 4){ds_list_replace(skv_list+1, j, read_uint(skv_var))}}
            if ds_list_find_value(skv_list+1, j)
            {
                if tcp_receive(skv_var, ds_list_find_value(skv_list+1, j))
                {
                    skv_byte=read_uint(skv_var)
                    skv_pos=read_ushort(skv_var)
                    skv_msize=ds_list_find_value(skv_list+1, j)
                    switch(skv_byte)
                    {
                        case 0:
                            buffer_set_readpos(skv_var, 4)
                            write_ubyte(skv_saved_buffer, 1)
                            write_uint(skv_saved_buffer, skv_msize-14)
                            write_buffer_part(skv_saved_buffer, skv_var, skv_msize)
                            switch(skv_pos)
                            {
                                case 0:
                                    for(k=0; k<j; k+=1)
                                    {
                                        buffer_set_readpos(skv_var, 4)
                                        write_uint(ds_list_find_value(skv_list, k), skv_msize-4)
                                        write_buffer_part(ds_list_find_value(skv_list, k), skv_var, skv_msize)
                                        socket_send(ds_list_find_value(skv_list, k))
                                    }
                                    for(k=j+1; k<skv_server_size2; k+=1)
                                    {
                                        buffer_set_readpos(skv_var, 4)
                                        write_uint(ds_list_find_value(skv_list, k), skv_msize-4)
                                        write_buffer_part(ds_list_find_value(skv_list, k), skv_var, skv_msize)
                                        socket_send(ds_list_find_value(skv_list, k))
                                    }
                                    break
                                case 1:
                                    for(k=8; k<i; k+=1)
                                    {
                                        skv_byte=ds_list_find_value(argument0, k)
                                        skv_size=ds_list_size(skv_byte)
                                        for(l=0; l!=skv_size; l+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, l), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, l), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, l))
                                        }
                                    }
                                    for(k=i+1; k<skv_server_size; k+=1)
                                    {
                                        skv_byte=ds_list_find_value(argument0, k)
                                        skv_size=ds_list_size(skv_byte)
                                        for(l=0; l!=skv_size; l+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, l), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, l), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, l))
                                        }
                                    }
                                    for(k=0; k<j; k+=1)
                                    {
                                        buffer_set_readpos(skv_var, 4)
                                        write_uint(ds_list_find_value(skv_list, k), skv_msize-4)
                                        write_buffer_part(ds_list_find_value(skv_list, k), skv_var, skv_msize)
                                        socket_send(ds_list_find_value(skv_list, k))
                                    }
                                    for(k=j+1; k<skv_server_size2; k+=1)
                                    {
                                        buffer_set_readpos(skv_var, 4)
                                        write_uint(ds_list_find_value(skv_list, k), skv_msize-4)
                                        write_buffer_part(ds_list_find_value(skv_list, k), skv_var, skv_msize)
                                        socket_send(ds_list_find_value(skv_list, k))
                                    }
                                    break
                                case 2:
                                    for(k=8; k<i; k+=1)
                                    {
                                        skv_byte=ds_list_find_value(argument0, k)
                                        skv_size=ds_list_size(skv_byte)
                                        for(l=0; l!=skv_size; l+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, l), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, l), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, l))
                                        }
                                    }
                                    for(k=i+1; k<skv_server_size; k+=1)
                                    {
                                        skv_byte=ds_list_find_value(argument0, k)
                                        skv_size=ds_list_size(skv_byte)
                                        for(l=0; l!=skv_size; l+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, l), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, l), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, l))
                                        }
                                    }
                                    break
                                default:
                                    skv_byte=ds_list_find_value(argument0, skv_pos+5)
                                    if skv_byte!=skv_list
                                    {
                                        skv_size=ds_list_size(skv_byte)
                                        for(k=0; k<skv_size; k+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, k), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, k), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, k))
                                        }
                                    }
                                    else
                                    {
                                        for(k=0; k<j; k+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, k), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, k), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, k))
                                        }
                                        for(k=j+1; k<skv_server_size2; k+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, k), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, k), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, k))
                                        }
                                    }
                            }
                            ds_list_replace(skv_list+1, j, 0)
                            j-=1
                            break
                        case 1:
                            switch(skv_pos)
                            {
                                case 0:
                                    for(k=0; k<j; k+=1)
                                    {
                                        buffer_set_readpos(skv_var, 4)
                                        write_uint(ds_list_find_value(skv_list, k), skv_msize-4)
                                        write_buffer_part(ds_list_find_value(skv_list, k), skv_var, skv_msize)
                                        socket_send(ds_list_find_value(skv_list, k))
                                    }
                                    for(k=j+1; k<skv_server_size2; k+=1)
                                    {
                                        buffer_set_readpos(skv_var, 4)
                                        write_uint(ds_list_find_value(skv_list, k), skv_msize-4)
                                        write_buffer_part(ds_list_find_value(skv_list, k), skv_var, skv_msize)
                                        socket_send(ds_list_find_value(skv_list, k))
                                    }
                                    break
                                case 1:
                                    for(k=8; k<i; k+=1)
                                    {
                                        skv_byte=ds_list_find_value(argument0, k)
                                        skv_size=ds_list_size(skv_byte)
                                        for(l=0; l!=skv_size; l+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, l), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, l), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, l))
                                        }
                                    }
                                    for(k=i+1; k<skv_server_size; k+=1)
                                    {
                                        skv_byte=ds_list_find_value(argument0, k)
                                        skv_size=ds_list_size(skv_byte)
                                        for(l=0; l!=skv_size; l+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, l), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, l), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, l))
                                        }
                                    }
                                    for(k=0; k<j; k+=1)
                                    {
                                        buffer_set_readpos(skv_var, 4)
                                        write_uint(ds_list_find_value(skv_list, k), skv_msize-4)
                                        write_buffer_part(ds_list_find_value(skv_list, k), skv_var, skv_msize)
                                        socket_send(ds_list_find_value(skv_list, k))
                                    }
                                    for(k=j+1; k<skv_server_size2; k+=1)
                                    {
                                        buffer_set_readpos(skv_var, 4)
                                        write_uint(ds_list_find_value(skv_list, k), skv_msize-4)
                                        write_buffer_part(ds_list_find_value(skv_list, k), skv_var, skv_msize)
                                        socket_send(ds_list_find_value(skv_list, k))
                                    }
                                    break
                                case 2:
                                    for(k=8; k<i; k+=1)
                                    {
                                        skv_byte=ds_list_find_value(argument0, k)
                                        skv_size=ds_list_size(skv_byte)
                                        for(l=0; l!=skv_size; l+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, l), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, l), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, l))
                                        }
                                    }
                                    for(k=i+1; k<skv_server_size; k+=1)
                                    {
                                        skv_byte=ds_list_find_value(argument0, k)
                                        skv_size=ds_list_size(skv_byte)
                                        for(l=0; l!=skv_size; l+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, l), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, l), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, l))
                                        }
                                    }
                                    break
                                default:
                                    skv_byte=ds_list_find_value(argument0, skv_pos+5)
                                    if skv_byte!=skv_list
                                    {
                                        skv_size=ds_list_size(skv_byte)
                                        for(k=0; k<skv_size; k+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, k), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, k), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, k))
                                        }
                                    }
                                    else
                                    {
                                        for(k=0; k<j; k+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, k), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, k), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, k))
                                        }
                                        for(k=j+1; k<skv_server_size2; k+=1)
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(ds_list_find_value(skv_byte, k), skv_msize-4)
                                            write_buffer_part(ds_list_find_value(skv_byte, k), skv_var, skv_msize)
                                            socket_send(ds_list_find_value(skv_byte, k))
                                        }
                                    }
                            }
                            ds_list_replace(skv_list+1, j, 0)
                            j-=1
                            break
                        case 2:
                            write_ubyte(skv_saved_buffer, 2)
                            write_ushort(skv_saved_buffer, i)
                            write_uint(skv_saved_buffer, skv_var)
                            write_uint(skv_saved_buffer, j)
                            write_ushort(skv_saved_buffer, skv_pos)
                            write_uint(skv_saved_buffer, skv_msize-6)
                            write_buffer_part(skv_saved_buffer, skv_var, skv_msize)
                            ds_list_replace(skv_list, j, 0)
                            break
                        default:
                            if skv_byte!=3
                            {
                                skv_byte-=3
                                switch(skv_pos)
                                {
                                    case 0:
                                        if ds_list_find_index(skv_list, skv_byte)!=-1
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(skv_byte, skv_msize-4)
                                            write_buffer_part(skv_byte, skv_var, skv_msize)
                                            socket_send(skv_byte)
                                        }
                                        break
                                    case 1:
                                        buffer_set_readpos(skv_var, 4)
                                        write_uint(skv_byte, skv_msize-4)
                                        write_buffer_part(skv_byte, skv_var, skv_msize)
                                        socket_send(skv_byte)
                                        break
                                    case 2:
                                        if ds_list_find_index(skv_list, skv_byte)=-1
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(skv_byte, skv_msize-4)
                                            write_buffer_part(skv_byte, skv_var, skv_msize)
                                            socket_send(skv_byte)
                                        }
                                        break
                                    default:
                                        if ds_list_find_index(ds_list_find_value(argument0, skv_pos+5), skv_byte)!=-1
                                        {
                                            buffer_set_readpos(skv_var, 4)
                                            write_uint(skv_byte, skv_msize-4)
                                            write_buffer_part(skv_byte, skv_var, skv_msize)
                                            socket_send(skv_byte)
                                        }
                                }
                            }
                            else
                            {
                                buffer_set_readpos(skv_var, 4)
                                write_ubyte(skv_saved_buffer, 1)
                                write_uint(skv_saved_buffer, skv_msize-14)
                                write_buffer_part(skv_saved_buffer, skv_var, skv_msize)
                            }
                            ds_list_replace(skv_list+1, j, 0)
                            j-=1
                    }
                }
            }
        }
    }
    
    skv_byte=ds_list_find_value(argument0, 4)
    while(buffer_bytes_left(skv_saved_buffer))
    {
        if !global._fn_message_break_
        {
            switch(read_ubyte(skv_saved_buffer))
            {
                case 1:
                    buffer_clear(fnv_message)
                    skv_pos=read_uint(skv_saved_buffer)
                    global._fn_message_read_space_=read_ushort(skv_saved_buffer)-3
                    global._fn_message_sent_space_=read_ushort(skv_saved_buffer)
                    if (global._fn_message_read_space_<0 and (global._fn_message_read_space_=-2 or (global._fn_message_read_space_=-3 and global._fn_message_sent_space_=skv_byte) or (global._fn_message_read_space_=-1 and global._fn_message_sent_space_!=skv_byte))) or skv_byte=global._fn_message_read_space_
                    {
                        global._fn_message_sent_player_=read_uint(skv_saved_buffer)
                        global._fn_message_id_=read_ushort(skv_saved_buffer)
                        write_buffer_part(fnv_message, skv_saved_buffer, skv_pos)
                        event_user(cfn_message_event)
                    }
                    else{buffer_set_readpos(skv_saved_buffer, buffer_size(skv_saved_buffer)-buffer_bytes_left(skv_saved_buffer)+skv_pos+6)}
                    break
                case 2:
                    i=read_ushort(skv_saved_buffer)
                    global._fn_message_sent_player_=read_uint(skv_saved_buffer)
                    j=read_uint(skv_saved_buffer)
                    global._fn_message_sent_space_=i-8
                    global._fn_message_id_=read_ushort(skv_saved_buffer)
                    skv_pos=ds_list_find_value(argument0, global._fn_message_id_+8)
                    ds_list_add(skv_pos, global._fn_message_sent_player_)
                    ds_list_add(skv_pos+1, 0)
                    ds_list_delete(ds_list_find_value(argument0, i), j)
                    ds_list_delete(ds_list_find_value(argument0, i)+1, j)
                    write_uint(global._fn_message_sent_player_, 0)
                    socket_send(global._fn_message_sent_player_)
                    buffer_clear(fnv_message)
                    write_buffer_part(fnv_message, skv_saved_buffer, read_uint(skv_saved_buffer))
                    event_user(cfn_space_changed_event)
                    break
                default:
                    i=read_ushort(skv_saved_buffer)
                    j=read_uint(skv_saved_buffer)
                    ds_list_delete(ds_list_find_value(argument0, i), j)
                    ds_list_delete(ds_list_find_value(argument0, i)+1, j)
                    ds_list_replace(argument0, 7, ds_list_find_value(argument0, 7)-1)
                    global._fn_message_sent_space_=i-8
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
    var skv_socket, skv_saved_buffer, skv_pos, skv_byte;
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
                write_uint(skv_saved_buffer, ds_list_find_value(argument0, 2)-10)
                write_buffer(skv_saved_buffer, skv_socket)
                ds_list_replace(argument0, 2, 0)
                continue
            }
        }
        break
    }
    
    skv_byte=ds_list_find_value(argument0, 4)
    while(buffer_bytes_left(skv_saved_buffer))
    {
        if !global._fn_message_break_
        {
            if read_ubyte(skv_saved_buffer)
            {
                buffer_clear(fnv_message)
                skv_pos=read_uint(skv_saved_buffer)
                global._fn_message_read_space_=read_ushort(skv_saved_buffer)-3
                global._fn_message_sent_space_=read_ushort(skv_saved_buffer)
                if (global._fn_message_read_space_<0 and (global._fn_message_read_space_=-2 or (global._fn_message_read_space_=-3 and global._fn_message_sent_space_=skv_byte) or (global._fn_message_read_space_=-1 and global._fn_message_sent_space_!=skv_byte))) or skv_byte=global._fn_message_read_space_
                {
                    global._fn_message_sent_player_=read_uint(skv_saved_buffer)
                    global._fn_message_id_=read_ushort(skv_saved_buffer)
                    write_buffer_part(fnv_message, skv_saved_buffer, skv_pos)
                    event_user(cfn_message_event)
                }
                else{buffer_set_readpos(skv_saved_buffer, buffer_size(skv_saved_buffer)-buffer_bytes_left(skv_saved_buffer)+skv_pos+6)}
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
