<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_item_title">      
      <querytext>
      
    select title
    from cr_revisions
    where item_id = :item_id 
    and revision_id = content_item.get_live_revision(:item_id)
      </querytext>
</fullquery>

 
<fullquery name="unset_live_content_item">      
      <querytext>
      
		begin
	            content_item.unset_live_revision(:item_id);
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
