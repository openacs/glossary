<?xml version="1.0"?>
<queryset>

<fullquery name="illuststration_exists">      
      <querytext>
      
	select child_id as illustration_item_id from cr_child_rels 
	where relation_tag = 'illustration' and parent_id = :item_id
      </querytext>
</fullquery>

 
<fullquery name="get_parent_glossary_item_id">      
      <querytext>
      
	select parent_id from cr_child_rels 
	where child_id = :item_id and relation_tag = 'parent glossary'
      </querytext>
</fullquery>

 
<fullquery name="term_update">      
      <querytext>
      
		insert into glossary_termsi (
		item_id, revision_id, title, context_id, 
		creation_user, creation_ip, mime_type
		) values (
		:item_id, :revision_id, 
		:term, :glossary_item_id, :user_id, :peeraddr, :mime_type
		)
	    
      </querytext>
</fullquery>

 
<fullquery name="set_revision_live_1">      
      <querytext>
      
	        update cr_items
		set live_revision = :revision_id,
		name = :name,
		publish_status = :publish_status
		where item_id = :item_id
	    
      </querytext>
</fullquery>

 
<fullquery name="term_insert">      
      <querytext>
      
		insert into glossary_terms (
		term_id
		) values (
		:new_revision_id
		)
	    
      </querytext>
</fullquery>

 
<fullquery name="set_revision_live_2">      
      <querytext>
      
	        update cr_items
		set live_revision = :new_revision_id,
		name = :name,
		publish_status = :publish_status
		where item_id = :new_item_id
	    
      </querytext>
</fullquery>

 
<fullquery name="set_parent_glossary">      
      <querytext>
      
		insert into cr_child_rels (
		rel_id, parent_id, child_id, relation_tag
		) values (
		:rel_id, :glossary_item_id, :new_item_id, 'parent glossary'
		)
	    
      </querytext>
</fullquery>

 
</queryset>
