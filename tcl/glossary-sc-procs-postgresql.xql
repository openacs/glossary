<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="glossary__datasource.datasource">
      <querytext>
       	select r.revision_id as object_id,
	       r.name as title,
	       r.content as content,
	       r.mime_type as mime,
	       r.name as keywords,
	       'text' as storage_type
	from cr_revisions r
	       where revision_id = :object_id
      </querytext>
</fullquery>

<fullquery name="glossary__url.url_stub">
      <querytext>
        select site_node__url(node_id) as url_stub
        from site_nodes
        where object_id=:package_id
      </querytext>
</fullquery>

</queryset>
