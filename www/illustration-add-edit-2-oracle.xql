<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_next_revision_id">      
      <querytext>
      
	select acs_object_id_seq.nextval from dual
    
      </querytext>
</fullquery>

 
<fullquery name="image_blob_update_1">      
      <querytext>
      
	       update cr_revisions
	       set mime_type = :mime_type,
	       content = empty_blob()
	       where revision_id = :revision_id
	       returning content into :1
	   
      </querytext>
</fullquery>

 
<fullquery name="new_term_illustration_item">      
      <querytext>
      
	    begin
	    :1 := content_item.new (
	    name => :name,
	    content_type => 'image',
	    context_id => :term_item_id,
	    creation_user => :user_id,
	    creation_ip => :peeraddr
	    );
	    end;
	
      </querytext>
</fullquery>

 
<fullquery name="term_new_content_revision">      
      <querytext>
      
	    begin
	    :1 := content_revision.new(
	    item_id => :new_item_id,
	    title => :title,
	    description => :description,
	    creation_user => :user_id,
	    creation_ip => :peeraddr
	    );
	    end;
	
      </querytext>
</fullquery>

 
<fullquery name="image_blob_update_2">      
      <querytext>
      
        update cr_revisions
        set mime_type = :mime_type,
        content = empty_blob()
        where revision_id = :new_revision_id
        returning content into :1
	   
      </querytext>
</fullquery>

 
<fullquery name="term_new_content_revision">      
      <querytext>
      
	    begin
	    :1 := content_revision.new(
	    item_id => :new_item_id,
	    title => :title,
	    description => :description,
	    creation_user => :user_id,
	    creation_ip => :peeraddr
	    );
	    end;
	
      </querytext>
</fullquery>

 
</queryset>
