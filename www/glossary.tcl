# glossary/www/glossary.tcl

ad_page_contract {
    all of this information is for the ACS 4 Glossary Package
    and is based on the glossary module written by Philip Greenspun (philg@mit.edu) and Jin Choi (jsc@arsdigita.com)

    @param item_id of the glossary

    @author Walter McGinnis (walter@arsdigita.com)
    @creation-date 11-21-2000
    @cvs-id $Id$
} {
  item_id:integer
} -properties {  
  glossary_title:onevalue
  glossary_description:onevalue
  glossary_item_id:onevalue
  glossary_edit_p:onevalue
  glossary_term_item:multirow
  context:onevalue
  term_create_p:onevalue
} 

set package_id [ad_conn package_id]

set user_id [ad_conn user_id]

ad_require_permission $item_id read

# check to see if there is a live version of the glossary
# if not return ad_complaint
if ![db_0or1row glossary_item_select {
    select i.item_id as glossary_item_id, title as glossary_title,
    description as glossary_description,
    decode(acs_permission.permission_p(i.item_id,
                                       :user_id,
                                       'glossary_modify'),
           't', 1,
           'f', 0) as glossary_edit_p
    from glossariesx g, cr_items i
    where g.item_id = :item_id 
    and g.item_id = i.item_id
    and i.publish_status = 'live'
    and i.content_type = 'glossary'
    and publish_date < sysdate
    and i.live_revision = g.revision_id
}] {
    # this needs to be replaced by something more appropriate to ats
    ad_return_complaint 1 "This glossary is no longer available"
    ad_script_abort
}

set context [list $glossary_title]

set term_create_p [ad_permission_p $glossary_item_id glossary_term_create]

# since we are using content repository versioning
# we want to identify the term by the item_id column
db_multirow glossary_term_item glossary_term_items_select {
    select i.item_id as glossary_term_item_id , title as term,
    decode(acs_permission.permission_p(i.item_id,
                                       :user_id,
                                       'glossary_term_modify'),
           't', 1,
           'f', 0) as term_edit_p
    from glossary_termsx gt, cr_items i, cr_child_rels ch
    where ch.parent_id = :item_id
    and ch.child_id = gt.item_id
    and i.publish_status = 'live'
    and i.content_type = 'glossary_term'
    and i.live_revision = gt.revision_id
    and publish_date > sysdate -1
    and acs_permission.permission_p(i.item_id, :user_id, 'read') = 't'
    order by term
}

db_release_unused_handles

ad_return_template

