
ad_proc glossary_publish_states {} {returns a list of the possible publishing states of a content item in the content repository} {
    # hate to hardcode... but
    set publish_states [list [list "production" "production"] [list "ready" "ready"] [list "live" "live"] [list "expired" "expired"]]
    return $publish_states
}
