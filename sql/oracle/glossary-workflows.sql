-- glossary/sql/glossary-workflows.sql
-- walter@arsdigita.com, 11-26-2000

-- load some default workflows for the glossary package
-- each glossary decides on a workflow

-- create the full term publishing process workflow
-- the alternative is a simple workflow (i.e. submit -> approve)


create table full_term_publish_proces_cases (
  case_id               integer primary key
  			constraint full_term_publish_proc_case_fk
  			references wf_cases on delete cascade
);

declare
 v_workflow_key varchar(40);
begin
 v_workflow_key := workflow.create_workflow(
 workflow_key => 'full_term_publish_process_wf',
 pretty_name => 'Full Term Publish Process', 
 pretty_plural => 'Full Term Publish Processes', 
 description => 'Fairly sophisticatd standard glossary term publishing.  Publisher or Editor create a term.  Author writes definition.  Editor edits definition.  Graphic designer adds and illustration.  Editor or publisher approve or reject new term.',
 table_name => 'full_term_publish_proces_cases'
 );
end;
/
show errors

begin
insert into wf_places (
place_key, workflow_key, place_name, sort_order
) values (
'start', 'full_term_publish_process_wf', 'Ready to Author Definition.', 1
);

insert into wf_places (
place_key, workflow_key, place_name, sort_order
) values (
'before_edit_definiton', 'full_term_publish_process_wf', 'Ready to Edit Definiton', 2
);

insert into wf_places (
place_key, workflow_key, place_name, sort_order
) values (
'before_add_illustration', 'full_term_publish_process_wf', 'Ready to Add Illustration', 3
);

insert into wf_places (
place_key, workflow_key, place_name, sort_order
) values (
'before_approve_new_term', 'full_term_publish_process_wf', 'Ready to Approve New Term', 4
);

insert into wf_places (
place_key, workflow_key, place_name, sort_order
) values (
'end', 'full_term_publish_process_wf', 'Process finished', 5
);
end;
/
show errors

begin
insert into wf_transitions (
transition_key, transition_name, workflow_key, sort_order, trigger_type
) values (
'author_definition', 'Author Definition.', 'full_term_publish_process_wf', 1, 'user'
);

insert into wf_transitions (
transition_key, transition_name, workflow_key, sort_order, trigger_type
) values (
'edit_definiton', 'Edit Definiton', 'full_term_publish_process_wf', 2, 'user'
);

insert into wf_transitions (
transition_key, transition_name, workflow_key, sort_order, trigger_type
) values (
'add_illustration', 'Add Illustration', 'full_term_publish_process_wf', 3, 'user'
);

insert into wf_transitions (
transition_key, transition_name, workflow_key, sort_order, trigger_type
) values (
'approve_new_term', 'Approve New Term', 'full_term_publish_process_wf', 4, 'user'
);
end;
/
show errors

begin
insert into wf_arcs (
workflow_key, transition_key, place_key, direction
) values (
'full_term_publish_process_wf', 'author_definition', 'start', 'in'
);

insert into wf_arcs (
workflow_key, transition_key, place_key, direction
) values (
'full_term_publish_process_wf', 'author_definition', 
'before_edit_definiton', 'out'
);
	
insert into wf_arcs (
workflow_key, transition_key, place_key, direction
) values (
'full_term_publish_process_wf', 'edit_definiton', 
'before_edit_definiton', 'in'
);

insert into wf_arcs (
workflow_key, transition_key, place_key, direction, guard_callback, guard_description
) values (
'full_term_publish_process_wf', 'edit_definiton', 
'start', 'out', '#', 'Not Is definition correct'
);

insert into wf_arcs (
workflow_key, transition_key, place_key, direction, 
guard_callback, guard_custom_arg, guard_description
) values (
'full_term_publish_process_wf', 'edit_definiton', 'before_add_illustration', 'out', 
'wf_callback.guard_attribute_true', 'edit_definiton_is_definition_correct_p', 'Is definition correct'
);

insert into wf_arcs (
workflow_key, transition_key, place_key, direction
) values (
'full_term_publish_process_wf', 'add_illustration', 
'before_add_illustration', 'in'
);

insert into wf_arcs (
workflow_key, transition_key, place_key, direction
) values (
'full_term_publish_process_wf', 'add_illustration', 
'before_approve_new_term', 'out'
);

insert into wf_arcs (
workflow_key, transition_key, place_key, direction
) values (
'full_term_publish_process_wf', 'approve_new_term', 
'before_approve_new_term', 'in'
);

insert into wf_arcs (
workflow_key, transition_key, place_key, direction, guard_callback, guard_description
) values (
'full_term_publish_process_wf', 'approve_new_term', 
'before_edit_definiton', 'out', '#', 'Not Approved'
);

insert into wf_arcs (
workflow_key, transition_key, place_key, direction, 
guard_callback, guard_custom_arg, guard_description
) values (
'full_term_publish_process_wf', 'approve_new_term', 'end', 'out', 
'wf_callback.guard_attribute_true', 'approve_new_term_approved_p', 'Approved'
);
end;
/
show errors

declare
 v_attribute_id acs_attributes.attribute_id%TYPE;
begin
 v_attribute_id := workflow.create_attribute(
 workflow_key => 'full_term_publish_process_wf',
 attribute_name => 'edit_definiton_is_definition_correct_p', 
 datatype => 'boolean',
 pretty_name => 'Is definition correct',
 default_value => 't'
 );
	    
 insert into wf_transition_attribute_map (
 workflow_key, transition_key, attribute_id, sort_order
 ) values (
 'full_term_publish_process_wf', 'edit_definiton', v_attribute_id, 1);
end;
/
show errors

declare
 v_attribute_id acs_attributes.attribute_id%TYPE;
begin
 v_attribute_id := workflow.create_attribute(
 workflow_key => 'full_term_publish_process_wf',
 attribute_name => 'approve_new_term_approved_p',
 datatype => 'boolean',
 pretty_name => 'Approved',
 default_value => 't'
 );
	    
 insert into wf_transition_attribute_map (
 workflow_key, transition_key, attribute_id, sort_order
 ) values (
 'full_term_publish_process_wf', 'approve_new_term', v_attribute_id, 1
 );
end;	
/
show errors

begin
insert into wf_transition_assignment_map (
workflow_key, transition_key, assign_transition_key
) values (
'full_term_publish_process_wf', 'edit_definiton', 'add_illustration'
);

insert into wf_context_transition_info (
context_key, workflow_key, transition_key, estimated_minutes
) values (
'default', 'full_term_publish_process_wf', 'author_definition', 60
);

insert into wf_context_transition_info (
context_key, workflow_key, transition_key, estimated_minutes
) values (
'default', 'full_term_publish_process_wf', 'edit_definiton', 20
);

insert into wf_context_transition_info (
context_key, workflow_key, transition_key, estimated_minutes
) values (
'default', 'full_term_publish_process_wf', 'add_illustration', 120
);

insert into wf_context_transition_info (
context_key, workflow_key, transition_key, estimated_minutes
) values (
'default', 'full_term_publish_process_wf', 'approve_new_term', 10
);
end;
/
show errors

-- simple term submission process

create table term_submission_process_cases (
  case_id             integer primary key
                      constraint term_submission_proces_case_fk
                      references wf_cases on delete cascade
);

declare
 v_workflow_key varchar(40);
begin
 v_workflow_key := workflow.create_workflow(
 workflow_key => 'term_submission_process_wf',
 pretty_name => 'Term Submission Process', 
 pretty_plural => 'Term Submission Processes', 
 description => 'User submits new term and its definition (and maybe illustration).  Administrator approves or rejects submission.',
 table_name => 'term_submission_process_cases'
 );
end;
/
show errors

begin
 insert into wf_places (
 place_key, workflow_key, place_name, sort_order
 ) values (
 'start', 'term_submission_process_wf', 'Ready to Approve', 1
 );

 insert into wf_places ( 
 place_key, workflow_key, place_name, sort_order
 ) values (
 'end', 'term_submission_process_wf', 'Process finished', 2
 );

 insert into wf_transitions (
 transition_key, transition_name, workflow_key, sort_order, trigger_type
 ) values (
 'approve', 'Approve', 'term_submission_process_wf', 1, 'user'
 );
 
 insert into wf_arcs (
 workflow_key, transition_key, place_key, direction
 ) values (
 'term_submission_process_wf', 'approve', 'start', 'in'
 );

 insert into wf_arcs (
 workflow_key, transition_key, place_key, direction
 ) values (
 'term_submission_process_wf', 'approve', 'end', 'out'
 );

 insert into wf_context_transition_info (
 context_key, workflow_key, transition_key, estimated_minutes
 ) values (
 'default', 'term_submission_process_wf', 'approve', 10
 );
end;
/
show errors

-- this is a special case inorder to maintain
-- constraint integrity
-- has the disadvantage, that is shows up on the workflow pages
-- when it is really just a deadend
-- oh well

create table term_go_live_process_cases (
  case_id             integer primary key
                      constraint term_go_live_proces_case_fk
                      references wf_cases on delete cascade
);

declare
 v_workflow_key varchar(40);
begin
 v_workflow_key := workflow.create_workflow(
 workflow_key => 'term_go_live_wf',
 pretty_name => 'Term Go Live Process', 
 pretty_plural => 'Term Go Live Processes', 
 description => 'User submits new term and its definition (and maybe illustration) and it goes live immediately.',
 table_name => 'term_go_live_process_cases'
 );
end;
/
show errors


