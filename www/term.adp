<master>

<property name=title>@term@</property>

<!-- term info -->
<h3>@term@</h3>

@context_bar@

<hr>


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
@definition@
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
@comment_link@
</if>

<if @comments@ not nil>
@comments@
</if>
<!-- end term info -->


