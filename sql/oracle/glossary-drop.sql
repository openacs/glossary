-- packages/glossary/sql/glossary-drop.sql

-- @author Walter McGinnis (walter@arsdigita.com)
-- @creation-date 2000-10-03
-- @cvs-id $ID:$

-- NOTE THIS SCRIPT IS PRETTY CLOSE TO COMPLETE BUT NOT QUITE
-- drop scripts have become a real pain in ACS 4.0
-- will debug for final release
-- in the meantime this is a good starting point and will get most everything
-- the main sticking point is dropping privileges

-- drop the glossary data model

begin
  content_folder.unregister_content_type( -100, 'glossary_term', 't');
  content_folder.unregister_content_type( -100, 'glossary', 't');
end;
/
show errors

-- drop all grantings of privleges 
-- and then drop privileges on glossaries

begin
  acs_privilege.remove_child('glossary_admin','glossary_create');
  acs_privilege.remove_child('glossary_admin','glossary_modify');
  acs_privilege.remove_child('glossary_admin','glossary_delete');
  acs_privilege.remove_child('glossary_admin','glossary_term_create');
  acs_privilege.remove_child('glossary_admin','glossary_term_modify');
  acs_privilege.remove_child('glossary_admin','glossary_term_delete');
  acs_privilege.remove_child('glossary_admin','glossary_term_comment_on');
  acs_privilege.remove_child('glossary_admin','glossary_term_upload_illustration');
  acs_privilege.remove_child('glossary_admin','glossary_term_delete_illustration');
end;
/
show errors

begin
  delete from acs_permissions where privilege = 'glossary_admin';
  acs_privilege.drop_privilege('glossary_admin');
end;
/
show errors

begin
  delete from acs_permissions where privilege = 'glossary_drop';
  acs_privilege.drop_privilege('glossary_drop');

  delete from acs_permissions where privilege = 'glossary_modify';
  acs_privilege.drop_privilege('glossary_modify');

  delete from acs_permissions where privilege = 'glossary_delete';
  acs_privilege.drop_privilege('glossary_delete');

  delete from acs_permissions where privilege = 'glossary_term_comment_on';
  acs_privilege.drop_privilege('glossary_term_comment_on');

  delete from acs_permissions where privilege = 'glossary_term_modify';
  acs_privilege.drop_privilege('glossary_term_modify');

  delete from acs_permissions where privilege = 'glossary_term_delete';
  acs_privilege.drop_privilege('glossary_term_delete');

  delete from acs_permissions where privilege = 'glossary_term_add_illustration';
  acs_privilege.drop_privilege('glossary_term_add_illustration');

  delete from acs_permissions where privilege = 'glossary_term_drop_illustration';
  acs_privilege.drop_privilege('glossary_term_drop_illustration');
end;
/
show errors

-- delete all mappings of illustrations
-- (this leaves the source images in place)
-- and then the mapping type

begin
  delete from cr_child_rels where relation_tag = 'illustration';
  content_type.unregister_child_type('glossary_term','image','illustration');
end;
/
show errors

-- delete all glosary_term objects

-- we must clear out our term objects,
-- otherwise there will be foreign key constraint problems
-- hopedully the 'on delete cascade' in glossary_terms.term_id 
-- will clear out the objects that reference the terms in cr_revisions and acs_objects
-- with the acs_objects table when we try dropping the 
-- object types

declare
  cursor terms_drop is 
    select term_id from glossary_terms;
  object_id integer;
begin
  open terms_drop;
  loop
    fetch terms_drop into object_id;
    exit when terms_drop%NOTFOUND;
    content_item.delete( item_id => object_id);
  end loop;
commit;
end;
/
show errors

begin
  acs_object_type.drop_type('glossary_term');
end;
/
show errors

drop view glossary_termsi;
drop view glossary_termsx;
drop table glossary_terms;

declare
-- we must clear out our glossary objects,
-- otherwise there will be foreign key constraint problems
-- with the acs_objects table when we try dropping the 
-- object types
  cursor glossaries_drop is
    select glossary_id from glossaries;

  object_id integer;
begin
  open glossaries_drop;
  loop
    fetch glossaries_drop into object_id;
    exit when glossaries_drop%NOTFOUND;
    content_item.delete( item_id => object_id);
  end loop;
commit;
end;
/
show errors

begin
  content_type.unregister_child_type('glossary_term','image','illustration');
end;
/
show errors

-- dropping the attributes for glossaries

begin
  acs_attribute.drop_attribute (
    object_type => 'glossary',
    attribute_name => 'title'
  );

  acs_attribute.drop_attribute (
    object_type => 'glossary',
    attribute_name => 'description'
  );

  acs_attribute.drop_attribute (
    object_type => 'glossary',
    attribute_name => 'owner_id'
  );

  acs_object_type.drop_type('glossary');
commit;
end;
/
show errors

-- finish up
drop view glossariesi;
drop view glossariesx;
drop table glossaries;
