<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html"/>
<xsl:template match="/">
<html>
<head>
<xsl:apply-templates select="Report" mode="title"/>

<style>
h1.heading
{
text-align:center;
}
table.header
{
border:1px solid black;
width:100%;
background-color: #dedede;
}
table.header th
{
text-align:left;
}

table.gridtable {
	width:100%;
	border: 1px solid black;
	border-color: black;
	border-collapse: collapse;
}
table.gridtable th {
	border-width: 2px;
	border-style: solid;
}
table.gridtable td {
	text-align:center;
	border-width: 1px;
	border-style: solid;
}

table.form {
	width:100%;
	border: 1px solid black;
	border-color: black;
	border-collapse: collapse;
}
table.form th {
	border-width: 2px;
	border-style: solid;
}
table.form td {
	border-width: 1px;
	border-style: solid;
}
</style>

</head>
<body>
<xsl:apply-templates select="Report" mode="heading"/>
<xsl:for-each select="Report/Section">
<xsl:variable name="section-type">
<xsl:value-of select="@type" />
</xsl:variable>
<xsl:choose>
<xsl:when test="contains($section-type, 'table')">
<xsl:call-template name="tableRender" />
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="formRender" />
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</body>
</html>
</xsl:template>

<xsl:template match="Report" mode="heading">
<h1 class="heading">
<xsl:value-of select="@header" />
</h1>
</xsl:template>

<xsl:template match="Report" mode="title">
<title>
<xsl:value-of select="@header" />
</title>
</xsl:template>

<xsl:template name="formRender">
<table class="header">
<tr><th><xsl:value-of select="@header" /></th></tr>
</table>
<table class="form">
<xsl:for-each select="Group">
<xsl:call-template name="formGroup" />
</xsl:for-each>
</table>
</xsl:template>

<xsl:template name="formGroup" >
<tr>
<xsl:for-each select="Attribute">
<xsl:call-template name="formAttributes" />
</xsl:for-each>
</tr>
</xsl:template>

<xsl:template name="formAttributes" >
<td class="bottomSolid">
<xsl:if test="@Name != ''">
<xsl:value-of select="@Name" /> : <xsl:value-of select="@Value" />
</xsl:if>
</td>
</xsl:template>

<xsl:template name="tableRender">
<table class="header">
<tr><th><xsl:value-of select="@header" /></th></tr>
</table>
<table class="gridtable">
<xsl:for-each select="Rows">
<xsl:call-template name="rowColumn">
<xsl:with-param name="column-count" >
<xsl:value-of select="count(Rows/Header)" />
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</table>
</xsl:template>

<xsl:template name="rowColumn" >
<tr>
<xsl:for-each select="Header">
<xsl:call-template name="tableHeader" />
</xsl:for-each>
</tr>
<tr>
<xsl:for-each select="Value">
<xsl:call-template name="tableValue" />
</xsl:for-each>
</tr>
</xsl:template>

<xsl:template name="tableHeader" >
<th><xsl:value-of select="." /></th>
</xsl:template>

<xsl:template name="tableValue" >
<td><xsl:value-of select="." /></td>
</xsl:template>

</xsl:stylesheet>

