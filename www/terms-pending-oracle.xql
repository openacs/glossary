<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="glossary_item_select">      
      <querytext>
      
    select i.item_id as glossary_item_id, title as glossary_title,
    description as glossary_description, i.publish_status as glossary_status,
    decode(acs_permission.permission_p(i.item_id,
                                       :user_id,
                                       'glossary_modify'),
           't', 1,
           'f', 0) as glossary_edit_p
    from glossariesx g, cr_items i
    where g.item_id = :item_id 
    and g.item_id = i.item_id
    and i.content_type = 'glossary'
    and i.live_revision = g.revision_id

      </querytext>
</fullquery>

 
<fullquery name="glossary_pending_term_items_select">      
      <querytext>
      
    select i.item_id as glossary_term_item_id , title as term, publish_status as term_status
    from glossary_termsx gt, cr_items i, cr_child_rels ch
    where ch.parent_id = :item_id
    and ch.child_id = gt.item_id
    and i.publish_status != 'live'
    and i.content_type = 'glossary_term'
    and i.live_revision = gt.revision_id
    and acs_permission.permission_p(i.item_id, :user_id, 'glossary_term_modify') = 't'
    order by term

      </querytext>
</fullquery>

 
</queryset>
