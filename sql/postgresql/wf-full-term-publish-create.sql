
/*
 * Business Process Definition: Full Term Publish Process (full_term_publish_process_wf)
 *
 * Auto-generated by ACS Workflow Export, version 4.3
 *
 * Context: default
 */


/*
 * Cases table
 */
create table full_term_publish_proces_cases (
  case_id               integer primary key
                        references wf_cases on delete cascade
);

/* 
 * Declare the object type
 */


create function inline_0 () returns integer as '
begin
    PERFORM workflow__create_workflow (
        ''full_term_publish_process_wf'', 
        ''Full Term Publish Process'', 
        ''Full Term Publish Processes'', 
        ''Fairly sophisticatd standard glossary term publishing.  Publisher or Editor create a term.  Author writes definition.  Editor edits definition.  Graphic designer adds and illustration.  Editor or publisher approve or reject new term.'', 
        ''full_term_publish_proces_cases'',
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
        'full_term_publish_process_wf',
        'start', 
        'Ready to Author Definition.', 
        1
    );

        

    select workflow__add_place(
        'full_term_publish_process_wf',
        'before_edit_definiton', 
        'Ready to Edit Definiton', 
        2
    );

        

    select workflow__add_place(
        'full_term_publish_process_wf',
        'before_add_illustration', 
        'Ready to Add Illustration', 
        3
    );

        

    select workflow__add_place(
        'full_term_publish_process_wf',
        'before_approve_new_term', 
        'Ready to Approve New Term', 
        4
    );

        

    select workflow__add_place(
        'full_term_publish_process_wf',
        'end', 
        'Process finished', 
        5
    );

        
/*****
 * Roles
 *****/



	select workflow__add_role (
         'full_term_publish_process_wf',
         'add_illustration',
         'Add Illustration',
         3
    );

        

	select workflow__add_role (
         'full_term_publish_process_wf',
         'approve_new_term',
         'Approve New Term',
         4
    );

        

	select workflow__add_role (
         'full_term_publish_process_wf',
         'author_definition',
         'Author Definition.',
         1
    );

        

	select workflow__add_role (
         'full_term_publish_process_wf',
         'edit_definiton',
         'Edit Definiton',
         2
    );

        

/*****
 * Transitions
 *****/



	select workflow__add_transition (
         'full_term_publish_process_wf',
         'author_definition',
         'Author Definition.',
         'author_definition',
         1,
         'user'
	);
	
        

	select workflow__add_transition (
         'full_term_publish_process_wf',
         'edit_definiton',
         'Edit Definiton',
         'edit_definiton',
         2,
         'user'
	);
	
        

	select workflow__add_transition (
         'full_term_publish_process_wf',
         'add_illustration',
         'Add Illustration',
         'add_illustration',
         3,
         'user'
	);
	
        

	select workflow__add_transition (
         'full_term_publish_process_wf',
         'approve_new_term',
         'Approve New Term',
         'approve_new_term',
         4,
         'user'
	);
	
        

/*****
 * Arcs
 *****/



	select workflow__add_arc (
         'full_term_publish_process_wf',
         'add_illustration',
         'before_add_illustration',
         'in',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'full_term_publish_process_wf',
         'add_illustration',
         'before_approve_new_term',
         'out',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'full_term_publish_process_wf',
         'approve_new_term',
         'before_approve_new_term',
         'in',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'full_term_publish_process_wf',
         'approve_new_term',
         'before_edit_definiton',
         'out',
         '#',
         '',
         'Not Approved'
	);

        

	select workflow__add_arc (
         'full_term_publish_process_wf',
         'approve_new_term',
         'end',
         'out',
         'wf_callback__guard_attribute_true',
         'approve_new_term_approved_p',
         'Approved'
	);

        

	select workflow__add_arc (
         'full_term_publish_process_wf',
         'author_definition',
         'before_edit_definiton',
         'out',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'full_term_publish_process_wf',
         'author_definition',
         'start',
         'in',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'full_term_publish_process_wf',
         'edit_definiton',
         'before_add_illustration',
         'out',
         'wf_callback__guard_attribute_true',
         'edit_definiton_is_definition_correct_p',
         'Is definition correct'
	);

        

	select workflow__add_arc (
         'full_term_publish_process_wf',
         'edit_definiton',
         'before_edit_definiton',
         'in',
         '',
         '',
         ''
	);

        

	select workflow__add_arc (
         'full_term_publish_process_wf',
         'edit_definiton',
         'start',
         'out',
         '#',
         '',
         'Not Is definition correct'
	);

        

/*****
 * Attributes
 *****/



    select workflow__create_attribute(
        'full_term_publish_process_wf',
        'approve_new_term_approved_p',
        'boolean',
        'Approved',
	null,
	null,
	null,
        't',
	1,
	1,
	null,
	'generic'
    );

        

	select workflow__add_trans_attribute_map(
        	'full_term_publish_process_wf', 
        	'approve_new_term',
        	'approve_new_term_approved_p',
        	1
    );

        

    select workflow__create_attribute(
        'full_term_publish_process_wf',
        'edit_definiton_is_definition_correct_p',
        'boolean',
        'Is definition correct',
	null,
	null,
	null,
        't',
	1,
	1,
	null,
	'generic'
    );

        

	select workflow__add_trans_attribute_map(
        	'full_term_publish_process_wf', 
        	'edit_definiton',
        	'edit_definiton_is_definition_correct_p',
        	1
    );

        
/*****
 * Transition-role-assignment-map
 *****/



    select workflow__add_trans_role_assign_map(
        'full_term_publish_process_wf',
        'edit_definiton',
        'add_illustration'
    );

        

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
 'full_term_publish_process_wf',
 'add_illustration',
 120,
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
 'full_term_publish_process_wf',
 'approve_new_term',
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
 'full_term_publish_process_wf',
 'author_definition',
 60,
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
 'full_term_publish_process_wf',
 'edit_definiton',
 20,
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
