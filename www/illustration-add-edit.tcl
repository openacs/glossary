# glossaries/www/illustration-add-edit.tcl
ad_page_contract {
    Uploading or editing illustration
    
    @param term_item_id item_id of term
    @param item_id illustration's item_id
    @param title of illustration
    @param name used for urls in content-repository, stored in cr_items
    @param description of illustration

    @author Walter McGinnis (walter@arsdigita.com)
    @creation-date 11-21-2000
    @cvs-id: $Id$
} {
    item_id:optional,integer
    term_item_id:integer
    title:optional,trim
    name:optional,trim
    description:optional,trim
} -properties {
    context_bar:onevalue
    title:onevalue
    descritpion:onevalue
    name:onevalue
    export_vars:onevalue
    new_p:onevalue
}

set package_id [ad_conn package_id]

set user_id [ad_conn user_id]

if {[info exists item_id]} {
    ad_require_permission $item_id glossary_term_modify_illustration

    set context_bar [ad_context_bar "Edit Illustration"]
    db_1row illustration_select {
	select title, description, name
	from imagesx im, cr_items i
	where im.item_id = :item_id
	and im.item_id = i.item_id
	and revision_id = content_item.get_latest_revision(:item_id)
    }
    set export_vars [export_form_vars term_item_id item_id]
    set new_p 0
} else {
    ad_require_permission $term_item_id glossary_term_add_illustration
    
    set context_bar [ad_context_bar "Upload Illustration"]
    
    set title ""
    set description ""
    set name ""
    set new_p 1
    set export_vars [export_form_vars term_item_id item_id]
}

ad_return_template