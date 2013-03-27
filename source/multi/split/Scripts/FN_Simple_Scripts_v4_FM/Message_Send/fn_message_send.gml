if ds_list_find_value(argument0, 1)
{
    var skv_socket;
    switch(argument1)
    {
        case -5:
            skv_socket=ds_list_find_value(argument0, 0)
            write_uint(skv_socket, 10+buffer_size(fnv_send))
            write_uint(skv_socket, 0)
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument2)
            write_buffer(skv_socket, fnv_send)
            socket_send(skv_socket)
            break
        case -4:
            skv_socket=ds_list_find_value(argument0, 0)
            write_uint(skv_socket, 10+buffer_size(fnv_send))
            write_uint(skv_socket, 1)
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument2)
            write_buffer(skv_socket, fnv_send)
            socket_send(skv_socket)
            break
        case -3:
            skv_socket=ds_list_find_value(argument0, 0)
            write_uint(skv_socket, 10+buffer_size(fnv_send))
            write_uint(skv_socket, 1)
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument2)
            write_buffer(skv_socket, fnv_send)
            socket_send(skv_socket)
            skv_socket=ds_list_find_value(argument0, 3)
            write_ubyte(skv_socket, 1)
            write_uint(skv_socket, buffer_size(fnv_send))
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument2)
            write_buffer(skv_socket, fnv_send)
            break
        case -2:
            skv_socket=ds_list_find_value(argument0, 0)
            write_uint(skv_socket, 10+buffer_size(fnv_send))
            write_uint(skv_socket, 0)
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument2)
            write_buffer(skv_socket, fnv_send)
            socket_send(skv_socket)
            break
        case -1:
            skv_socket=ds_list_find_value(argument0, 0)
            write_uint(skv_socket, 10+buffer_size(fnv_send))
            write_uint(skv_socket, 0)
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument2)
            write_buffer(skv_socket, fnv_send)
            socket_send(skv_socket)
            skv_socket=ds_list_find_value(argument0, 3)
            write_ubyte(skv_socket, 1)
            write_uint(skv_socket, buffer_size(fnv_send))
            write_uint(skv_socket, ds_list_find_value(argument0, 1))
            write_ushort(skv_socket, argument2)
            write_buffer(skv_socket, fnv_send)
            break
        default:
            if ds_list_find_value(argument0, 1)!=argument1
            {
                skv_socket=ds_list_find_value(argument0, 0)
                write_uint(skv_socket, 10+buffer_size(fnv_send))
                write_uint(skv_socket, argument1+2)
                write_uint(skv_socket, ds_list_find_value(argument0, 1))
                write_ushort(skv_socket, argument2)
                write_buffer(skv_socket, fnv_send)
                socket_send(skv_socket)
            }
            else
            {
                skv_socket=ds_list_find_value(argument0, 3)
                write_ubyte(skv_socket, 1)
                write_uint(skv_socket, buffer_size(fnv_send))
                write_uint(skv_socket, ds_list_find_value(argument0, 1))
                write_ushort(skv_socket, argument2)
                write_buffer(skv_socket, fnv_send)
            }
    }
}
else
{
    buffer_clear(global._fn_temp_buffer_)
    write_uint(global._fn_temp_buffer_, 0)
    write_ushort(global._fn_temp_buffer_, argument2)
    write_buffer(global._fn_temp_buffer_, fnv_send)
    if argument1<0
    {
        var i, skv_list, skv_byte, skv_socket, skv_size;
        skv_list=ds_list_find_value(argument0, 6)
        skv_byte=ds_list_size(skv_list)
        skv_size=buffer_size(global._fn_temp_buffer_)
        for(i=0; i!=skv_byte; i+=1)
        {
            skv_soket=ds_list_find_value(skv_list, i)
            write_uint(skv_soket, skv_size)
            write_buffer(skv_soket, global._fn_temp_buffer_)
            socket_send(skv_soket)
        }
        if argument1>-4
        {
            write_ubyte(ds_list_find_value(argument0, 3), 1)
            write_uint(ds_list_find_value(argument0, 3), skv_size-6)
            write_buffer(ds_list_find_value(argument0, 3), global._fn_temp_buffer_)
        }
    }
    else
    {
        if argument1
        {
            write_uint(argument1, buffer_size(global._fn_temp_buffer_))
            write_buffer(argument1, global._fn_temp_buffer_)
            socket_send(argument1)
        }
        else
        {
            write_ubyte(ds_list_find_value(argument0, 3), 1)
            write_uint(ds_list_find_value(argument0, 3), buffer_size(fnv_send))
            write_buffer(ds_list_find_value(argument0, 3), global._fn_temp_buffer_)
        }
    }
}
