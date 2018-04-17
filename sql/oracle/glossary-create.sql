-- packages/glossary/sql/glossary-create.sql

-- @author Walter McGinnis (walter@arsdigita.com)
-- @creation-date 2000-08-18
-- @cvs-id $ID:$

-- glossaries
--

create table glossaries (
  glossary_id 		constraint glossaries_glossary_id_fk
      			references cr_revisions on delete cascade
    			constraint glossaries_glossary_id_pk
      			primary key,
  owner_id		constraint glossaries_owner_id_fk
      			references parties,
  package_id		constraint glossaries_package_id_fk
      			references apm_packages,
  workflow_key		constraint glossaries_workflow_key_fk
      			references wf_workflows
);

comment on table glossaries is 'glossary table to store the object''s custom attributes, 
note standard auditing information is stored acs_objects, 
such as creation_user, creation_date, last_modified, etc.
these act as primary containers for terms (glossary content_item),
a term''s context_id will point to its glossary and terms will also be mapped using cr_child_rels table';

comment on column glossaries.owner_id is 'the creation_user may not always be the owner of a module after is created, so we have a separate column that references the parties table so that we owner''s can be either individual''s or groups';

comment on column glossaries.package_id is 'we use this rather than always counting on context_id to give us the right permissions, because package instances  may share grant the same permission to the same party, but they are not the same set of glossaries ';

-- create a glossary object type
declare
 attr_id acs_attributes.attribute_id%TYPE;
begin
  content_type.create_type (
    supertype => 'content_revision',
    content_type => 'glossary',
    pretty_name => 'Glossary',
    pretty_plural => 'Glossaries',
    table_name => 'glossaries',
    id_column => 'glossary_id'
  );

  attr_id := content_type.create_attribute (
    content_type => 'glossary',
    attribute_name => 'owner_id',
    pretty_name => 'Owner_id',
    datatype => 'number'
    );

  attr_id := content_type.create_attribute (
    content_type => 'glossary',
    attribute_name => 'package_id',
    pretty_name => 'Package_id',
    datatype => 'number'
    );

  attr_id := content_type.create_attribute (
    content_type => 'glossary',
    attribute_name => 'workflow_key',
    pretty_name => 'Workflow Process',
    datatype => 'string'
    );
  
commit;
end;
/
show errors

-- should add locale and nls_language for full internationalization?
-- this is dependent on the standards for ACS globilization
-- will do the right thing later

create or replace package glossary
as
  function new(
   owner_id  	 in parties.party_id%TYPE,
   title         in cr_revisions.title%TYPE,
   description   in cr_revisions.description%TYPE default null,
   package_id    in apm_packages.package_id%TYPE,
   creation_date in acs_objects.creation_date%TYPE default sysdate,
   creation_user in acs_objects.creation_user%TYPE default null,
   creation_ip	 in acs_objects.creation_ip%TYPE default null,
   context_id    in acs_objects.context_id%TYPE default null,
   is_live       in char default 'f'
  ) return cr_items.item_id%TYPE;

end glossary;
/
show errors

create or replace package body glossary
as
  function new(
   owner_id  	 in parties.party_id%TYPE,
   title         in cr_revisions.title%TYPE,
   description   in cr_revisions.description%TYPE default null,
   package_id    in apm_packages.package_id%TYPE,
   creation_date in acs_objects.creation_date%TYPE default sysdate,
   creation_user in acs_objects.creation_user%TYPE default null,
   creation_ip	 in acs_objects.creation_ip%TYPE default null,
   context_id    in acs_objects.context_id%TYPE default null,
   is_live       in char default 'f'
  ) return cr_items.item_id%TYPE is
    v_item_id         integer;	
    v_revision_id     integer;
    v_name            varchar(1000);
    v_package_key     apm_packages.package_key%TYPE;
  begin

  -- Get the object_id for the glossary to be created.
  select acs_object_id_seq.nextval into v_item_id from dual;

  -- Get the package_key that glossary is created in
  select package_key into v_package_key from apm_packages where package_id = new.package_id;

  -- Concatenate the two to form the name of the glossary.
  v_name := v_package_key || v_item_id;

  -- Create the glossary

  v_item_id := content_item.new( 
   item_id => v_item_id,
   name => v_name, 
   content_type => 'glossary',
   creation_date => creation_date,
   creation_user => creation_user,
   creation_ip => creation_ip,
   context_id => context_id
  );  

  v_revision_id := content_revision.new(
   item_id => v_item_id,
   title => title,
   description => description,
   creation_date => creation_date,
   creation_user => creation_user,
   creation_ip => creation_ip
  );

  insert into glossaries (
  glossary_id, owner_id, package_id
  ) values (
  v_revision_id, owner_id, package_id
  );

  if is_live = 't' then
   update cr_revisions
   set publish_date = sysdate
   where revision_id = v_revision_id;

   update cr_items 
   set publish_status = 'live',
   live_revision = v_revision_id
   where item_id =v_item_id;
  end if;

  return v_item_id;

  end new;

end glossary;
/
show errors

-- terms

create table glossary_terms (
  term_id    		constraint glossary_terms_term_id_fk
      			references cr_revisions on delete cascade
    			constraint glossary_terms_pk
      			primary key
);

comment on table glossary_terms is 'most of the info for terms is stored in the content repository (cr_items and cr_revisions), terms essentially are composed of the two componants; the term and its definition in addition, an image can be associated with a term as illustration, terms inherit security settings via context_id which should point at the parent glossary), we use the cr_child_rels to map terms to glossaries for general parentage
';

begin
 -- create the content type
  content_type.create_type(
   supertype     => 'content_revision',
   content_type  => 'glossary_term',
   pretty_name   => 'Term',
   pretty_plural => 'Terms',
   table_name    => 'glossary_terms',
   id_column     => 'term_id'
  );
 
  commit;

end;
/
show errors

-- establish the parent child relationship between the glossary content type and the glossary term content type

begin
  content_type.register_child_type('glossary','glossary_term','parent glossary');
end;
/
show errors

create or replace view glossary_terms_latest as
	select i.item_id, i.live_revision, r.revision_id as latest_revision,
	title as term, name, content as definition, publish_status, r.mime_type
	from cr_items i, cr_revisions r
	where i.content_type = 'glossary_term'
	and r.item_id = i.item_id
        and r.revision_id = content_item.get_latest_revision(i.item_id);

create or replace view glossary_terms_live_definition as
	select i.item_id, r.revision_id,
	title as term, name, content as definition, r.mime_type
	from cr_items i, cr_revisions r
	where i.content_type = 'glossary_term'
	and r.item_id = i.item_id
	and r.revision_id = i.live_revision
	and i.publish_status = 'live';

-- an "illustration" is a mapping of an image content_type to a glossary_term parent content_type

begin
  content_type.register_child_type('glossary_term','image','illustration');
end;
/
show errors

-- permissions for glossaries and terms and illustrations

-- in the implementation we will grant all of the above on the glossary object
-- the term object will then point its context_id at the glossary object
-- to inherit the permissions scheme
-- note that we grant the generic read privilege to users as well
begin
  acs_privilege.create_privilege('glossary_create');
  acs_privilege.create_privilege('glossary_modify');
  acs_privilege.create_privilege('glossary_delete');
  acs_privilege.create_privilege('glossary_term_comment_on');
  acs_privilege.create_privilege('glossary_term_comment_read');
  acs_privilege.create_privilege('glossary_term_create');
  acs_privilege.create_privilege('glossary_term_modify');
  acs_privilege.create_privilege('glossary_term_delete');
  acs_privilege.create_privilege('glossary_term_add_illustration');
  acs_privilege.create_privilege('glossary_term_modify_illustration');
  acs_privilege.create_privilege('glossary_term_delete_illustration');
end;
/
show errors

begin
  acs_privilege.create_privilege('glossary_admin');

  acs_privilege.add_child('admin','glossary_admin');
  acs_privilege.add_child('glossary_admin','glossary_create');
  acs_privilege.add_child('glossary_admin','glossary_modify');
  acs_privilege.add_child('glossary_admin','glossary_delete');
  acs_privilege.add_child('glossary_admin','glossary_term_comment_read');
  acs_privilege.add_child('glossary_admin','glossary_term_comment_on');
  acs_privilege.add_child('glossary_admin','glossary_term_create');
  acs_privilege.add_child('glossary_admin','glossary_term_modify');
  acs_privilege.add_child('glossary_admin','glossary_term_delete');
  acs_privilege.add_child('glossary_admin','glossary_term_add_illustration');
  acs_privilege.add_child('glossary_admin','glossary_term_modify_illustration');
  acs_privilege.add_child('glossary_admin','glossary_term_delete_illustration');
end;
/
show errors

begin
  content_folder.register_content_type( -100, 'glossary', 't');
  content_folder.register_content_type( -100, 'glossary_term', 't');
end;
/
show errors

create or replace package glossary_term
as
  function new(
   term          in cr_revisions.title%TYPE,
   definition    in cr_revisions.description%TYPE default null,
   mime_type     in varchar,
   package_id    in apm_packages.package_id%TYPE,
   creation_date in date default sysdate,
   creation_user in acs_objects.creation_user%TYPE default null,
   creation_ip	 in acs_objects.creation_ip%TYPE default null,
   context_id    in acs_objects.context_id%TYPE default null,
   publish_status in cr_items.publish_status%TYPE
  ) return cr_items.item_id%TYPE;

end glossary_term;
/
show errors

create or replace package body glossary_term
as
  function new(
   term          in cr_revisions.title%TYPE,
   definition    in cr_revisions.description%TYPE default null,
   mime_type     in varchar,
   package_id    in apm_packages.package_id%TYPE,
   creation_date in date default sysdate,
   creation_user in acs_objects.creation_user%TYPE default null,
   creation_ip	 in acs_objects.creation_ip%TYPE default null,
   context_id    in acs_objects.context_id%TYPE default null,
   publish_status in cr_items.publish_status%TYPE
  ) return cr_items.item_id%TYPE is
    v_revision_id     integer;
    v_name            varchar(1000);
    v_item_id         cr_items.item_id%TYPE;
    v_package_key     apm_packages.package_key%TYPE;
    v_rel_id          acs_objects.object_id%TYPE;
  begin

  -- Get the object_id for the term to be created.
  select acs_object_id_seq.nextval into v_item_id from dual;

  -- Get the package_key that term is created in
  select package_key into v_package_key from apm_packages where package_id = new.package_id;

  -- Concatenate the two to form the name of the term.
  v_name := v_package_key || v_item_id;

  -- Create the glossary

  v_item_id := content_item.new( 
   item_id => v_item_id,
   name => v_name, 
   content_type => 'glossary_term',
   creation_date => creation_date,
   creation_user => creation_user,
   creation_ip => creation_ip,
   context_id => context_id
  );  

  v_revision_id := content_revision.new(
   item_id => v_item_id,
   title => term,
   mime_type => mime_type,
   text => definition,
   creation_date => creation_date,
   creation_user => creation_user,
   creation_ip => creation_ip
  );

  insert into glossary_terms (term_id) values (v_revision_id);


  update cr_items 
      set publish_status = new.publish_status,
      live_revision = v_revision_id
      where item_id =v_item_id;

  v_rel_id := acs_object.new (
   object_type => 'cr_item_child_rel',
   creation_date => creation_date,
   creation_user => creation_user,
   creation_ip => creation_ip
  );

  insert into cr_child_rels
    (rel_id, parent_id, child_id, relation_tag)
  values
    (v_rel_id, context_id, v_item_id, 'parent glossary');
  
  return v_item_id;

  end new;

end glossary_term;
/
show errors

@@ glossary-workflows.sql
