<?xml version="1.0"?>
<queryset>

<fullquery name="illustration_update">      
      <querytext>
      
	   insert into imagesi (
	   item_id, revision_id, title, description, context_id, 
	   creation_user, creation_ip
	   ) values (
	   :item_id, :revision_id,:title, :description,
	   :term_item_id, :user_id, :peeraddr
	   )
       
      </querytext>
</fullquery>

 
<fullquery name="set_revision_live_1">      
      <querytext>
      
	       update images
	       set width =:original_width,
	       height = :original_height
	       where image_id = :revision_id
	   
      </querytext>
</fullquery>

 
<fullquery name="set_revision_live_2">      
      <querytext>
      
	   update cr_items
	   set live_revision = :revision_id,
	   name = :name,
	   publish_status = 'live'
	   where item_id = :item_id
	   
      </querytext>
</fullquery>

 
<fullquery name="term_insert">      
      <querytext>
      
	     insert into images(
	     image_id
	     ) values (
	     :new_revision_id
	     )
	 
      </querytext>
</fullquery>

 
<fullquery name="set_revision_live_3">      
      <querytext>
      
        update images
        set width =:original_width,
        height = :original_height
        where image_id = :new_revision_id
	   
      </querytext>
</fullquery>
 
<fullquery name="set_revision_live_4">      
      <querytext>
      
	update cr_items
	set live_revision = :new_revision_id,
	name = :name, 
	publish_status = 'live'
	where item_id = :new_item_id
	   
      </querytext>
</fullquery>

 
<fullquery name="set_parent_glossary">      
      <querytext>
      
	     insert into cr_child_rels (
	     rel_id, parent_id, child_id, relation_tag
	     ) values (
	     :rel_id, :term_item_id, :new_item_id, 'illustration'
	     )
	 
      </querytext>
</fullquery>

 
</queryset>
