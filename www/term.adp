<master>

<property name=title>@term;noquote@</property>
<property name="context">@context;noquote@</property>

<if @term_modify_p@ eq 1 and @term_create_p@ eq 1> 
<table align=right>
<tr>

  <td>[ <a href=term-add-edit?item_id=@item_id@>Edit</a> | <a href=term-add-edit?glossary_item_id=@glossary_item_id@>Add a Term</a> ]</td>
</tr>
 </table>
</if>
<else>
 <if @term_modify_p@ eq 1>
  <table align=right>
  <tr>
   <td>[ <a href=term-add-edit?item_id=@item_id@>Edit</a> ]</td>
  </tr>
  </table>
 </if>
 <if @term_create_p@ eq 1>
  <table align=right>
  <tr>
   <td>[ <a href=term-add-edit?glossary_item_id=@glossary_item_id@>Add a Term</a> ]</td>
  </tr>
  </table>
 </if>
</else>

<p>&nbsp;
<p>
<b>Term:</b>
<p>
<blockquote>
@term@
</blockquote>
<b>Definition</b>:
<p>
<blockquote>
@html_definition;noquote@
</blockquote>
<p>

<if @illustration_exists_p@ eq 1>
<center>
<img @widthheight@ src="illustration-bits?@ill_export_vars@">
<p>
@ill_title@

<p>
@ill_description@
</center>
</if>

<if @comment_link@ not nil>
@comment_link;noquote@
</if>

<if @comments@ not nil>
@comments;noquote@
</if>
<!-- end term info -->


