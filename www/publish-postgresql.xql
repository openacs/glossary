<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_item_title_and_revision_id">      
      <querytext>
      
    select title, revision_id
    from cr_revisions
    where item_id = :item_id 
    and revision_id = content_item__get_latest_revision(:item_id)

      </querytext>
</fullquery>

 
<fullquery name="set_live_content_item">      
      <querytext>
	 select content_item__set_live_revision(:revision_id, 'live');
      </querytext>
</fullquery>

 
<fullquery name="audit_update_object">      
      <querytext>
      
	    update acs_objects
	    set last_modified = current_timestamp,
	    modifying_user = :user_id,
	    modifying_ip = :peeraddr
	    where object_id = :item_id
	
      </querytext>
</fullquery>

 
</queryset>
