if ds_list_find_value(argument0, 1)
{
    var skv_socket;
    switch(argument2)
    {
        case -5:
            skv_socket=ds_list_find_value(argument0, 0)
            write_uint(skv_socket, 14+buffer_size(fnv_send))
            write_uint(skv_socket, 0)
            write_ushort(skv_socket, argument1+3)
            write_ushort(skv_socket, ds_list_find_value(argument0, 4))
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument3)
            write_buffer(skv_socket, fnv_send)
            socket_send(skv_socket)
            break
        case -4:
            skv_socket=ds_list_find_value(argument0, 0)
            write_uint(skv_socket, 14+buffer_size(fnv_send))
            write_uint(skv_socket, 1)
            write_ushort(skv_socket, argument1+3)
            write_ushort(skv_socket, ds_list_find_value(argument0, 4))
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument3)
            write_buffer(skv_socket, fnv_send)
            socket_send(skv_socket)
            break
        case -3:
            skv_socket=ds_list_find_value(argument0, 0)
            write_uint(skv_socket, 14+buffer_size(fnv_send))
            write_uint(skv_socket, 1)
            write_ushort(skv_socket, argument1+3)
            write_ushort(skv_socket, ds_list_find_value(argument0, 4))
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument3)
            write_buffer(skv_socket, fnv_send)
            socket_send(skv_socket)
            if argument1<-1 or ds_list_find_value(argument0, 4)=argument1
            {
                skv_socket=ds_list_find_value(argument0, 3)
                write_ubyte(skv_socket, 1)
                write_uint(skv_socket, buffer_size(fnv_send))
                write_ushort(skv_socket, argument1+3)
                write_ushort(skv_socket, ds_list_find_value(argument0, 4))
                write_uint(skv_socket, ds_list_find_value(argument0, 1))
                write_ushort(skv_socket, argument3)
                write_buffer(skv_socket, fnv_send)
            }
            break
        case -2:
            skv_socket=ds_list_find_value(argument0, 0)
            write_uint(skv_socket, 14+buffer_size(fnv_send))
            write_uint(skv_socket, 0)
            write_ushort(skv_socket, argument1+3)
            write_ushort(skv_socket, ds_list_find_value(argument0, 4))
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument3)
            write_buffer(skv_socket, fnv_send)
            socket_send(skv_socket)
            break
        case -1:
            skv_socket=ds_list_find_value(argument0, 0)
            write_uint(skv_socket, 14+buffer_size(fnv_send))
            write_uint(skv_socket, 0)
            write_ushort(skv_socket, argument1+3)
            write_ushort(skv_socket, ds_list_find_value(argument0, 4))
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument3)
            write_buffer(skv_socket, fnv_send)
            socket_send(skv_socket)
            if argument1<-1 or ds_list_find_value(argument0, 4)=argument1
            {
                skv_socket=ds_list_find_value(argument0, 3)
                write_ubyte(skv_socket, 1)
                write_uint(skv_socket, buffer_size(fnv_send))
                write_ushort(skv_socket, argument1+3)
                write_ushort(skv_socket, ds_list_find_value(argument0, 4))
                write_uint(skv_socket, ds_list_find_value(argument0, 1))
                write_ushort(skv_socket, argument3)
                write_buffer(skv_socket, fnv_send)
            }
            break
        default:
            if ds_list_find_value(argument0, 1)!=argument2
            {
                skv_socket=ds_list_find_value(argument0, 0)
                write_uint(skv_socket, 14+buffer_size(fnv_send))
                write_uint(skv_socket, argument2+3)
                write_ushort(skv_socket, argument1+3)
                write_ushort(skv_socket, ds_list_find_value(argument0, 4))
                write_uint(skv_socket, ds_list_find_value(argument0, 1))
                write_ushort(skv_socket, argument3)
                write_buffer(skv_socket, fnv_send)
                socket_send(skv_socket)
            }
            else
            {
                if argument1<-1 or ds_list_find_value(argument0, 4)=argument1
                {
                    skv_socket=ds_list_find_value(argument0, 3)
                    write_ubyte(skv_socket, 1)
                    write_uint(skv_socket, buffer_size(fnv_send))
                    write_ushort(skv_socket, argument1+3)
                    write_ushort(skv_socket, ds_list_find_value(argument0, 4))
                    write_uint(skv_socket, ds_list_find_value(argument0, 1))
                    write_ushort(skv_socket, argument3)
                    write_buffer(skv_socket, fnv_send)
                }
            }
    }
}
else
{
    buffer_clear(global._fn_temp_buffer_)
    write_ushort(global._fn_temp_buffer_, argument1+3)
    write_ushort(global._fn_temp_buffer_, ds_list_find_value(argument0, 4))
    write_uint(global._fn_temp_buffer_, 0)
    write_ushort(global._fn_temp_buffer_, argument3)
    write_buffer(global._fn_temp_buffer_, fnv_send)
    if argument2<0
    {
        switch(argument1)
        {
            case -3:
                var i, skv_list, skv_byte, skv_soket, skv_size;
                skv_list=ds_list_find_value(argument0, ds_list_find_value(argument0, 4)+8)
                skv_byte=ds_list_size(skv_list)
                skv_size=buffer_size(global._fn_temp_buffer_)
                for(i=0; i!=skv_byte; i+=1)
                {
                    skv_soket=ds_list_find_value(skv_list, i)
                    write_uint(skv_soket, skv_size)
                    write_buffer(skv_soket, global._fn_temp_buffer_)
                    socket_send(skv_soket)
                }
                break
            case -2:
                var i, j, skv_list, skv_byte, skv_byte2, skv_soket, skv_size;
                skv_byte=ds_list_size(argument0)
                skv_size=buffer_size(global._fn_temp_buffer_)
                for(i=8; i<skv_byte; i+=1)
                {
                    skv_list=ds_list_find_value(argument0, i)
                    skv_byte2=ds_list_size(skv_list)
                    for(j=0; j!=skv_byte2; j+=1)
                    {
                        skv_soket=ds_list_find_value(skv_list, j)
                        write_uint(skv_soket, skv_size)
                        write_buffer(skv_soket, global._fn_temp_buffer_)
                        socket_send(skv_soket)
                    }
                }
                break
            case -1:
                var i, j, skv_list, skv_byte, skv_byte2, skv_soket, skv_size;
                skv_byte=ds_list_find_value(argument0, 4)+8
                skv_size=buffer_size(global._fn_temp_buffer_)
                for(i=8; i<skv_byte; i+=1)
                {
                    skv_list=ds_list_find_value(argument0, i)
                    skv_byte2=ds_list_size(skv_list)
                    for(j=0; j!=skv_byte2; j+=1)
                    {
                        skv_soket=ds_list_find_value(skv_list, j)
                        write_uint(skv_soket, skv_size)
                        write_buffer(skv_soket, global._fn_temp_buffer_)
                        socket_send(skv_soket)
                    }
                }
                skv_byte2=ds_list_size(argument0)
                for(i=skv_byte+1; i<skv_byte2; i+=1)
                {
                    skv_list=ds_list_find_value(argument0, i)
                    skv_byte=ds_list_size(skv_list)
                    for(j=0; j!=skv_byte; j+=1)
                    {
                        skv_soket=ds_list_find_value(skv_list, j)
                        write_uint(skv_soket, skv_size)
                        write_buffer(skv_soket, global._fn_temp_buffer_)
                        socket_send(skv_soket)
                    }
                }
                break
            default:
                var i, skv_list, skv_byte, skv_soket, skv_size;
                skv_list=ds_list_find_value(argument0, argument1+8)
                skv_byte=ds_list_size(skv_list)
                skv_size=buffer_size(global._fn_temp_buffer_)
                for(i=0; i!=skv_byte; i+=1)
                {
                    skv_soket=ds_list_find_value(skv_list, i)
                    write_uint(skv_soket, skv_size)
                    write_buffer(skv_soket, global._fn_temp_buffer_)
                    socket_send(skv_soket)
                }
        }
        if argument2>-4
        {
            if argument1<-1 or ds_list_find_value(argument0, 4)=argument1
            {
                write_ubyte(ds_list_find_value(argument0, 3), 1)
                write_uint(ds_list_find_value(argument0, 3), skv_size-10)
                write_buffer(ds_list_find_value(argument0, 3), global._fn_temp_buffer_)
            }
        }
    }
    else
    {
        if argument2
        {
            switch(argument1)
            {
                case -3:
                    if ds_list_find_index(ds_list_find_value(argument0, ds_list_find_value(argument0, 4)+8), argument2)!=-1
                    {
                        write_uint(argument2, buffer_size(global._fn_temp_buffer_))
                        write_buffer(argument2, global._fn_temp_buffer_)
                        socket_send(argument2)
                    }
                    break
                case -2:
                    write_uint(argument2, buffer_size(global._fn_temp_buffer_))
                    write_buffer(argument2, global._fn_temp_buffer_)
                    socket_send(argument2)
                    break
                case -1:
                    if ds_list_find_index(ds_list_find_value(argument0, ds_list_find_value(argument0, 4)+8), argument2)=-1
                    {
                        write_uint(argument2, buffer_size(global._fn_temp_buffer_))
                        write_buffer(argument2, global._fn_temp_buffer_)
                        socket_send(argument2)
                    }
                    break
                default:
                    if ds_list_find_index(ds_list_find_value(argument0, argument1+8), argument2)!=-1
                    {
                        write_uint(argument2, buffer_size(global._fn_temp_buffer_))
                        write_buffer(argument2, global._fn_temp_buffer_)
                        socket_send(argument2)
                    }
            }
        }
        else
        {
            if argument1<-1 or ds_list_find_value(argument0, 4)=argument1
            {
                write_ubyte(ds_list_find_value(argument0, 3), 1)
                write_uint(ds_list_find_value(argument0, 3), buffer_size(fnv_send))
                write_buffer(ds_list_find_value(argument0, 3), global._fn_temp_buffer_)
            }
        }
    }
}
