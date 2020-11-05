<?xml version="1.0" encoding="UTF-8"?>
<!-- Written by Georgi D. Sotirov <gdsotirov@dir.bg> -->

<!DOCTYPE html>
<xsl:stylesheet xmlns:xsl="https://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" />

<xsl:template match="/">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><xsl:value-of select="/rss/channel/title" /></title>
<script type="text/javascript"><![CDATA[
function trans() {
  var i, desc, text;
  for( i = 1; i; i++) {
    titl = document.getElementById("t_" + i);
    desc = document.getElementById("d_" + i);
    if ( titl != null ) {
      text = unescape(titl.innerHTML);
      text = text.replace(/&gt;/gi, ">");
      text = text.replace(/&lt;/gi, "<");
      text = text.replace(/<[^<]+>/g, "");
      titl.innerHTML = text;
    }
    else break;
    if ( desc != null ) {
      text = unescape(desc.innerHTML);
      text = text.replace(/&gt;/gi, ">");
      text = text.replace(/&lt;/gi, "<");
      desc.innerHTML = text;
    }
    else break;
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

<h1>Заглавие: <xsl:value-of select="title"/></h1>
<h2>Обновена на: <xsl:value-of select="lastBuildDate"/></h2>
<xsl:choose>
<xsl:when test="count(item) = 1">
<p>Показанa е само 1 публикация в тази емисия.</p>
</xsl:when>
</xsl:choose>

<hr />

<div id="comment">
<p>
<xsl:attribute name="style">color: #ff0000;</xsl:attribute>
<xsl:attribute name="align">center</xsl:attribute>
Преглеждате <abbr lang="en" title="Rich Site Summary">RSS</abbr> емисия. Тя е
представена като <abbr lang="en" title="HyperText Markup Language">HTML</abbr>
с използването на <abbr lang="en" title="Extensible Stylesheet Language">XSL</abbr>
стилови описания.<br />За да видите скрития <abbr lang="en"
title="Extensible Markup Language">XML</abbr> код, моля изберете "Изходен код"
командата в браузъра ви.</p>
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
  <h3>Заглавие: <a><xsl:attribute name="href"><xsl:value-of select="link" /></xsl:attribute>
  <xsl:attribute name="id">t_<xsl:value-of select="position()" /></xsl:attribute>
  <xsl:value-of select="title" /></a></h3>
  <p>
  <xsl:attribute name="style">font-weight: small; font-style: italic;</xsl:attribute>
  <xsl:value-of select="position()" /> от <xsl:value-of select="count(/rss/channel/item)" />
  <xsl:choose>
    <xsl:when test="$ver = '2.0'"> (Публикувано на <xsl:value-of select="pubDate" />)</xsl:when>
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
