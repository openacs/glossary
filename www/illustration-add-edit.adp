<master>
<if @title@ nil>
<property name=title>Upload Illustration</property>
</if>
<else>
<property name=title>Edit @title@</property>
</else>
<property name="context">@context@</property>

<form enctype=multipart/form-data method=POST action="illustration-add-edit-2">
@export_vars@
<table>
<tr>
<td valign=top align=right>Filename: </td>
<td>
<input type=file name=upload_file size=20><br>
<font size=-1>Use the "Browse..." button to locate your file, then click "Open".</font>
</td>
</tr>
<tr>
<td valign=top align=right>Illustration Title:
<td nowrap>
<input type=text name=title value="@title@" size="30">
</td>
</tr>
<tr>
<td valign=top align=right>name for URL:
<td nowrap>
<input type=text name=name value="@name@" size="30">
</td>
</tr>
<tr>
<td valign=top align=right>Illustration Description:
<br>
<font size=-1>(optional)</font>
</td>
<td><textarea rows=6 cols=50 wrap=soft name=description>
@description@
</textarea>
</td>
</tr>

</table>
<p>
<center>
<if @new_p@ eq 1>
<input type=submit value="Upload Illustration">
</if>
<else>
<input type=submit value="Edit Illustration">
</else>
</center>


