<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_glossary_workflow_1">      
      <querytext>
      
	select workflow_key from glossariesx
	where item_id = :glossary_item_id
	and revision_id = content_item.get_live_revision(:glossary_item_id)
    
      </querytext>
</fullquery>

 
<fullquery name="get_glossary_workflow_2">      
      <querytext>

	select workflow_key 
	from glossariesx g, cr_child_rels ch
	where g.item_id = ch.parent_id
	and ch.child_id = :item_id
	and revision_id = content_item.get_live_revision(g.item_id)
    
      </querytext>
</fullquery>

 
<fullquery name="term_select">      
      <querytext>
      
	select term, definition, publish_status,
	live_revision, latest_revision, name, mime_type,
	decode(acs_permission.permission_p(item_id,
	:user_id,
	'glossary_term_add_illustration'),
	't', 1,
	'f', 0) as illustration_add_p
	from glossary_terms_latest
	where item_id = :item_id
    
      </querytext>
</fullquery>

 
<fullquery name="get_next_revision_id">      
      <querytext>
      
	    select acs_object_id_seq.nextval from dual
	
      </querytext>
</fullquery>

 
<fullquery name="term_definition_update_1">      
      <querytext>
      
		    update cr_revisions
		    set content = empty_blob()
		    where revision_id = :revision_id
		    returning content into :1
		
      </querytext>
</fullquery>

 
<fullquery name="term_new_content_item">      
      <querytext>
      
		begin
		:1 := content_item.new (
		name => :name,
		content_type => 'glossary_term',
                context_id => :glossary_item_id,
                creation_user => :user_id,
                creation_ip => :peeraddr
		);
		end;
	    
      </querytext>
</fullquery>

 
<fullquery name="term_new_content_revision_1">      
      <querytext>
      
	       begin
	       :1 := content_revision.new(
	       item_id => :new_item_id,
	       title => :term,
	       creation_user => :user_id,
	       creation_ip => :peeraddr
	       );
		end;
	    
      </querytext>
</fullquery>

 
<fullquery name="term_definition_update_1">      
      <querytext>
      
		    update cr_revisions
		    set content = empty_blob()
		    where revision_id = :new_revision_id
		    returning content into :1
		
      </querytext>
</fullquery>

 
<fullquery name="term_new_content_revision_2">      
      <querytext>
      
		begin
		:1 := acs_object.new(
		object_type	=> 'cr_item_child_rel',
		context_id	=> :glossary_item_id
		);
		end;
	    
      </querytext>
</fullquery>

 
</queryset>
