<?xml version="1.0"?>
<!-- Written by Georgi D. Sotirov <gdsotirov@dir.bg> -->
<!-- $Id: rss.en.xsl,v 1.3 2006/05/21 10:16:15 gsotirov Exp $ -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" />

<xsl:template match="/">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><xsl:value-of select="/rss/channel/title" /></title>
<script type="text/javascript"><![CDATA[
function sr(s, f, r) {
  var ret = s;
  var start = ret.indexOf(f);
  while ( start >= 0 ) {
    ret = ret.substring(0, start) + r + ret.substring(start + f.length, ret.length);
    start = ret.indexOf(f, start + r.length);
  }
  return ret;
}

function trans() {
  var i, desc, text;
  for( i = 1; i; i++) {
    desc = document.getElementById("d_" + i);
    if ( desc == null ) break;
    text = unescape(desc.innerHTML);
    text = sr(text, "&gt;", ">");
    text = sr(text, "&lt;", "<");
    desc.innerHTML = text;
  }
}]]>
</script>
</head>
<body>
  <xsl:attribute name="style">font-family: sans-serif; font-weight: normal; background-color: #ffffff;</xsl:attribute>
  <xsl:apply-templates/>
</body>
</html>
</xsl:template>

<xsl:template match="/rss/channel">
<a><xsl:attribute name="name">top</xsl:attribute></a>
<xsl:if test="image">
<p style="float: left;">
<a><xsl:attribute name="href"><xsl:value-of select="image/link" /></xsl:attribute>
<img>
<xsl:attribute name="border">0</xsl:attribute>
<xsl:attribute name="src"><xsl:value-of select="image/url" /></xsl:attribute>
<xsl:attribute name="alt"><xsl:value-of select="image/description" /></xsl:attribute>
<xsl:attribute name="title"><xsl:value-of select="image/title" /></xsl:attribute>
</img></a></p>
</xsl:if>

<h1>Title: <xsl:value-of select="title"/></h1>
<h2>Updated on: <xsl:value-of select="lastBuildDate"/></h2>
<xsl:choose>
<xsl:when test="count(item) = 1">
<p>There is only 1 post shown in this feed.</p>
</xsl:when>
</xsl:choose>

<hr />

<div id="comment">
<p>
<xsl:attribute name="style">color: #ff0000;</xsl:attribute>
<xsl:attribute name="align">center</xsl:attribute>
You are looking at an <abbr lang="en" title="Rich Site Summary">RSS</abbr>
feed. It has been rendered as <abbr lang="en" title="HyperText Markup Language">HTML</abbr>
using an <abbr lang="en" title="Extensible Stylesheet Language">XSL</abbr>
stylesheet.<br />To see the underlying <abbr lang="en"
title="Extensible Markup Language">XML</abbr>code, please select the "View
Source" command in your browser</p>
</div>

<hr />

<xsl:variable name="ver" >
  <xsl:value-of select="../@version" />
</xsl:variable>

<div>
<xsl:for-each select="item">
<div>
  <xsl:choose>
    <xsl:when test="position() mod 2 = 0">
      <xsl:attribute name="style">background: #fff; border: 1px solid #999; margin: 2em; padding: 1em;</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="style">background: #eee; border: 1px solid #999; margin: 2em; padding: 1em;</xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
  <h3>Title: <a><xsl:attribute name="href"><xsl:value-of select="link" /></xsl:attribute>
  <xsl:value-of select="title" /></a></h3>
  <p>
  <xsl:attribute name="style">font-weight: small; font-style: italic;</xsl:attribute>
  <xsl:value-of select="position()" /> of <xsl:value-of select="count(/rss/channel/item)" />
  <xsl:choose>
    <xsl:when test="$ver = '2.0'"> (Published on <xsl:value-of select="pubDate" />)</xsl:when>
  </xsl:choose></p>
  <p>
  <xsl:attribute name="id">d_<xsl:value-of select="position()" /></xsl:attribute>
  <xsl:value-of disable-output-escaping="yes" select="description" /></p>
</div>
</xsl:for-each>
</div>

<p><xsl:value-of select="copyright" /></p>
<script type="text/javascript">trans();</script>
</xsl:template>

</xsl:stylesheet>
