<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="glossary_workflow_info">      
      <querytext>
      
    select g.title as glossary_title, g.revision_id
    from glossariesx g
    where g.item_id = :item_id
    and g.revision_id = content_item__get_latest_revision(:item_id)

      </querytext>
</fullquery>

 
<fullquery name="glossary_workflow_audit_update">      
      <querytext>
      
	update acs_objects 
	set last_modified = current_timestamp,
	modifying_user = :user_id,
	modifying_ip = :peeraddr
	where object_id = :item_id
    
      </querytext>
</fullquery>

 
</queryset>
