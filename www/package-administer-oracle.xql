<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="glossary_items_select">      
      <querytext>
      
    select i.item_id, title, party.name(owner_id) as owner_name, publish_date, publish_status, live_revision
    from glossariesx g, cr_items i
    where i.content_type = 'glossary'
    and i.item_id = g.item_id
    and acs_permission.permission_p(i.item_id, :user_id, 'glossary_admin') = 't'
    and g.package_id = :package_id
    and g.revision_id = content_item.get_latest_revision(i.item_id)
    order by title

      </querytext>
</fullquery>

 
</queryset>
