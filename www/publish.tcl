# glossary/www/publish.tcl

ad_page_contract {
    the ACS 4 Glossary Package
    is based on the glossary module written by Philip Greenspun (philg@mit.edu) and Jin Choi (jsc@arsdigita.com)

    @author Walter McGinnis (walter@arsdigita.com)
    @creation-date 11-21-2000
    @cvs-id $Id$
} {
  item_id:integer
} -properties {  
  title:onevalue
  context:onevalue
} 

ad_require_permission $item_id glossary_admin

db_1row get_item_title_and_revision_id {
    select title, revision_id
    from cr_revisions
    where item_id = :item_id 
    and revision_id = content_item.get_latest_revision(:item_id)
}
    

set context [list "Publish <i>$title</i>?"]

template::form create publish_item

if {[template::form is_request publish_item]} {
    template::element create publish_item item_id -widget hidden \
	                                          -datatype number \
	                                          -value $item_id

}

if [template::form is_valid publish_item] {
    set user_id [ad_conn user_id]
    set peeraddr [ad_conn peeraddr]

    db_transaction {
	db_exec_plsql set_live_content_item {
		begin
	            content_item.set_live_revision(:revision_id, 'live');
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

