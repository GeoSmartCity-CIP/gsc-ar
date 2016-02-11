<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:wfs="http://www.opengis.net/wfs"
	xmlns:gml="http://www.opengis.net/gml" xmlns:genova="genova"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:arml="http://opengeospatial.org/arml/2.0">

	<xsl:template match="/">
		<arml:arml xmlns:arml="http://opengeospatial.org/arml/2.0">
			<arml:ARElements>
				<xsl:apply-templates />
			</arml:ARElements>
		</arml:arml>
	</xsl:template>

	<xsl:template match="wfs:member">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="genova:raquote_polyline">
		<arml:Feature>
			<xsl:attribute name="id"><xsl:value-of select="genova:id" /></xsl:attribute>
			<arml:anchors>
				<xsl:apply-templates select="genova:geom" />
			</arml:anchors>
		</arml:Feature>
	</xsl:template>

	<xsl:template match="genova:geom">
		<xsl:copy-of select="child::*" />
	</xsl:template>

	<xsl:template match="@*|node()" mode="a">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*">
		<xsl:message terminate="no">
			WARNING: Unmatched element:
			<xsl:value-of select="name()" />
		</xsl:message>

		<xsl:apply-templates />
	</xsl:template>

</xsl:stylesheet>
