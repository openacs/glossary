# glossary/www/illustration-bits.tcl

ad_page_contract {
    spits out correctly MIME-typed bits for a term's illustration

    @author walter@arsdigita.com
    @creation-date 11-21-2000
    @cvs-id $ID:$
} {
    revision_id:integer
}

cr_write_content -revision_id $revision_id
