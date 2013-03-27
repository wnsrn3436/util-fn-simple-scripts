global._fn_message_skip_=1
write_uint(global._fn_skip_buffer_, buffer_size(fnv_message))
write_uint(global._fn_skip_buffer_, global._fn_message_sent_player_)
write_ushort(global._fn_skip_buffer_, global._fn_message_id_)
write_buffer(global._fn_skip_buffer_, fnv_message)
