<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="illustration_select">      
      <querytext>
      
	select title, description, name
	from imagesx
	where item_id = :item_id
	and revision_id = content_item.get_latest_revision(:item_id)
    
      </querytext>
</fullquery>

 
</queryset>
