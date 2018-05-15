-- packages/glossary/sql/glossary-drop.sql

-- @author Walter McGinnis (walter@arsdigita.com)
-- @author Bart Teeuwisse (bart.teeuwisse@7-sisters.com)
-- @creation-date 2000-10-03
-- @cvs-id $ID:$

-- NOTE THIS SCRIPT IS PRETTY CLOSE TO COMPLETE BUT NOT QUITE
-- drop scripts have become a real pain in ACS 4.0
-- will debug for final release
-- in the meantime this is a good starting point and will get most everything
-- the main sticking point is dropping privileges

-- drop the glossary data model

select content_folder__unregister_content_type(-100, 'glossary_term', 't');
select content_folder__unregister_content_type(-100, 'glossary', 't');

drop function glossary__new(integer, varchar,  varchar, varchar, integer, integer, varchar, integer, boolean);

-- drop all grantings of privileges 
-- and then drop privileges on glossaries

select acs_privilege__remove_child('glossary_admin','glossary_create');
select acs_privilege__remove_child('glossary_admin','glossary_modify');
select acs_privilege__remove_child('glossary_admin','glossary_delete');
select acs_privilege__remove_child('glossary_admin','glossary_term_comment_read');
select acs_privilege__remove_child('glossary_admin','glossary_term_comment_on');
select acs_privilege__remove_child('glossary_admin','glossary_term_create');
select acs_privilege__remove_child('glossary_admin','glossary_term_modify');
select acs_privilege__remove_child('glossary_admin','glossary_term_delete');
select acs_privilege__remove_child('glossary_admin','glossary_term_add_illustration');
select acs_privilege__remove_child('glossary_admin','glossary_term_modify_illustration');
select acs_privilege__remove_child('glossary_admin','glossary_term_delete_illustration');

select acs_privilege__drop_privilege('glossary_admin');
select acs_privilege__drop_privilege('glossary_create');
select acs_privilege__drop_privilege('glossary_modify');
select acs_privilege__drop_privilege('glossary_delete');
select acs_privilege__drop_privilege('glossary_term_comment_on');
select acs_privilege__drop_privilege('glossary_term_comment_read');
select acs_privilege__drop_privilege('glossary_term_create');
select acs_privilege__drop_privilege('glossary_term_modify');
select acs_privilege__drop_privilege('glossary_term_delete');
select acs_privilege__drop_privilege('glossary_term_add_illustration');
select acs_privilege__drop_privilege('glossary_term_modify_illustration');
select acs_privilege__drop_privilege('glossary_term_delete_illustration');

-- delete all mappings of illustrations
-- (this leaves the source images in place)
-- and then the mapping type

delete from cr_child_rels where relation_tag = 'illustration';
select content_type__unregister_child_type('glossary', 'glossary_term', 'parent glossary');
select content_type__unregister_child_type('glossary_term','image','illustration');

-- delete all glosary_term objects

drop function glossary_term__new (varchar, varchar, varchar, integer, integer, varchar, integer, varchar);

-- we must clear out our term objects,
-- otherwise there will be foreign key constraint problems
-- hopedully the 'on delete cascade' in glossary_terms.term_id 
-- will clear out the objects that reference the terms in cr_revisions and acs_objects
-- with the acs_objects table when we try dropping the 
-- object types

create function inline_0() returns integer as '
declare
  glossary_term glossary_terms%ROWTYPE;
begin
  for glossary_term in select * from glossary_terms loop
    select content_item__delete(glossary_term.term_id);
  end loop;
  return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

select content_type__drop_type('glossary_term', 'f', 'f');

drop view glossary_termsi;
drop view glossary_termsx;
drop table glossary_terms;

-- we must clear out our glossary objects,
-- otherwise there will be foreign key constraint problems
-- with the acs_objects table when we try dropping the 
-- object types

create function inline_0() returns integer as '
declare
  glossary glossaries%ROWTYPE;
begin
  for glossary in select * from glossaries loop
    select content_item__delete(glossary__id);
  end loop;
  return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

-- dropping the attributes for glossaries

select content_type__drop_type('glossary', 'f', 'f');

-- finish up
drop view glossary_terms_latest;
drop view glossary_terms_live_definition;
drop view glossariesi;
drop view glossariesx;
drop table glossaries;

-- drop workflows

drop table full_term_publish_proces_cases;
select workflow__drop_workflow('full_term_publish_process_wf');

drop table term_submission_process_cases;
select workflow__drop_workflow('term_submission_process_wf');

drop table term_go_live_process_cases;
select workflow__drop_workflow('term_go_live_wf');
