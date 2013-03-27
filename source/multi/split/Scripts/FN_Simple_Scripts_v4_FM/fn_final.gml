var skv_count;
skv_count=ds_list_size(global._fn_handle_list_)
repeat(skv_count){fn_handle_destroy(ds_list_find_value(global._fn_handle_list_, 0))}
buffer_destroy(fnv_send)
buffer_destroy(fnv_message)
ds_list_destroy(global._fn_handle_list_)
buffer_destroy(global._fn_temp_buffer_)
buffer_destroy(global._fn_skip_buffer_)
