<?xml version="1.0"?>
<queryset>

<fullquery name="glossary_workflow_info">      
      <querytext>
      
	select g.workflow_key, wf.description as workflow_description, pretty_name as workflow_name
	from glossariesx g, wf_workflows wf, acs_object_types ot
	where g.workflow_key = wf.workflow_key
	and wf.workflow_key = ot.object_type
	and g.item_id = :item_id
    
      </querytext>
</fullquery>

 
<fullquery name="glossary_update">      
      <querytext>
      
	    insert into glossariesi (
	    item_id, revision_id, title, description, context_id, creation_user, creation_ip, package_id
	    ) values (
	    :item_id, :revision_id, :title, :description, :context_id, :user_id, :peeraddr, :package_id
	    )
	
      </querytext>
</fullquery>

 
<fullquery name="set_revision_live">      
      <querytext>
      
	    update cr_items
	    set live_revision = :revision_id,
	    name = :name,
	    publish_status = 'live'
	    where item_id = :item_id
	
      </querytext>
</fullquery>

 
</queryset>
