<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="output_illustration">      
      <querytext>

      select r.content, i.storage_type
      from cr_revisions r, cr_items i
      where revision_id = $revision_id and i.item_id = r.item_id

      </querytext>
</fullquery>

 
</queryset>
