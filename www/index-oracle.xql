<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_workflow_p_2">      
      <querytext>
      
	select decode(count(*), 0, 0, 1)
	from wf_user_tasks t, wf_cases c, cr_items i
	where t.user_id = :user_id
	and t.state in ('enabled','started')
	and i.content_type = 'glossary_term'
	and i.item_id = c.object_id
	and t.case_id = c.case_id

      </querytext>
</fullquery>

<fullquery name="package_info">      
      <querytext>
      
    select package_key, acs_object.name(package_id) package_title
    from apm_packages
    where package_id = :package_id

      </querytext>
</fullquery>

 
<fullquery name="glossary_items_select">      
      <querytext>
      
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

      </querytext>
</fullquery>

 
</queryset>
