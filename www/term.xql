<?xml version="1.0"?>
<queryset>

<fullquery name="illuststration_exists">      
      <querytext>
      
    select i.item_id as illustration_item_id, 
    live_revision as illustration_revision_id
    from cr_child_rels ch, cr_items i
    where relation_tag = 'illustration' 
    and ch.parent_id = :item_id
    and ch.child_id = i.item_id
    and publish_status = 'live'
      </querytext>
</fullquery>

 
<fullquery name="get_picture_info">      
      <querytext>
      
	select i.width, i.height, cr.title as ill_title, 
	cr.description as ill_description, cr.publish_date
	from images i, cr_revisions cr
	where i.image_id = cr.revision_id
	and image_id = :illustration_revision_id
   
      </querytext>
</fullquery>

 
<fullquery name="get_live_p_and_glossary_item_id">      
      <querytext>
       
    select ch.parent_id as glossary_item_id
    from cr_child_rels ch, cr_items i
    where child_id = :item_id 
    and relation_tag = 'parent glossary'
    and ch.parent_id = item_id
    and live_revision is not null
      </querytext>
</fullquery>

 
</queryset>
