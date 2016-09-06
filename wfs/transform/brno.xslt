<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:wfs="http://www.opengis.net/wfs"
	xmlns:gml="http://www.opengis.net/gml" xmlns:dtmb="dtmb"
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

	<xsl:template match="dtmb:vyrez_DTMB">
		<arml:Feature>
			<xsl:attribute name="id">
			    <xsl:value-of select="@*"/>
			</xsl:attribute>
			<arml:anchors>
				<xsl:apply-templates select="dtmb:the_geom" />
			</arml:anchors>
			<arml:metadata>
			    <dtmb:SewerPipe>
				   <xsl:apply-templates select="dtmb:Level" />
				   <xsl:apply-templates select="dtmb:Type" />
				   <xsl:apply-templates select="dtmb:ColorIndex" />
                </dtmb:SewerPipe>
			</arml:metadata>
		</arml:Feature>
	</xsl:template>

    <!-- Use Level as a diameter -->
	<xsl:template match="dtmb:Level">
	    <dtmb:diameter>
	       <xsl:attribute name="uom">cm</xsl:attribute>
	       <xsl:value-of select="round(10 + text())"/>
	    </dtmb:diameter>
	</xsl:template>

    <!-- Use Level as a depth -->
	<xsl:template match="dtmb:Type">
	    <dtmb:depth>
	       <xsl:attribute name="uom">cm</xsl:attribute>
	       <xsl:value-of select="100 + round(10 * text())"/>
	    </dtmb:depth>
	</xsl:template>

    <!-- Use ColorIndex as a type -->
	<xsl:template match="dtmb:ColorIndex">
	    <dtmb:type>
	       <xsl:value-of select="text()"/>
	    </dtmb:type>
	</xsl:template>

	<xsl:template match="dtmb:the_geom">
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
