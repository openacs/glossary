# glossaries/www/term-add-edit.tcl

ad_page_contract {
    the ACS 4 Glossary Package is based on the glossary module written by Philip Greenspun (philg@mit.edu) and Jin Choi (jsc@arsdigita.com)

    @param glossary_item_id what glossary item that this term belongs to    
    @param item_id what glossary term item are we updating
    @param term of the term, otherwise know as cr_revisions.title
    @param definition of the term, otherwise know as the cr_revisions.content column
    @param mime_type of the term's revision
    @param publish_status of the term's revision's parent content_item 
    @param item_id of the term 

    @author Walter McGinnis (walter@arsdigita.com)
    @creation-date 11-21-2000
    @cvs-id: $Id$
} {
    item_id:optional,integer
    glossary_item_id:optional,integer
    term:optional,trim
    name:optional,trim
    definition:optional,trim
    mime_type:optional
    publish_status:optional
} -properties {  
    context_bar:onevalue
    illustration_exists_p:onevalue
    illustration_link_url:onevalue
    illustration_add_p:onevalue
    new_p:onevalue
} 

set package_id [ad_conn package_id]

set user_id [ad_conn user_id]

# if this is an edit of an existing term
if {[info exists item_id]} {
    ad_require_permission $item_id glossary_term_modify

    set new_p 0

    # grab the existing illustration item_id
    # if there is no illustration set variable to empty string
    set illustration_item_id [db_string  illuststration_exists {
	select child_id as illustration_item_id from cr_child_rels 
	where relation_tag = 'illustration' and parent_id = :item_id} -default ""]
   
   # configure the link to illustration-add-edit accordingly
   if {![empty_string_p $illustration_item_id]} {
       set illustration_link_url "illustration-add-edit?item_id=$illustration_item_id&term_item_id=$item_id"
       set illustration_exists_p 1
   } else {
       set illustration_link_url "illustration-add-edit?term_item_id=$item_id"
       set illustration_exists_p 0
   }
   
   set context_bar [ad_context_bar "Edit Term"]

} else {
    ad_require_permission $glossary_item_id glossary_term_create

    set illustration_link_url ""

    set illustration_exists_p 0

    set context_bar [ad_context_bar "New Term"]

    set new_p 1
}

# find out what the workflow is for the parent glossry of this term
if {[info exists glossary_item_id] && ![empty_string_p $glossary_item_id]} {
    set glossary_workflow [db_string get_glossary_workflow {
	select workflow_key from glossariesx
	where item_id = :glossary_item_id
	and revision_id = content_item.get_live_revision(:glossary_item_id)
    }]
} else {
    set glossary_workflow [db_string get_glossary_workflow {
	select workflow_key 
	from glossariesx g, cr_child_rels ch
	where g.item_id = ch.parent_id
	and ch.child_id = :item_id
	and revision_id = content_item.get_live_revision(g.item_id)
    }]
}

# here is where we build our custom form
template::form create new_term

if {[template::form is_request new_term] && [info exists item_id]} {
    # if a term already exists this an edit and we need to grab the previous
    # values for the term
    set glossary_item_id [db_string get_parent_glossary_item_id {
	select parent_id from cr_child_rels 
	where child_id = :item_id and relation_tag = 'parent glossary'}]

    template::element create new_term item_id \
            -widget hidden \
            -datatype number \
            -value $item_id

    template::element create new_term glossary_item_id \
            -widget hidden \
            -datatype number \
            -value $glossary_item_id

    # grab the info for the term
    db_1row term_select {
	select term, definition, publish_status,
	live_revision, latest_revision, name, mime_type,
	decode(acs_permission.permission_p(item_id,
	:user_id,
	'glossary_term_add_illustration'),
	't', 1,
	'f', 0) as illustration_add_p
	from glossary_terms_latest
	where item_id = :item_id
    }

    template::element create new_term term -label "Term" \
                                                -widget text \
	                                        -datatype text \
	                                        -value $term \
                                                -html { size 30 }

    template::element create new_term name -label "Short Name for URL (no spaces)" \
                                                -widget text \
	                                        -datatype text \
	                                        -value $name \
                                                -html { size 15 }
	
    template::element create new_term definition -label "Definition" \
                                                      -widget textarea \
	                                              -datatype text \
					              -value $definition

    db_with_handle db {
        template::query mime_types multilist {
            select label, mime_type 
              from cr_mime_types 
          order by label
        } -db $db
    }
   
    template::element create new_term mime_type \
            -datatype text \
            -widget select \
            -options $mime_types \
            -values $mime_type
    
    set publish_states [glossary_publish_states]

    element create new_term publish_status \
            -datatype text \
            -widget select \
            -options $publish_states \
            -values $publish_status

} elseif {[template::form is_request new_term]} {
    # this is a new term
    set term_delete_p 0
    set ilustration_add_p 0
    set admin_p 0
    set live_p 0

    template::element create new_term glossary_item_id \
            -widget hidden \
            -datatype number \
            -value $glossary_item_id

    template::element create new_term term \
            -label "Term" \
            -widget text \
            -datatype text \
            -html { size 30 }

    template::element create new_term name \
            -label "Short Name for URL (no spaces)" \
            -widget text \
            -datatype text \
            -html { size 15 }
	
    template::element create new_term definition \
            -label "Definition" \
            -widget textarea \
            -datatype text 

    db_with_handle db {
        template::query mime_types multilist {
            select label, mime_type 
              from cr_mime_types 
          order by label
        } -db $db
   }


   template::element create new_term mime_type \
           -datatype text \
           -widget select \
           -options $mime_types  \
           -values "text/plain"

    switch $glossary_workflow {
        "term_go_live_wf" {
            element create new_term publish_status \
                    -datatype text \
                    -widget hidden \
                    -value "live"
        } 
        "term_submission_process_wf" {
            element create new_term publish_status \
                    -datatype text \
                    -widget hidden \
                    -value "ready"
        } 
        "full_term_publish_process_wf" {
            element create new_term publish_status \
                    -datatype text \
                    -widget hidden \
                    -value "production"
        }
    }
}

if [template::form is_valid new_term] {
     set peeraddr [ad_conn peeraddr]

    # context_id is the parent  glossary_item_id
        
    if [info exists item_id] {
        set revision_id [db_string get_next_revision_id {
	    select acs_object_id_seq.nextval from dual
	}]

	db_transaction {
	    db_dml term_update {
		insert into glossary_termsi (
		item_id, revision_id, title, context_id, 
		creation_user, creation_ip
		) values (
		:item_id, :revision_id, 
		:term, :glossary_item_id, :user_id, :peeraddr
		)
	    }

	    if {![empty_string_p $definition]} {
		db_dml term_definition_update {
		    update cr_revisions
		    set content = empty_blob()
		    where revision_id = :revision_id
		    returning content into :1
		} -blobs [list $definition]
	    }

	    db_dml set_revision_live {
	        update cr_items
		set live_revision = :revision_id,
		name = :name,
		publish_status = :publish_status
		where item_id = :item_id
	    }
	}
    } else {
	# this is best wrapped up as a tcl proc i think
	db_transaction {
	    # insert a new content_item
	    set new_item_id [db_exec_plsql term_new_content_item {
		begin
		:1 := content_item.new (
		name => :name,
		content_type => 'glossary_term',
                context_id => :glossary_item_id,
                creation_user => :user_id,
                creation_ip => :peeraddr
		);
		end;
	    }]

	   set new_revision_id [db_exec_plsql term_new_content_revision {
	       begin
	       :1 := content_revision.new(
	       item_id => :new_item_id,
	       title => :term,
	       creation_user => :user_id,
	       creation_ip => :peeraddr
	       );
		end;
	    }]

	    db_dml term_insert {
		insert into glossary_terms (
		term_id
		) values (
		:new_revision_id
		)
	    }
	      
	    if {![empty_string_p $definition]} {
		db_dml term_definition_update {
		    update cr_revisions
		    set content = empty_blob()
		    where revision_id = :new_revision_id
		    returning content into :1
		} -blobs [list $definition]
	    }

	    db_dml set_revision_live {
	        update cr_items
		set live_revision = :new_revision_id,
		name = :name, 
		publish_status = :publish_status
		where item_id = :new_item_id
	    }

	    # we associate the term with its parent glossary	    
	    set rel_id [db_exec_plsql term_new_content_revision {
		begin
		:1 := acs_object.new(
		object_type	=> 'cr_item_child_rel',
		context_id	=> :glossary_item_id
		);
		end;
	    }]

	    db_dml set_parent_glossary {
		insert into cr_child_rels (
		rel_id, parent_id, child_id, relation_tag
		) values (
		:rel_id, :glossary_item_id, :new_item_id, 'parent glossary'
		)
	    }
	    # need to find out what the right thing to do for context_key is
	    # until then...
	    set context_key "default"
	    
	    # finally we initialize a new workflow case for each term
	    if {![string equal $glossary_workflow "term_go_live_wf"]} {
		wf_case_new $glossary_workflow $context_key $new_item_id
	    }
	}
	set item_id $new_item_id
    }

switch $glossary_workflow {
    "term_go_live_wf" {
	ad_returnredirect "term?item_id=$item_id"
    } 
    "term_submission_process_wf" {
	ad_returnredirect "."
    } 
    "full_term_publish_process_wf" {
	ad_returnredirect "."
    }
    }    
    
}
