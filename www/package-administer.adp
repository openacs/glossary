<master>

<property name=title>Need to figure out how to get the package title</property>

<h2>Package or Application title</h2>

@context_bar@

<hr>


<p>&nbsp;
<p>

<center>

<table border=0 cellpadding=1 cellspacing=0 width="80%">
<tr><td bgcolor=#aaaaaa>
<table border=0 cellpadding=3 cellspacing=0 width="100%">
  <tr bgcolor=#ffffff>
  <td>Glossary</td>
  <td>Status</td>
  <td>Publish Date</td>
  <td>Action</td>
  <!-- <td>Owner</td> -->
  </tr>

<multiple name=glossary_item>

<if @glossary_item.rownum@ odd>
  <tr bgcolor=#eeeeee>
</if>
<else>
  <tr bgcolor=#ffffff>
</else>
    <td>&nbsp;
         <a href="glossary?item_id=@glossary_item.item_id@">@glossary_item.title@</a>
    </td>
<!--    <td>
id=glossary_item.owner_id
         <a href="/shared/community-member?user_id=">@glossary_item.owner_name@</a>
    </td>
-->
  <td>@glossary_item.publish_status@</td>
  <td>@glossary_item.publish_date@</td>
    <td>
        [ <a href=glossary-add-edit?item_id=@glossary_item.item_id@>edit</a> | 	       <if @glossary_item.publish_status@ eq "live">
	<a href=disable?item_id=@glossary_item.item_id@>disable</a>
	</if>
	<else>
	<a href=publish?item_id=@glossary_item.item_id@>publish</a>	
	</else>
	 ]
    </td>
  </tr>
</multiple>
<if @glossary_item:rowcount@ eq 0>
  <tr bgcolor=#eeeeee>
    <td colspan=2 align=center><br>(no glossaries at this time)<br>&nbsp;</td>
  </tr>
</if>
  <tr bgcolor=#aaaaaa>
    <td colspan=4 align=center>
    <if @create_p@ eq 1>
      <a href=glossary-add-edit>add a new glossary</a>
    </if>
    </td>
  </tr>
</table>
</td>
</table>

</center>