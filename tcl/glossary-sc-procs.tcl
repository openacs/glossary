# static-pages/tcl/glossary-sc-procs.tcl
# implements OpenFTS Search service contracts
# Don Baccus dhoghaza@pacifier.com
# poached from static-pages and notes

ad_proc glossary__datasource {
    object_id
} {
    @author Don Baccus
} {

    set path_stub [cr_fs_path STATIC_PAGES]
    
    db_0or1row datasource ""     -column_array datasource

    return [array get datasource]
}


ad_proc notes__url {
    object_id
} {
    @author Don Baccus
} {

    set package_id [apm_package_id_from_key glossary]

    db_1row get_url_stub ""

    set url "${url_stub}term?item_id=$object_id"

    return $url
}
