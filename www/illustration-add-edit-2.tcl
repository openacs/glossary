# glossary/www/illustration-add-edit-2.tcl

ad_page_contract {
    dml for uploading or editing illustration, this file should go away in future versions, when ats forms are more fully functional
    
    @param term_item_id item_id of term
    @param item_id illustration's item_id
    @param title of illustration
    @param name used for urls in content-repository, stored in cr_items
    @param description of illustration
    @param upload_file of blob

    @author Walter McGinnis (walter@arsdigita.com)
    @creation-date 11-21-2000
    @cvs-id $Id$
} {
    item_id:optional,integer
    term_item_id:integer
    title:optional,trim
    name:optional,trim
    description:optional,trim
    upload_file:optional
}
set package_id [ad_conn package_id]

set user_id [ad_conn user_id]

if {[info exists item_id]} {
         ad_require_permission $item_id glossary_term_modify_illustration
} else {
         ad_require_permission $package_id glossary_term_add_illustration
}

set peeraddr [ad_conn peeraddr]

if [info exists item_id] {
    set revision_id [db_string get_next_revision_id {
	select acs_object_id_seq.nextval from dual
    }]

   db_transaction {
       db_dml illustration_update {
	   insert into imagesi (
	   item_id, revision_id, title, desciption, context_id, 
	   creation_user, creation_ip
	   ) values (
	   :item_id, :revision_id,:title, :description,
	   :term_item_id, :user_id, :peeraddr
	   )
       }
	    
       # upload the new image
       if {[info exists upload_file] && ![empty_string_p $upload_file] } {

	   set tmp_filename [ns_queryget upload_file.tmpfile]

	   set file_extension [string tolower [file extension $upload_file]]
	   # remove the first . from the file extension
	   regsub "\." $file_extension "" file_extension

	   set guessed_file_type [ns_guesstype $upload_file]

	   set mime_type $guessed_file_type

	   set what_aolserver_told_us ""
	   if { $file_extension == "jpeg" || $file_extension == "jpg" } {
	       catch { set what_aolserver_told_us [ns_jpegsize $tmp_filename] }
	   } elseif { $file_extension == "gif" } {
	       catch { set what_aolserver_told_us [ns_gifsize $tmp_filename] }
	   }

	   # the AOLserver jpegsize command has some bugs where the height comes 
	   # through as 1 or 2 
	   if { ![empty_string_p $what_aolserver_told_us] && [lindex $what_aolserver_told_us 0] > 10 && [lindex $what_aolserver_told_us 1] > 10 } {
	       set original_width [lindex $what_aolserver_told_us 0]
	       set original_height [lindex $what_aolserver_told_us 1]
	   } else {
	       set original_width ""
	       set original_height ""
	   }

	   # note that this is bad because it doesn't ensure that
	   # text is stored in the db as UTF-8.

	   db_dml image_blob_update_1 {
	       update cr_revisions
	       set mime_type = :mime_type,
	       content = empty_blob()
	       where revision_id = :revision_id
	       returning content into :1
	   } -blob_files [list $tmp_filename]
 
           db_dml image_blob_size_1 ""

	   # update the images with the file details
	   db_dml set_revision_live_1 {
	       update images
	       set width =:original_width,
	       height = :original_height
	       where image_id = :revision_id
	   }
       }

       # for right now we are setting things live right away
       # later this may be dependant on workflow
       db_dml set_revision_live_2 {
	   update cr_items
	   set live_revision = :revision_id,
	   name = :name,
	   publish_status = 'live'
	   where item_id = :item_id
       }
   }
} else {
    db_transaction {
	# insert a new content_item
	set new_item_id [db_exec_plsql new_term_illustration_item {
	    begin
	    :1 := content_item.new (
	    name => :name,
	    content_type => 'image',
	    context_id => :term_item_id,
	    creation_user => :user_id,
	    creation_ip => :peeraddr
	    );
	    end;
	}]
	    
        set new_revision_id [db_exec_plsql term_new_content_revision_1 {
	    begin
	    :1 := content_revision.new(
	    item_id => :new_item_id,
	    title => :title,
	    description => :description,
	    creation_user => :user_id,
	    creation_ip => :peeraddr
	    );
	    end;
	}]
 
	 db_dml term_insert {
	     insert into images(
	     image_id
	     ) values (
	     :new_revision_id
	     )
	 }

	 # there must be a cleaner way to handle the exception
	 # but for now we will follow portrait uploads example
	 set exception_text ""
	 set exception_count 0

	 # upload the new image
	 if {![info exists upload_file] || [empty_string_p $upload_file] } {
	     append exception_text "<li>Please specify a file to upload\n"
	     
	     incr exception_count
	 } else {
	     
	     set tmp_filename [ns_queryget upload_file.tmpfile]
	     
	     set file_extension [string tolower [file extension $upload_file]]
	     # remove the first . from the file extension
	     regsub "\." $file_extension "" file_extension
	     
	     set guessed_file_type [ns_guesstype $upload_file]
	     
	     set mime_type $guessed_file_type
	     
	     set what_aolserver_told_us ""
	     if { $file_extension == "jpeg" || $file_extension == "jpg" } {
		 catch { set what_aolserver_told_us [ns_jpegsize $tmp_filename] }
	     } elseif { $file_extension == "gif" } {
		 catch { set what_aolserver_told_us [ns_gifsize $tmp_filename] }
	     }
	     
	     # the AOLserver jpegsize command has some bugs where the height comes 
	     # through as 1 or 2 
	     if { ![empty_string_p $what_aolserver_told_us] && [lindex $what_aolserver_told_us 0] > 10 && [lindex $what_aolserver_told_us 1] > 10 } {
		 set original_width [lindex $what_aolserver_told_us 0]
		 set original_height [lindex $what_aolserver_told_us 1]
	     } else {
		 set original_width ""
		 set original_height ""
	     }

	     # note that this is bad because it doesn't ensure that
	     # text is stored in the db as UTF-8.

	     db_dml image_blob_update_2 {
		 update cr_revisions
		 set mime_type = :mime_type,
		 content = empty_blob()
		 where revision_id = :new_revision_id
		 returning content into :1
	     } -blob_files [list $tmp_filename]
 
             db_dml image_blob_size_2 ""
	    
             # update the images with the file details
             db_dml set_revision_live_3 {
		 update images
		 set width =:original_width,
		 height = :original_height
		 where image_id = :new_revision_id
	     }
	 } 
    
	 if { $exception_count > 0 } {
	     ad_return_complaint $exception_count $exception_text
	     db_abort_transaction
	     ad_script_abort
	 }

	 # for right now we are setting things live right away
	 # display of illustration is inline with term
	 # see term-add-edit.tcl for publish status handling
	 db_dml set_revision_live_4 {
	     update cr_items
	     set live_revision = :new_revision_id,
	     name = :name, 
	     publish_status = 'live'
	     where item_id = :new_item_id
	 }

	 # finally we associate the image with its parent term
	 # i.e. make it an illustration of the term
	 set rel_id [db_exec_plsql term_new_content_revision_2 {
	     begin
	     :1 := acs_object.new(
	     object_type	=> 'cr_item_child_rel',
	     context_id	=> :term_item_id
	     );
	     end;
	 }]

	 db_dml set_parent_glossary {
	     insert into cr_child_rels (
	     rel_id, parent_id, child_id, relation_tag
	     ) values (
	     :rel_id, :term_item_id, :new_item_id, 'illustration'
	     )
	 }
     }
 }
# this may break if term isn't live
# should have a conditional for redirect
ad_returnredirect "term?item_id=$term_item_id"

