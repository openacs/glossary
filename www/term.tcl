# glossary/www/term.tcl

ad_page_contract {
    the ACS 4 Glossary Package based on the glossary module written by Philip Greenspun (philg@mit.edu) and Jin Choi (jsc@arsdigita.com)

    @param item_id of the term
    @author Walter McGinnis (walter@arsdigita.com)
    @creation-date 11-21-2000
    @cvs-id $Id$
} {
  item_id:integer
} -properties {  
    term:onevalue
    definition:onevalue
    context:onevalue
    term_modify_p:onevalue
    term_create_p:onevalue
    illustration_exists_p:onevalue
    ill_description:onevalue
    ill_title:onevalue
    ill_widthheight:onevalue
    ill_export_vars:onevalue
    comments:onevalue
    comment_link:onevalue
} 

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

# the following two queries should probably be combined into one
if {[db_0or1row  illuststration_exists {
    select i.item_id as illustration_item_id, 
    live_revision as illustration_revision_id
    from cr_child_rels ch, cr_items i
    where relation_tag = 'illustration' 
    and ch.parent_id = :item_id
    and ch.child_id = i.item_id
    and publish_status = 'live'}]} {

    # look for a live revision
    set illustration_exists_p 1
    db_1row get_picture_info {
	select i.width, i.height, cr.title as ill_title, 
	cr.description as ill_description, cr.publish_date
	from images i, cr_revisions cr
	where i.image_id = cr.revision_id
	and image_id = :illustration_revision_id
   }
   if { ![empty_string_p $width] && ![empty_string_p $height] } {
       set widthheight "width=$width height=$height"
   } else {
       set widthheight ""
   }
   set ill_export_vars "revision_id=$illustration_revision_id"
} else {
    set illustration_exists_p 0
}

# grab the parent glossary item_id and check permission and if it is "live"
if ![db_0or1row get_live_p_and_glossary_item_id { 
    select ch.parent_id as glossary_item_id
    from cr_child_rels ch, cr_items i
    where child_id = :item_id 
    and relation_tag = 'parent glossary'
    and ch.parent_id = item_id
    and live_revision is not null}] {
    
    # this should be changed to something more approriate to a templated system
    ad_return_complaint 1 "This glossary is no longer available"
    ad_script_abort
}

ad_require_permission $item_id read

db_0or1row glossary_term_item_select {
    select term, definition,
    revision_id, item_id, name, mime_type,
    decode(acs_permission.permission_p(item_id,
                                       :user_id,
                                       'glossary_term_modify'),
           't', 1,
           'f', 0) as term_modify_p
    from glossary_terms_live_definition
    where item_id = :item_id
}

set html_definition [ad_html_text_convert -from $mime_type -- $definition]

set glossary_title [db_string get_glossary_title "
select title from glossariesx
where revision_id = content_item.get_live_revision(:glossary_item_id)
"]

set context [list [list "glossary?item_id=$glossary_item_id" $glossary_title] $term]

set term_create_p [ad_permission_p $glossary_item_id glossary_term_create]

set return_url "[ad_conn url]?item_id=$item_id&glossary_item_id=$glossary_item_id"

if [ad_permission_p $item_id glossary_term_comment_on] {
    set comment_link [general_comments_create_link -object_name $term -link_text "comment on $term" $item_id $return_url]
} else {
    set comment_link ""
}

if [ad_permission_p $item_id glossary_term_comment_read] {
    set comments [general_comments_get_comments -print_content_p 1 $item_id $return_url]
} else {
    set comments ""
}

db_release_unused_handles

ad_return_template

