<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_item_title_and_revision_id">      
      <querytext>
      
    select title, revision_id
    from cr_revisions
    where item_id = :item_id 
    and revision_id = content_item.get_latest_revision(:item_id)

      </querytext>
</fullquery>

 
<fullquery name="set_live_content_item">      
      <querytext>
      
		begin
	            content_item.set_live_revision(:revision_id, 'live');
		end;
	
      </querytext>
</fullquery>

 
<fullquery name="audit_update_object">      
      <querytext>
      
	    update acs_objects
	    set last_modified = sysdate,
	    modifying_user = :user_id,
	    modifying_ip = :peeraddr
	    where object_id = :item_id
	
      </querytext>
</fullquery>

 
</queryset>
