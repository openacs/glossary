<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="glossary_term_item_select">      
      <querytext>

    select term, definition,
    revision_id, item_id, name, mime_type,
    case acs_permission__permission_p(item_id, :user_id, 'glossary_term_modify')
      when 't' then 1
      when 'f' then 0
    end as term_modify_p
    from glossary_terms_live_definition
    where item_id = :item_id

      </querytext>
</fullquery>

 
<fullquery name="get_glossary_title">      
      <querytext>
      
select title from glossariesx
where revision_id = content_item__get_live_revision(:glossary_item_id)

      </querytext>
</fullquery>

 
</queryset>
