# glossary/www/illustration-bits.tcl

ad_page_contract {
    spits out correctly MIME-typed bits for a term's illustration, based on portrait-bits.tcl by philg@mit.edu

    @author walter@arsdigita.com
    @creation-date 11-21-2000
    @cvs-id $ID:$
} {
    revision_id:integer
}

if ![db_0or1row get_item_id "select mime_type
from cr_revisions 
where revision_id = :revision_id"] {
    ad_return_error "Couldn't find illustration" 
    return
}

ReturnHeaders $mime_type

db_write_blob output_illustration "select content
from cr_revisions
where revision_id = $revision_id"
 

