<?xml version="1.0"?>
<queryset>

<fullquery name="get_item_id">      
      <querytext>
      select mime_type
from cr_revisions 
where revision_id = :revision_id
      </querytext>
</fullquery>

 
</queryset>
