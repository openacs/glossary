<master>

<property name=title>@package_title@</property>
<property name="context">@context@</property>

<if @admin_p@ eq 1 or @workflow_p@ eq 1> 

<table align=right>
<tr>
  <!-- this link will eventually be redirected to workflow task manager? -->
  <td>[ 
    <if @admin_p@ eq 1>
     <a href=package-administer>Administer</a> 
    </if>
    <if @admin_p@ eq 1 and @workflow_p@ eq 1>
	|
    </if>
<!-- this should really be target new window -->	
    <if @workflow_p@ eq 1>
     <a href=@workflow_link@>Your Tasks</a> 	
    </if>
      ]
   </td>
</tr>
 </table>
</if>

<p>&nbsp;
<p>

<center>

<table border=0 cellpadding=1 cellspacing=0 width="80%">
<tr><td bgcolor=#aaaaaa>
<table border=0 cellpadding=3 cellspacing=0 width="100%">
  <tr bgcolor=#ffffff>
  <td colspan=2>Glossary</td>
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
    <td align=right>
     <if @glossary_item.admin_p@ eq 1>
        [ <a href=glossary-add-edit?item_id=@glossary_item.item_id@>edit</a> ]
      </if>
    </td>
  </tr>
</multiple>
<if @glossary_item:rowcount@ eq 0>
  <tr bgcolor=#eeeeee>
    <td colspan=2 align=center><br>(no glossaries at this time)<br>&nbsp;</td>
  </tr>
</if>
  <tr bgcolor=#aaaaaa>
    <td colspan=2 align=center>
    <if @create_p@ eq 1>
      <a href=glossary-add-edit>add a new glossary</a>
    </if>
    </td>
  </tr>
</table>
</td>
</table>

</center>