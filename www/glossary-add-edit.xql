<?xml version="1.0"?>
<queryset>
 
<fullquery name="glossary_update">      
      <querytext>
      
	    insert into glossariesi (
	    item_id, revision_id, title, description, context_id, creation_user, creation_ip, package_id, workflow_key
	    ) values (
	    :item_id, :revision_id, :title, :description, :context_id, :user_id, :peeraddr, :package_id, :workflow_key
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
