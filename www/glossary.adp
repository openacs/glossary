<master>
<property name=title>@glossary_title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @glossary_edit_p@ eq 1>
 <table align=right><tr><td>[<a href=glossary-add-edit?item_id=@glossary_item_id@>Edit Glossary</a>]</td></tr></table>
</if>
<p>
@glossary_description@

<!-- end glossary info -->

<!-- glossary terms -->
<p>
<center>


<!-- not divided by letter at this point -->

<table border=0 cellpadding=1 cellspacing=0 width="80%">
<tr><td bgcolor=#aaaaaa>
<table border=0 cellpadding=3 cellspacing=0 width="100%">
  <tr bgcolor=#ffffff>
  <td colspan=2>Term</td>
  </tr>
<multiple name=glossary_term_item>
<if @glossary_term_item.rownum@ odd>
  <tr bgcolor=#eeeeee>
</if>
<else>
  <tr bgcolor=#ffffff>
</else>
    <td>&nbsp;
         <a href="term?item_id=@glossary_term_item.glossary_term_item_id@&glossary_item_id=@glossary_item_id@">@glossary_term_item.term@</a>
    </td>
<!--    <td>
id=">@glossary_item.owner_name
id=glossary_item.owner_id
         <a href="/shared/community-member?user_id="></a>
    </td>
-->
    <td align=right>
     <if @glossary_term_item.term_edit_p@ eq 1>
        [<a href=term-add-edit?item_id=@glossary_term_item.glossary_term_item_id@&glossary_item_id=@glossary_item_id@>edit</a>]
      </if>
    </td>
  </tr>
</multiple>
<if @glossary_term_item:rowcount@ eq 0>
  <tr bgcolor=#eeeeee>
    <td colspan=2 align=center><br>(no terms at this time)<br>&nbsp;</td>
  </tr>
</if>
  <tr bgcolor=#aaaaaa>
    <td colspan=2 align=center>
    <if @term_create_p@ eq 1>
      <a href=term-add-edit?glossary_item_id=@glossary_item_id@>add a new term to this glossary</a>
    </if>
    </td>
  </tr>
</table>
</td>
</table>

</center>
<!-- end glossary terms -->
