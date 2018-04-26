# glossary/www/index.tcl

ad_page_contract {
    this is glossary display page for the ACS 4 Glossary Package
    which is based on the glossary module written by Philip Greenspun (philg@mit.edu) and Jin Choi (jsc@arsdigita.com)

    @author Walter McGinnis (walter@arsdigita.com)
    @creation-date 11-20-2000
    @cvs-id $Id$
} {
} -properties {  
  glossary_item:multirow
  package_title:onevalue
  context:onevalue
  create_p:onevalue
  admin_p:onevalue
  workflow_p:onevalue
  workflow_link:onevalue   
} 

set package_id [ad_conn package_id]

db_1row package_info {
    select package_key, acs_object.name(package_id) package_title
    from apm_packages
    where package_id = :package_id
}

set user_id [ad_conn user_id]

set context {}

ad_require_permission $package_id read

set create_p [ad_permission_p $package_id glossary_create]

set admin_p [db_string get_admin_p {
    select decode(count(*), 0, 0, 1)
    from acs_permissions p, cr_items i
    where grantee_id = :user_id
    and i.content_type = 'glossary'
    and item_id = object_id
}]

if {$admin_p} {
    set workflow_p [db_string get_workflow_p_1 {
	select decode(count(*), 0, 0, 1)
	from wf_user_tasks t, wf_cases c, cr_items i
	where t.state in ('enabled','started')
	and i.content_type = 'glossary_term'
	and i.item_id = c.object_id
	and t.case_id = c.case_id
    }]
} else {
    set workflow_p [db_string get_workflow_p_2 {
	select decode(count(*), 0, 0, 1)
	from wf_user_tasks t, wf_cases c, cr_items i
	where t.user_id = :user_id
	and t.state in ('enabled','started')
	and i.content_type = 'glossary_term'
	and i.item_id = c.object_id
	and t.case_id = c.case_id
    }]
}

set node_id [ad_conn node_id]

# the directory level is hard coded and rather brittle
# makes the assumption that workflow has been instantiated
# under the parent node
# it may not have been instatiated
# and if it has, it may not be under the directory level specified here
set workflow_link "../[db_string get_workflow_link {
    select s1.name
    from site_nodes s1, site_nodes s2, apm_packages p
    where package_key = 'acs-workflow'
    and s1.object_id = package_id
    and s1.parent_id = s2.parent_id
    and s2.node_id = :node_id
}]"

# get the info for the glossaries
db_multirow glossary_item glossary_items_select {
    select i.item_id, title, party.name(owner_id) as owner_name, 
    decode(acs_permission.permission_p(i.item_id,
                                       :user_id,
                                       'glossary_admin'),
           't', 1,
           'f', 0) as admin_p
    from glossariesx g, cr_items i
    where i.publish_status = 'live'
    and i.content_type = 'glossary'
    and i.live_revision = g.revision_id
    and publish_date < sysdate
    and acs_permission.permission_p(i.item_id, :user_id, 'read') = 't'
    and g.package_id = :package_id
    order by title
}

db_release_unused_handles

ad_return_template



