# glossary/www/disble.tcl

ad_page_contract {
    all of this information is for the ACS 4 Glossary Package
    and is based on the glossary module written by Philip Greenspun (philg@mit.edu) and Jin Choi (jsc@arsdigita.com)
    
    @param item_id identifier of the glossary content_item to be "disabled"

    @author Walter McGinnis (walter@arsdigita.com)
    @creation_date 11-21-2000
    @cvs-id: $Id$
} {
  item_id:integer
} -properties {  
  title:onevalue
  context:onevalue
} 

ad_require_permission $item_id glossary_admin

set title [db_string get_item_title {
    select title
    from cr_revisions
    where item_id = :item_id 
    and revision_id = content_item.get_live_revision(:item_id)}]
    
set context [list "Disable <i>$title</i>?"]

template::form create disable_item

if {[template::form is_request disable_item]} {
    template::element create disable_item item_id -widget hidden \
	                                          -datatype number \
	                                          -value $item_id
}

if [template::form is_valid disable_item] {
    set user_id [ad_conn user_id]
    set peeraddr [ad_conn peeraddr]

    db_transaction {
	db_exec_plsql unset_live_content_item {
		begin
	            content_item.unset_live_revision(:item_id);
		end;
	}
	
	db_dml audit_update_object {
	    update acs_objects
	    set last_modified = sysdate,
	    modifying_user = :user_id,
	    modifying_ip = :peeraddr
	    where object_id = :item_id
	}
	
    }
   
    ad_returnredirect "."
}

