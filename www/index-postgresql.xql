<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_workflow_p_2">      
      <querytext>
      
	select case count(*) = 0 then 0 else 1 end
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
      
    select package_key, acs_object__name(package_id) as package_title
    from apm_packages
    where package_id = :package_id

      </querytext>
</fullquery>

 
<fullquery name="glossary_items_select">      
      <querytext>

    select i.item_id, title, party__name(owner_id) as owner_name, 
    case acs_permission__permission_p(i.item_id, :user_id, 'glossary_admin')
      when 't' then 1
      when 'f' then 0
    end as admin_p
    from glossariesx g, cr_items i
    where i.publish_status = 'live'
    and i.content_type = 'glossary'
    and i.live_revision = g.revision_id
    and publish_date < current_timestamp
    and acs_permission__permission_p(i.item_id, :user_id, 'read') = 't'
    and g.package_id = :package_id
    order by title

      </querytext>
</fullquery>

 
</queryset>
