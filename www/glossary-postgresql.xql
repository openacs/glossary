<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="glossary_item_select">      
      <querytext>

    select i.item_id as glossary_item_id, title as glossary_title,
    description as glossary_description,
    case acs_permission__permission_p(i.item_id, :user_id, 'glossary_modify')
      when 't' then 1
      when 'f' then 0
    end  as glossary_edit_p
    from glossariesx g, cr_items i
    where g.item_id = :item_id 
    and g.item_id = i.item_id
    and i.publish_status = 'live'
    and i.content_type = 'glossary'
    and publish_date < current_timestamp
    and i.live_revision = g.revision_id

      </querytext>
</fullquery>

 
<fullquery name="glossary_term_items_select">      
      <querytext>

    select i.item_id as glossary_term_item_id , title as term,
    case acs_permission__permission_p(i.item_id, :user_id, 'glossary_term_modify')
      when 't' then 1
      when 'f' then 0
    end as term_edit_p
    from glossary_termsx gt, cr_items i, cr_child_rels ch
    where ch.parent_id = :item_id
    and ch.child_id = gt.item_id
    and i.publish_status = 'live'
    and i.content_type = 'glossary_term'
    and i.live_revision = gt.revision_id
    and publish_date > current_timestamp - interval '1 day'
    and acs_permission__permission_p(i.item_id, :user_id, 'read') = 't'
    order by term

      </querytext>
</fullquery>

 
</queryset>
