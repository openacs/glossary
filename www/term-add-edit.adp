<master>
<if @new_p@ eq 0>
<property name=title>@term;noquote@</property>
</if>
<else>
<property name=title>Add a New Term</property>
</else>
<property name="context">@context;noquote@</property>

<if @new_p@ eq 0>
<table align=right>
<tr>
  <td> <if @illustration_link_url@ not nil> 
	[ <a href=@illustration_link_url@><if @illustration_exists_p@ eq 1>Edit</if><else>Add an</else> Illustration</a> ] 
	</if> 

  </td>
</tr>
 </table>
</if>


<center>

<formtemplate id="new_term"></formtemplate>

</center>
