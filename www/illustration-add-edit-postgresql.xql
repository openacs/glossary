<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="illustration_select">      
      <querytext>
      
	select title, description, name
	from imagesx im, cr_items i
	where im.item_id = :item_id
	and im.item_id = i.item_id
	and revision_id = content_item__get_latest_revision(:item_id)
    
      </querytext>
</fullquery>

 
</queryset>
