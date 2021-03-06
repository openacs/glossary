
/*
 * Business Process Definition: Simple Publishing Workflow (term_submission_process_wf)
 *
 * Auto-generated by ACS Workflow Export, version 4.3
 *
 * Context: default
 */


/*
 * Cases table
 */
create table term_submission_process_cases (
  case_id               integer primary key
                        references wf_cases on delete cascade
);

/* 
 * Declare the object type
 */

declare
    v_workflow_key varchar2(40);
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

        


/*****
 * Places
 *****/

begin
    workflow.add_place(
        workflow_key => 'term_submission_process_wf',
        place_key    => 'start', 
        place_name   => 'Created', 
        sort_order   => 1
    );
end;
/
show errors 
        
begin
    workflow.add_place(
        workflow_key => 'term_submission_process_wf',
        place_key    => 'authored', 
        place_name   => 'Authored', 
        sort_order   => 2
    );
end;
/
show errors 
        
begin
    workflow.add_place(
        workflow_key => 'term_submission_process_wf',
        place_key    => 'edited', 
        place_name   => 'Edited', 
        sort_order   => 3
    );
end;
/
show errors 
        
begin
    workflow.add_place(
        workflow_key => 'term_submission_process_wf',
        place_key    => 'end', 
        place_name   => 'Approved', 
        sort_order   => 4
    );
end;
/
show errors 
        
/*****
 * Roles
 *****/


begin
    workflow.add_role(
        workflow_key => 'term_submission_process_wf',
        role_key     => 'approval',
        role_name    => 'Approval',
        sort_order   => 3
    );
end;
/
show errors
        
begin
    workflow.add_role(
        workflow_key => 'term_submission_process_wf',
        role_key     => 'authoring',
        role_name    => 'Authoring',
        sort_order   => 1
    );
end;
/
show errors
        
begin
    workflow.add_role(
        workflow_key => 'term_submission_process_wf',
        role_key     => 'editing',
        role_name    => 'Editing',
        sort_order   => 2
    );
end;
/
show errors
        

/*****
 * Transitions
 *****/


begin
    workflow.add_transition(
        workflow_key    => 'term_submission_process_wf',
        transition_key  => 'authoring',
        transition_name => 'Authoring',
        role_key        => 'authoring',
        sort_order      => 1,
        trigger_type    => 'user'
    );
end;
/
show errors
        
begin
    workflow.add_transition(
        workflow_key    => 'term_submission_process_wf',
        transition_key  => 'editing',
        transition_name => 'Editing',
        role_key        => 'editing',
        sort_order      => 2,
        trigger_type    => 'user'
    );
end;
/
show errors
        
begin
    workflow.add_transition(
        workflow_key    => 'term_submission_process_wf',
        transition_key  => 'approval',
        transition_name => 'Approval',
        role_key        => 'approval',
        sort_order      => 3,
        trigger_type    => 'user'
    );
end;
/
show errors
        

/*****
 * Arcs
 *****/


begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'approval',
        place_key             => 'authored',
        direction             => 'out',
        guard_callback        => 'term_submission_process_wf.is_next',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        
begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'approval',
        place_key             => 'edited',
        direction             => 'in',
        guard_callback        => '',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        
begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'approval',
        place_key             => 'end',
        direction             => 'out',
        guard_callback        => 'term_submission_process_wf.is_next',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        
begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'approval',
        place_key             => 'start',
        direction             => 'out',
        guard_callback        => 'term_submission_process_wf.is_next',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        
begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'approval',
        place_key             => 'edited',
        direction             => 'out',
        guard_callback        => '#',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        
begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'authoring',
        place_key             => 'authored',
        direction             => 'out',
        guard_callback        => 'term_submission_process_wf.is_next',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        
begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'authoring',
        place_key             => 'start',
        direction             => 'out',
        guard_callback        => '#',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        
begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'authoring',
        place_key             => 'start',
        direction             => 'in',
        guard_callback        => '',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        
begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'editing',
        place_key             => 'authored',
        direction             => 'in',
        guard_callback        => '',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        
begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'editing',
        place_key             => 'edited',
        direction             => 'out',
        guard_callback        => 'term_submission_process_wf.is_next',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        
begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'editing',
        place_key             => 'start',
        direction             => 'out',
        guard_callback        => 'term_submission_process_wf.is_next',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        
begin
    workflow.add_arc(
        workflow_key          => 'term_submission_process_wf',
        transition_key        => 'editing',
        place_key             => 'authored',
        direction             => 'out',
        guard_callback        => '#',
        guard_custom_arg      => '',
        guard_description     => ''
    );
end;
/
show errors
        

/*****
 * Attributes
 *****/


declare
    v_attribute_id number;
begin
    v_attribute_id := workflow.create_attribute(
        workflow_key => 'term_submission_process_wf',
        attribute_name => 'next_place',
        datatype => 'string',
        pretty_name => 'Next Place',
        default_value => 'start'
    );
end;
/
show errors
        
begin
    workflow.add_trans_attribute_map(
        workflow_key   => 'term_submission_process_wf', 
        transition_key => 'approval',
        attribute_name => 'next_place',
        sort_order     => 1
    );
end;
/
show errors
        
begin
    workflow.add_trans_attribute_map(
        workflow_key   => 'term_submission_process_wf', 
        transition_key => 'authoring',
        attribute_name => 'next_place',
        sort_order     => 1
    );
end;
/
show errors
        
begin
    workflow.add_trans_attribute_map(
        workflow_key   => 'term_submission_process_wf', 
        transition_key => 'editing',
        attribute_name => 'next_place',
        sort_order     => 1
    );
end;
/
show errors
        
/*****
 * Transition-role-assignment-map
 *****/



/*
 * Context/Transition info
 * (for context = default)
 */



/*
 * Context/Role info
 * (for context = default)
 */



/*
 * Context Task Panels
 * (for context = default)
 */


commit;

