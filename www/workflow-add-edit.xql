<?xml version="1.0"?>
<queryset>

<fullquery name="get_workflow_process">      
      <querytext>
      
	select wf.workflow_key as possible_workflow_key, 
	wf.description as possible_description, pretty_name as possible_workflow_name
	from wf_workflows wf, acs_object_types ot
	where workflow_key like '%term%' 
	and wf.workflow_key = ot.object_type
    
      </querytext>
</fullquery>

 
<fullquery name="glossary_workflow_update">      
      <querytext>
      
	update glossaries
	set workflow_key = :new_workflow_key
	where glossary_id = :revision_id
    
      </querytext>
</fullquery>

 
</queryset>
