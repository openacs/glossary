<master>
<if @new_p@ eq 0>
<property name=title>@title;noquote@</property>
</if>
<else>
<property name=title>Add a Glossary</property>
</else>
<property name="context">@context;noquote@</property>

<if @new_p@ eq 0 and @glossary_admin_p@ eq 1> 
<table align=right>
<tr>
  <td>[ <a href=@permissions_link@>Edit Glossary's Permissions</a> | 
	<if @pending_terms_link@ not nil>
	<a href=@pending_terms_link@>Pending Terms</a> | 
	</if>
	<a href=@publish_action_link@><if @live_p@ eq 1>
Disable</if><else>Publish</else>
Glossary</a>
	 ]
   </td>
</tr>
 </table>
</if>

<p>&nbsp;
<p>
<center>

<formtemplate id="new_glossary"></formtemplate>

</center>

<if @new_p@ eq 0>
<p>
Workflow Policy: 

 <if @workflow_key@ nil>
  <a href=workflow-add-edit?item_id=@item_id@>Not defined, Please set</a>
 </if>
 <else>
  <a href=workflow-add-edit?item_id=@item_id@&wf=@workflow_key@>@workflow_name@</a>
  <p>
  <blockquote>@workflow_description@</blockquote>
 </else>	
</if>