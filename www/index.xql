<?xml version="1.0"?>
<queryset>

<fullquery name="get_admin_p">      
      <querytext>
      
    select case when count(*) = 0 then 0 else 1 end
    from acs_permissions p, cr_items i
    where grantee_id = :user_id
    and i.content_type = 'glossary'
    and item_id = object_id

      </querytext>
</fullquery>

 
<fullquery name="get_workflow_p_1">      
      <querytext>
      
	select case when count(*) = 0 then 0 else 1 end
	from wf_user_tasks t, wf_cases c, cr_items i
	where t.state in ('enabled','started')
	and i.content_type = 'glossary_term'
	and i.item_id = c.object_id
	and t.case_id = c.case_id
    
      </querytext>
</fullquery>

<fullquery name="get_workflow_link">      
      <querytext>
      
    select s1.name
    from site_nodes s1, site_nodes s2, apm_packages p
    where package_key = 'acs-workflow'
    and s1.object_id = :package_id
    and s1.parent_id = s2.parent_id
    and s2.node_id = :node_id

      </querytext>
</fullquery>

 
</queryset>
