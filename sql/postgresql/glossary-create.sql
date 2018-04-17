-- packages/glossary/sql/glossary-create.sql

-- @author Walter McGinnis (walter@arsdigita.com)
-- @author Bart Teeuwisse (bart.teeuwisse@7-sisters.com)
-- @creation-date 2000-08-18
-- @cvs-id $ID:$

-- glossaries
--

create table glossaries (
  glossary_id 		integer
			constraint glossaries_glossary_id_fk
      			references cr_revisions on delete cascade
    			constraint glossaries_glossary_id_pk
      			primary key,
  owner_id		integer
			constraint glossaries_owner_id_fk
      			references parties,
  package_id		integer
			constraint glossaries_package_id_fk
      			references apm_packages,
  workflow_key		varchar(100)
			constraint glossaries_workflow_key_fk
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
select content_type__create_type (
    /* content_type => */  'glossary',
    /* supertype => */     'content_revision',
    /* pretty_name => */   'Glossary',
    /* pretty_plural => */ 'Glossaries',
    /* table_name => */    'glossaries',
    /* id_column => */     'glossary_id',
    /* name_method => */   NULL
  );

select content_type__create_attribute (
    /* content_type => */   'glossary',
    /* attribute_name => */ 'owner_id',
    /* datatype => */       'number',
    /* pretty_name => */    'Owner_id',
    /* pretty_plural => */  NULL,
    /* sort_order => */     NULL,
    /* default_value => */  NULL,
    /* column_spec => */    NULL
    );

select content_type__create_attribute (
    /* content_type => */   'glossary',
    /* attribute_name => */ 'package_id',
    /* datatype => */       'number',
    /* pretty_name => */    'Package_id',
    /* pretty_plural => */  NULL,
    /* sort_order => */     NULL,
    /* default_value => */  NULL,
    /* column_spec => */    NULL
    );

select content_type__create_attribute (
    /* content_type => */   'glossary',
    /* attribute_name => */ 'workflow_key',
    /* datatype => */       'string',
    /* pretty_name => */    'Workflow Process',
    /* pretty_plural => */  NULL,
    /* sort_order => */     NULL,
    /* default_value => */  NULL,
    /* column_spec => */    NULL
    );
  

-- should add locale and nls_language for full internationalization?
-- this is dependent on the standards for ACS globilization
-- will do the right thing later
create function glossary__new(integer, varchar, varchar, integer,
                              integer, varchar, integer, boolean) returns integer as '
declare
   p_owner_id      alias for $1;
   p_title         alias for $2;
   p_description   alias for $3;
   p_package_id    alias for $4;
   p_creation_user alias for $5;
   p_creation_ip   alias for $6;
   p_context_id    alias for $7;
   p_is_live       alias for $8;
   v_name          cr_items.name%TYPE;
   v_package_key   apm_packages.package_key%TYPE;
   v_item_id       integer;	
   v_revision_id   integer;
begin
  -- Get the object_id for the glossary to be created.
  select into v_item_id acs_object_id_seq.nextval;

  -- Get the package_key that glossary is created in
  select package_key into v_package_key from apm_packages where package_id = p_package_id;

  -- Concatenate the two to form the name of the glossary.
  v_name := v_package_key || v_item_id;

  -- Create the glossary
  v_item_id := content_item__new( 
   /* name => */          v_name, 
   /* parent_id */        NULL,
   /* item_id */          v_item_id,
   /* locale */           NULL,
   /* creation_date => */ current_timestamp,
   /* creation_user => */ p_creation_user,
   /* context_id => */    p_context_id,
   /* creation_ip => */   p_creation_ip,
   /* item_subtype */     ''content_item'',
   /* content_type => */  ''glossary'',
   /* title => */         NULL,
   /* description => */   NULL,
   /* mime_type => */     NULL,
   /* nls_language => */  NULL,
   /* text => */          NULL,
   /* storage_type */     ''text''
  );  

  v_revision_id := content_revision__new(
   /* title => */         p_title,
   /* description => */   p_description,
   /* publish_date => */  current_timestamp,
   /* mime_type => */     ''text/plain'',
   /* nls_language => */  NULL,
   /* data => */          NULL,
   /* item_id => */       v_item_id,
   /* revision_id => */   NULL,
   /* creation_date => */ current_timestamp,
   /* creation_user => */ p_creation_user,
   /* creation_ip => */   p_creation_ip
  );

  insert into glossaries (
  glossary_id, owner_id, package_id
  ) values (
  v_revision_id, p_owner_id, p_package_id
  );

  if p_is_live then
   update cr_revisions
   set publish_date = current_timestamp
   where revision_id = v_revision_id;

   update cr_items 
   set publish_status = ''live'',
   live_revision = v_revision_id
   where item_id =v_item_id;
  end if;

  return v_item_id;

end;' language 'plpgsql';

-- terms

create table glossary_terms (
  term_id    		integer
                        constraint glossary_terms_term_id_fk
      			references cr_revisions on delete cascade
    			constraint glossary_terms_pk
      			primary key
);

comment on table glossary_terms is 'most of the info for terms is stored in the content repository (cr_items and cr_revisions), terms essentially are composed of the two componants; the term and its definition in addition, an image can be associated with a term as illustration, terms inherit security settings via context_id which should point at the parent glossary), we use the cr_child_rels to map terms to glossaries for general parentage
';

 -- create the content type
select content_type__create_type(
    /* content_type => */  'glossary_term',
    /* supertype => */     'content_revision',
    /* pretty_name => */   'Term',
    /* pretty_plural => */ 'Terms',
    /* table_name => */    'glossary_terms',
    /* id_column => */     'term_id',
    /* name_method => */   NULL
  );

-- establish the parent child relationship between the glossary content type and the glossary term content type

select content_type__register_child_type('glossary','glossary_term','parent glossary', 0, NULL);

create function glossary_term__new (varchar, varchar, varchar, integer,
                                    integer, varchar, integer, varchar) returns integer as '
declare
   p_title          alias for $1;
   p_definition     alias for $2;
   p_mime_type	    alias for $3;
   p_package_id     alias for $4;
   p_creation_user  alias for $5;
   p_creation_ip    alias for $6;
   p_context_id     alias for $7;
   p_publish_status alias for $8;
   v_name           cr_items.name%TYPE;
   v_package_key    apm_packages.package_key%TYPE;
   v_item_id        acs_objects.object_id%TYPE;
   v_revision_id    acs_objects.object_id%TYPE;
   v_rel_id         cr_child_rels.rel_id%TYPE;
begin
  -- Get the object_id for the term to be created.
  select into v_item_id acs_object_id_seq.nextval;

  -- Get the package_key that term is created in
  select package_key into v_package_key from apm_packages where package_id = p_package_id;

  -- Concatenate the two to form the name of the term.
  v_name := v_package_key || v_item_id;

  -- Create the term
  v_item_id := content_item__new( 
      /* name => */          v_name, 
      /* parent_id */        NULL,
      /* item_id */          v_item_id,
      /* locale */           NULL,
      /* creation_date => */ current_timestamp,
      /* creation_user => */ p_creation_user,
      /* context_id => */    p_context_id,
      /* creation_ip => */   p_creation_ip,
      /* item_subtype */     ''content_item'',
      /* content_type => */  ''glossary_term'',
      /* title => */         NULL,
      /* description => */   NULL,
      /* mime_type => */     NULL,
      /* nls_language => */  NULL,
      /* text => */          NULL,
      /* storage_type */     ''text''
  );  

  v_revision_id := content_revision__new(
      /* title => */         p_title,
      /* description => */   p_definition,
      /* publish_date => */  current_timestamp,
      /* mime_type => */     p_mime_type,
      /* nls_language => */  NULL,
      /* data => */          NULL,
      /* item_id => */       v_item_id,
      /* revision_id => */   NULL,
      /* creation_date => */ current_timestamp,
      /* creation_user => */ p_creation_user,
      /* creation_ip => */   p_creation_ip
  );

  insert into glossary_terms (term_id) values (v_revision_id);

  update cr_revisions
      set content = p_definition
      where revision_id = v_revision_id;

  update cr_items 
      set publish_status = p_publish_status,
      live_revision = v_revision_id
      where item_id =v_item_id;

  -- Associate the term with its parent glossary
  v_rel_id := acs_object__new(
      /* object_id => */	NULL,
      /* object_type => */	''cr_item_child_rel'',
      /* creation_date => */	current_timestamp,
      /* creation_user => */	p_creation_user,
      /* creation_ip => */	p_creation_ip,
      /* context_id => */	p_context_id
  );
  
  insert into cr_child_rels (
      rel_id, parent_id, child_id, relation_tag
      ) values (
      v_rel_id, p_context_id, v_item_id, ''parent glossary''
  );
  
  return v_item_id;

end;' language 'plpgsql';

create view glossary_terms_latest as
	select i.item_id, i.live_revision, r.revision_id as latest_revision,
	title as term, name, content as definition, publish_status, r.mime_type
	from cr_items i, cr_revisions r
	where i.content_type = 'glossary_term'
	and r.item_id = i.item_id
        and r.revision_id = content_item__get_latest_revision(i.item_id);

create view glossary_terms_live_definition as
	select i.item_id, r.revision_id,
	title as term, name, content as definition, r.mime_type
	from cr_items i, cr_revisions r
	where i.content_type = 'glossary_term'
	and r.item_id = i.item_id
	and r.revision_id = i.live_revision
	and i.publish_status = 'live';

-- an "illustration" is a mapping of an image content_type to a glossary_term parent content_type

select content_type__register_child_type('glossary_term','image','illustration', 0, NULL);

-- permissions for glossaries and terms and illustrations

-- in the implementation we will grant all of the above on the glossary object
-- the term object will then point its context_id at the glossary object
-- to inherit the permissions scheme
-- note that we grant the generic read privilege to users as well
select acs_privilege__create_privilege('glossary_create', null, null);
select acs_privilege__create_privilege('glossary_modify', null, null);
select acs_privilege__create_privilege('glossary_delete', null, null);
select acs_privilege__create_privilege('glossary_term_comment_on', null, null);
select acs_privilege__create_privilege('glossary_term_comment_read', null, null);
select acs_privilege__create_privilege('glossary_term_create', null, null);
select acs_privilege__create_privilege('glossary_term_modify', null, null);
select acs_privilege__create_privilege('glossary_term_delete', null, null);
select acs_privilege__create_privilege('glossary_term_add_illustration', null, null);
select acs_privilege__create_privilege('glossary_term_modify_illustration', null, null);
select acs_privilege__create_privilege('glossary_term_delete_illustration', null, null);

select acs_privilege__create_privilege('glossary_admin', null, null);

select acs_privilege__add_child('admin','glossary_admin');
select acs_privilege__add_child('glossary_admin','glossary_create');
select acs_privilege__add_child('glossary_admin','glossary_modify');
select acs_privilege__add_child('glossary_admin','glossary_delete');
select acs_privilege__add_child('glossary_admin','glossary_term_comment_read');
select acs_privilege__add_child('glossary_admin','glossary_term_comment_on');
select acs_privilege__add_child('glossary_admin','glossary_term_create');
select acs_privilege__add_child('glossary_admin','glossary_term_modify');
select acs_privilege__add_child('glossary_admin','glossary_term_delete');
select acs_privilege__add_child('glossary_admin','glossary_term_add_illustration');
select acs_privilege__add_child('glossary_admin','glossary_term_modify_illustration');
select acs_privilege__add_child('glossary_admin','glossary_term_delete_illustration');

select content_folder__register_content_type( -100, 'glossary', 't');
select content_folder__register_content_type( -100, 'glossary_term', 't');

\i glossary-workflows.sql
