# /glossary/www/package-administer.tcl

ad_page_contract {
    all of this information is for the ACS 4 Glossary Package
    and is based on the glossary module written by Philip Greenspun (philg@mit.edu) and Jin Choi (jsc@arsdigita.com)

    @author Walter McGinnis (walter@arsdigita.com)
    @creation_date 11-20-2000
    @cvs-id: $Id$
} {
} -properties {  
  glossary_item:multirow
  context:onevalue
  create_p:onevalue
} 

set package_id [ad_conn package_id]

set user_id [ad_conn user_id]

set context [list "Administration"]

ad_require_permission $package_id read

set create_p [ad_permission_p $package_id glossary_create]

# grab all glossaries that this user can administer
db_multirow glossary_item glossary_items_select {
    select i.item_id, title, party.name(owner_id) as owner_name, publish_date, publish_status, live_revision
    from glossariesx g, cr_items i
    where i.content_type = 'glossary'
    and i.item_id = g.item_id
    and acs_permission.permission_p(i.item_id, :user_id, 'glossary_admin') = 't'
    and g.package_id = :package_id
    and g.revision_id = content_item.get_latest_revision(i.item_id)
    order by title
}

db_release_unused_handles

ad_return_template



