<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_next_revision_id">      
      <querytext>
      
	select acs_object_id_seq.nextval 
    
      </querytext>
</fullquery>

<fullquery name="image_blob_update_1">      
      <querytext>

	       update cr_revisions
	       set mime_type = :mime_type,
 	       lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
	       where revision_id = :revision_id
	   
      </querytext>
</fullquery>
 
<fullquery name="image_blob_size_1">      
      <querytext>

         update cr_revisions
         set content_length = lob_length(lob)
         where revision_id = :revision_id

      </querytext>
</fullquery>

 
<fullquery name="new_term_illustration_item">      
      <querytext>

        select content_item__new (
		varchar :name,
                NULL,
                NULL,
                NULL,
                current_timestamp,
                :user_id,
                :term_item_id,
                :peeraddr,
                'content_item',
                'image',
                NULL,
                NULL,
                NULL,
                NULL,
                NULL
        );
	
      </querytext>
</fullquery>

 
<fullquery name="term_new_content_revision_1">      
      <querytext>

           select content_revision__new(
               :title,
               :description,
               current_timestamp,
               NULL,
               NULL,
               NULL,
               :new_item_id,
               NULL,
               current_timestamp,
               :user_id,
               :peeraddr
           );

      </querytext>
</fullquery>

 
<fullquery name="image_blob_update_2">      
      <querytext>

		 update cr_revisions
		 set mime_type = :mime_type,
 	         lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
		 where revision_id = :new_revision_id
	   
      </querytext>
</fullquery>
 
<fullquery name="image_blob_size_2">      
      <querytext>

         update cr_revisions
         set content_length = lob_length(lob)
         where revision_id = :new_revision_id

      </querytext>
</fullquery>

 
<fullquery name="term_new_content_revision_2">      
      <querytext>

         select acs_object__new(
            NULL,
            'cr_item_child_rel',
            current_timestamp,
            NULL,
            NULL,
            :term_item_id
	 );
	
      </querytext>
</fullquery>

 
</queryset>
