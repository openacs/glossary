
/*
 * Business Process Definition: Term Submission Process (term_submission_process_wf)
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


create function inline_0 () returns integer as '
begin
    PERFORM workflow__create_workflow (
        ''term_submission_process_wf'', 
        ''Term Submission Process'', 
        ''Term Submission Processes'', 
        ''User submits new term and its definition (and maybe illustration).  Administrator approves or rejects submission.'', 
        ''term_submission_process_cases'',
        ''case_id''
    );

    return null;

end;' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();

        


/*****
 * Places
 *****/


    select workflow__add_place(
        'term_submission_process_wf',
        'start', 
        'Ready to Approve', 
        1
    );

        

    select workflow__add_place(
        'term_submission_process_wf',
        'end', 
        'Process finished', 
        2
    );

        
/*****
 * Roles
 *****/



	select workflow__add_role (
         'term_submission_process_wf',
         'approve',
         'Approve',
         1
    );

        

/*****
 * Transitions
 *****/



	select workflow__add_transition (
         'term_submission_process_wf',
         'approve',
         'Approve',
         'approve',
         1,
         'user'
	);
	
        

/*****
 * Arcs
 *****/



	select workflow__add_arc (
         'term_submission_process_wf',
         'approve',
         'end',
         'out',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'term_submission_process_wf',
         'approve',
         'start',
         'in',
         '',
         '',
         ''
	);

        

/*****
 * Attributes
 *****/


/*****
 * Transition-role-assignment-map
 *****/



/*
 * Context/Transition info
 * (for context = default)
 */

insert into wf_context_transition_info
(context_key,
 workflow_key,
 transition_key,
 estimated_minutes,
 instructions,
 enable_callback,
 enable_custom_arg,
 fire_callback,
 fire_custom_arg,
 time_callback,
 time_custom_arg,
 deadline_callback,
 deadline_custom_arg,
 deadline_attribute_name,
 hold_timeout_callback,
 hold_timeout_custom_arg,
 notification_callback,
 notification_custom_arg,
 unassigned_callback,
 unassigned_custom_arg)
values
('default',
 'term_submission_process_wf',
 'approve',
 10,
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '',
 '');



/*
 * Context/Role info
 * (for context = default)
 */



/*
 * Context Task Panels
 * (for context = default)
 */


commit;
