# glossaries/www/workflow-add-edit.tcl

ad_page_contract {
   the ACS 4 Glossary Package based on the glossary module written by Philip Greenspun (philg@mit.edu) and Jin Choi (jsc@arsdigita.com)

    @param item_id what glossary item are we setting a workflow for
    @param workflow_key for the glossary
    @param new_workflow_key for the glossary

    @author Walter McGinnis (walter@arsdigita.com)
    @creation-date 11-20-2000
    @cvs-id: $Id$
} {
    item_id:optional,integer
    workflow_key:optional
    new_workflow_key:optional
} -properties {  
    new_p:onevalue
    glossary_title:onevalue
} 
# THIS SCRIPT IN TRANSITION - NOT RUNNABLE

set user_id [ad_conn user_id]

ad_require_permission $item_id glossary_modify

set context_bar [ad_context_bar "Set Workflow"]

if {[info exists workflow_key]} {
    set new_p 0
} else {
    set new_p 1
}

db_1row glossary_workflow_info {
    select g.title as glossary_title, g.revision_id
    from glossariesx g
    where g.item_id = :item_id
    and g.revision_id = content_item.get_latest_revision(:item_id)
}

# here is where we build our custom form
template::form create new_workflow

if {[template::form is_request new_workflow]} {
    # go live is a special case of workflow for the glossary
    # that is there are no corresponding workflow places, transitions, arcs, etc for
    set radio_options [list]
   
    # this is not selective enough, but will have to do for the time being
    # need an API for classifying potential workflows for different applications
    db_foreach get_workflow_process {
	select wf.workflow_key as possible_workflow_key, 
	wf.description as possible_description, pretty_name as possible_workflow_name
	from wf_workflows wf, acs_object_types ot
	where workflow_key like '%term%' 
	and wf.workflow_key = ot.object_type
    } {
	lappend radio_options [list "$possible_workflow_name : $possible_description" $possible_workflow_key]
    } 


    if {[info exists workflow_key]} {

	template::element create new_workflow item_id -widget hidden \
		-datatype number \
		-value $item_id

	template::element create new_workflow new_workflow_key -label "Choose a Workflow" \
		-widget radio \
		-datatype text \
		-value $workflow \
		-options $radio_options

    } else {
	template::element create new_workflow item_id -widget hidden \
		-datatype number \
		-value $item_id

	template::element create new_workflow new_workflow_key -label "Choose a Workflow" \
		-widget radio \
		-datatype text \
		-options $radio_options
    }
}

if [template::form is_valid new_workflow] {
    set peeraddr [ad_conn peeraddr]

    db_dml glossary_workflow_update {
	update glossaries
	set workflow_key = :new_workflow_key
	where glossary_id = :revision_id
    }
    
    db_dml glossary_workflow_audit_update {
	update acs_objects 
	set last_modified = sysdate,
	modifying_user = :user_id,
	modifying_ip = :peeraddr
	where object_id = :item_id
    }

    ad_returnredirect "."
}
