<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_pending_terms_p">      
      <querytext>
      
	select case when count(*) = 0 then 0 else 1 end
	from glossary_termsx
	where ( acs_permission__permission_p(item_id, :user_id, 'glossary_term_modify') = 't' or acs_permission__permission_p(item_id, :user_id, 'glossary_term_illustration_add') = 't' or acs_permission__permission_p(item_id, :user_id, 'glossary_term_illustration_modify') = 't')
    
      </querytext>
</fullquery>

 
<fullquery name="glossary_select">      
      <querytext>

	select g.title, i.name, g.description, g.owner_id,  i.publish_status,
	case acs_permission__permission_p(i.item_id, :user_id, 'glossary_admin')
	  when 't' then 1
	  when 'f' then 0
        end as glossary_admin_p
	from glossariesx g, cr_items i
	where i.item_id = :item_id
	and i.publish_status = 'live'
	and i.content_type = 'glossary'
	and i.live_revision = g.revision_id
    
      </querytext>
</fullquery>

 
<fullquery name="get_next_revision_id">      
      <querytext>
      
	    select acs_object_id_seq.nextval 
	
      </querytext>
</fullquery>

 
<fullquery name="new_glossary">      
      <querytext>

	 select glossary__new (
           :owner_id,
           :name,
           :title,
           :description,
           :package_id,
           :user_id,
           :peeraddr,
           :context_id,
           :is_live,
           'glossary_admin'
	 );
	
      </querytext>
</fullquery>

 
</queryset>
