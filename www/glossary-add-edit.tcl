# glossaries/www/glossary-add-edit.tcl

ad_page_contract {
    all of this information is for the ACS 4 Glossary Package
    and is based on the glossary module written by Philip Greenspun (philg@mit.edu) and Jin Choi (jsc@arsdigita.com)

    @param item_id what glossary item are we updating
    @param context_id what object are we going to inherit security settings from, currently not in use, but will be in the future
    @param title of glossary
    @param description of glossary fro cr_items
    @param owner_id currently not passed in, but will be in the future

    @param title of the glossary
    @param description of the glossary
    @param owner_id of the party that owns the glossary

    @author Walter McGinnis (walter@arsdigita.com)
    @author Bart Teeuwisse (bart.teeuwisse@7-sisters.com)
    @creation-date 11-20-2000
    @cvs-id $Id$
} {
    context_id:optional,integer
    item_id:optional,integer
    title:optional,trim
    description:optional,trim
    owner_id:integer,optional
} -properties {  
    context:onevalue
    new_p:onevalue
    permissions_link:onevalue
    live_p:onevalue
    publish_action_link:onevalue
    workflow_link:onevalue
    workflow_name:onevalue
    workflow_description:onevalue
    pending_terms_link:onevalue
} 

#### WARNING: SKIPPING OWNER_ID AND OWNER_NAME DETAILS FOR THE TIME BEING !!!!
#### right now we are just going to set the owner_id to user_id
#### and comment out the areas where we tried to deal with choosing a different
#### party for owner, there are several holes in the users/parties API

#### form vars temporarily dropped
# owner_name:optional,trim
# {make_owner_p:optional "f"}

#### will do this later #####
# context_id may be passed in if glossary is being used as a service...
# i.e. we are setting the default permissions to another object than 
# the package instance
##########################

# THIS SCRIPT IN TRANSITION - RUNNABLE, BUT NOT COMPLETE

set package_id [ad_conn package_id]

set user_id [ad_conn user_id]

if {[info exists item_id]} {
    # this is an existing glossary
    ad_require_permission $item_id glossary_modify
    
    set context [list "Edit Glossary"]
    
    set new_p 0
    
    set permissions_link "/permissions/one?object_id=$item_id"

    # grab the existing workflow_key and desciption for the glossary
    if ![db_0or1row glossary_workflow_info {
	select g.workflow_key, wf.description as workflow_description, pretty_name as workflow_name
	from glossariesx g, wf_workflows wf, acs_object_types ot
	where g.workflow_key = wf.workflow_key
	and wf.workflow_key = ot.object_type
	and g.item_id = :item_id
    }] {
	set workflow_key ""
	set workflow_description ""
	set workflow_name ""
    }
    
    # does this user have any pending terms that they need to work on?
    set pending_terms_p [db_string get_pending_terms_p {
	select decode(count(*), 0, 0, 1)
	from glossary_termsx
	where ( acs_permission.permission_p(item_id, :user_id, 'glossary_term_modify') = 't' or acs_permission.permission_p(item_id, :user_id, 'glossary_term_illustration_add') = 't' or acs_permission.permission_p(item_id, :user_id, 'glossary_term_illustration_modify') = 't')
    }]
    
    if {$pending_terms_p} {
	set pending_terms_link "terms-pending?item_id=$item_id"
    }
} else {
    # this will be a new glossary
    ad_require_permission $package_id glossary_create
    
    set context [list "New Glossary"]

    set new_p 1

    set permissions_link ""

    set disable_link ""

    set workflow_key ""
    set workflow_description ""
    set workflow_name ""
    set pending_terms_link ""
}

# here is where we build our custom form
template::form create new_glossary

if {[template::form is_request new_glossary] && [info exists item_id]} {
    # for an existing glossary
    template::element create new_glossary item_id -widget hidden \
	                                          -datatype number \
	                                          -value $item_id
    # column temporarily dropped from query
    # party.name(owner_id) as owner_name
    
    db_0or1row glossary_select {
	select title, name, description, owner_id,  publish_status,
	decode(acs_permission.permission_p(i.item_id,
	:user_id,
	'glossary_admin'),
	't', 1,
	'f', 0) as glossary_admin_p
	from glossariesx g, cr_items i
	where i.item_id = :item_id
	and i.publish_status = 'live'
	and i.content_type = 'glossary'
	and i.live_revision = g.revision_id
    }
    
    if {![string equal $publish_status "live"]} {
	set live_p 0
	set publish_action_link "publish?item_id=:item_id"
    } else {
	set publish_action_link "disable?item_id=$item_id"
	set live_p 1
    }

    template::element create new_glossary title -label "Glossary Title" \
                                                -widget text \
	                                        -datatype text \
	                                        -value $title \
                                                -html { size 30 }

#     template::element create new_glossary name \
# 	-widget hidden \
# 	-datatype text \
# 	-value ""
	
    template::element create new_glossary description -label "Description" \
	-widget textarea \
	-datatype text \
	-value $description \
	-html { cols 80 rows 8 }

    # form elements temporarily dropped
    #  template::element create new_glossary owner_name -label "Owner" \
#                                                       -widget text \
#  	                                             -datatype text \
#  	                                             -value $owner_name

#      template::element create new_glossary make_owner_p -label "Make me the owner" \
#                                                         -widget checkbox \
#  	                                               -datatype boolean

} elseif {[template::form is_request new_glossary]} {
    template::element create new_glossary title -label "Glossary Title" \
                                                -widget text \
	                                        -datatype text \
                                                -html { size 30 }

#     template::element create new_glossary name \
# 	-widget hidden \
# 	-datatype text \
# 	-value "${package_id}_${item_id}"
	
    template::element create new_glossary description -label "Description" \
	-widget textarea \
	-datatype text  \
	-html { cols 80 rows 8 }
}

if [template::form is_valid new_glossary] {
    set peeraddr [ad_conn peeraddr]

    # if context_id is not present, we should set it to package_id
    # this will later become useful
    if {![info exists context_id]} {
	set context_id $package_id
    }
    
    # an update is actually inserting a new row in revisions, glossaries, acs_objects
    # there is a special view for the content_type that has an instead of trigger on it that does the right thing
    # in this particular case we don't have to insert a blob
    # which simplifies things
    if [info exists item_id] {        
        # temporarily pulling ability to change owner_id from update
        # owner_id,
        # :owner_id,
        # will want to add a few things later
        # publish_date?
        set revision_id [db_string get_next_revision_id {
	    select acs_object_id_seq.nextval from dual
	}]

	db_dml glossary_update {
	    insert into glossariesi (
	    item_id, revision_id, title, description, context_id, creation_user, creation_ip, workflow_key
	    ) values (
	    :item_id, :revision_id, :title, :description, :context_id, :user_id, :peeraddr, :workflow_key
	    )
	}
	# for right now we are setting things live right away
	# we should change this to take its value from the publish_status 
	# form element, which doesn't exist right now
	# see template-add-edit for code to grab
	db_dml set_revision_live {
	    update cr_items
	    set live_revision = :revision_id,
	    name = :package_id || '_' || :item_id,
	    publish_status = 'live'
	    where item_id = :item_id
	}

    } else {
        # this is temporary
        set owner_id $user_id
	set is_live "t"
	
	set new_item_id [db_exec_plsql new_glossary {
	    begin
	    :1 := glossary.new (
	    owner_id => :owner_id,
	    name => :package_id || '_' || :item_id,
	    title => :title,
            description => :description,
	    package_id => :package_id,
	    creation_user => :user_id,
	    creation_ip => :peeraddr,
	    context_id => :context_id,
	    is_live => :is_live
	    );
	    acs_permission.grant_permission(:1,:owner_id, 'glossary_admin');
	    end;
	}]

	ad_returnredirect workflow-add-edit?item_id=$new_item_id
    }
    ad_returnredirect "."
}
