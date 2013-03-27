if !ds_list_find_value(argument0, 1)
{
    var i, j, skv_list, skv_size, skv_size2;
    
    skv_list=ds_list_find_value(argument0, 6)
    skv_size=ds_list_size(skv_list)
    for(i=0; i!=skv_size; i+=1){socket_destroy(ds_list_find_value(skv_list, i))}
    ds_list_destroy(skv_list)
    ds_list_destroy(skv_list+1)
    //temp_player_free
    
    skv_size=ds_list_size(argument0)
    for(i=8; i<skv_size; i+=1)
    {
        skv_list=ds_list_find_value(argument0, i)
        skv_size2=ds_list_size(skv_list)
        for(j=0; j!=skv_size2; j+=1){socket_destroy(ds_list_find_value(skv_list, j))}
        ds_list_destroy(skv_list)
        ds_list_destroy(skv_list+1)
    }
    //player_free
}
if ds_list_find_value(argument0, 0){socket_destroy(ds_list_find_value(argument0, 0))}
buffer_destroy(ds_list_find_value(argument0, 3))
ds_list_destroy(argument0)
if ds_list_find_index(global._fn_handle_list_, argument0)!=-1{ds_list_delete(global._fn_handle_list_, ds_list_find_index(global._fn_handle_list_, argument0))}
