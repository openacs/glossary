<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_glossary_workflow_1">      
      <querytext>
      
	select workflow_key from glossariesx
	where item_id = :glossary_item_id
	and revision_id = content_item__get_live_revision(:glossary_item_id)
    
      </querytext>
</fullquery>

 
<fullquery name="get_glossary_workflow_2">      
      <querytext>

	select workflow_key 
	from glossariesx g, cr_child_rels ch
	where g.item_id = ch.parent_id
	and ch.child_id = :item_id
	and revision_id = content_item__get_live_revision(g.item_id)
    
      </querytext>
</fullquery>

 
<fullquery name="term_select">      
      <querytext>

	select term, definition, publish_status,
	live_revision, latest_revision, name, mime_type,
	case acs_permission__permission_p(item_id, :user_id, 'glossary_term_add_illustration')
	  when 't' then 1
	  when 'f' then 0
        end as illustration_add_p
	from glossary_terms_latest
	where item_id = :item_id
    
      </querytext>
</fullquery>

 
<fullquery name="get_next_revision_id">      
      <querytext>
      
	    select acs_object_id_seq.nextval 
	
      </querytext>
</fullquery>

 
<fullquery name="term_definition_update_1">      
      <querytext>

         update cr_revisions
         set content = :definition
         where revision_id = :revision_id
		
      </querytext>
</fullquery>

<fullquery name="new_glossary_term">
      <querytext>

	 select glossary_term__new (
           :term,
           :definition,
           :mime_type,
           :package_id,
           :user_id,
           :peeraddr,
           :glossary_item_id,
           :publish_status
	 );
	
      </querytext>
</fullquery>
 
</queryset>
