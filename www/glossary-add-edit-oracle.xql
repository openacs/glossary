<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="glossary_workflow_info">      
      <querytext>
      
	select g.workflow_key, wf.description as workflow_description, pretty_name as workflow_name
	from glossariesx g, wf_workflows wf, acs_object_types ot
	where g.workflow_key = wf.workflow_key
	and wf.workflow_key = ot.object_type
	and g.item_id = :item_id
        and g.revision_id = content_item.get_live_revision(:item_id)

      </querytext>
</fullquery>

<fullquery name="get_pending_terms_p">      
      <querytext>
      
	select case when count(*) = 0 then 0 else 1 end
	from glossary_termsx
	where ( acs_permission.permission_p(item_id, :user_id, 'glossary_term_modify') = 't' or acs_permission.permission_p(item_id, :user_id, 'glossary_term_illustration_add') = 't' or acs_permission.permission_p(item_id, :user_id, 'glossary_term_illustration_modify') = 't')
    
      </querytext>
</fullquery>

 
<fullquery name="glossary_select">      
      <querytext>
      
	select g.title, i.name, g.description, g.owner_id,  i.publish_status,
	decode(acs_permission.permission_p(i.item_id,
	:user_id,
	'glossary_admin'),
	't', 1,
	'f', 0) as glossary_admin_p
	from glossariesx g, cr_items i
	where i.item_id = :item_id
	and i.publish_status = 'live'
	and i.content_type = 'glossary'
	and i.live_revision = g.revision_id
    
      </querytext>
</fullquery>

 
<fullquery name="get_next_revision_id">      
      <querytext>
      
	    select acs_object_id_seq.nextval from dual
	
      </querytext>
</fullquery>

 
<fullquery name="new_glossary">      
      <querytext>
      
	    begin
	    :1 := glossary.new (
	    owner_id => :owner_id,
	    title => :title,
            description => :description,
	    package_id => :package_id,
	    creation_user => :user_id,
	    creation_ip => :peeraddr,
	    context_id => :context_id,
	    is_live => :is_live
	    );
	    acs_permission.grant_permission(:1,:owner_id, 'glossary_admin');
	    end;
	
      </querytext>
</fullquery>

 
</queryset>
