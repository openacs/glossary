<?xml version="1.0"?>
<queryset>

<fullquery name="glossary_direct_lookup.definition_display_1">      
      <querytext>
      
	    select content 
              from cr_revisions cr, glossary_terms gt
             where cr.title = :term 
               and cr.revision_id = gt.term_id
	
      </querytext>
</fullquery>

<fullquery name="glossary_direct_lookup.definition_display_2">      
      <querytext>
      
	    select content 
              from cr_revisions cr, glossary_terms gt
             where lower(cr.title) = :caseless_term 
               and cr.revision_id = gt.term_id
	
      </querytext>
</fullquery>
 
</queryset>
