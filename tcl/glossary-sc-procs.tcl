ad_library { 
    Implements OpenFTS Search service contracts
    poached from static-pages and notes.

    @author Don Baccus (dhoghaza@pacifier.com)
    @cvs-id $Id$
}

ad_proc glossary__datasource {
    object_id
} {
    @author Don Baccus (dhogaza@pacifier.com)
} {

    set path_stub [cr_fs_path STATIC_PAGES]
    
    db_0or1row datasource "" -column_array datasource

    return [array get datasource]
}


ad_proc notes__url {
    object_id
} {
    @author Don Baccus (dhogaza@pacifier.com)
} {

    set package_id [apm_package_id_from_key glossary]

    db_1row get_url_stub ""

    set url "${url_stub}term?item_id=$object_id"

    return $url
}
