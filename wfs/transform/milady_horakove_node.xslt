<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" 
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:gml="http://www.opengis.net/gml" 
    xmlns:mh="milady_horakove"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:arml="http://opengeospatial.org/arml/2.0">

    <xsl:output
        method="xml" version="1.0" encoding="UTF-8"
        omit-xml-declaration="no"
        indent="yes"/>
   
    <xsl:strip-space elements="*"/>
     
    <xsl:template match="wfs:FeatureCollection">
        <arml:arml>
             <arml:ARElements>
  				<xsl:apply-templates />
            </arml:ARElements>
        </arml:arml>
    </xsl:template>

	<xsl:template match="gml:boundedBy">
	</xsl:template>

	<xsl:template match="gml:featureMember">
		<xsl:apply-templates />
	</xsl:template>

    <xsl:template
        match="mh:parovod_node|mh:plynovod_node|mh:vodovod_node|mh:kanalizace_node|mh:kabel_vo_node|mh:kabel_dpmb_node">
        <arml:Feature>
            <arml:anchors>
                <xsl:apply-templates select="mh:wkb_geometry" />
            </arml:anchors>
            <arml:metadata>
                <mh:UtilityNode>
					<xsl:attribute name="id">
						<xsl:value-of select="mh:id" />
					</xsl:attribute>
                    <xsl:apply-templates select="mh:description" />
                </mh:UtilityNode>
            </arml:metadata>
        </arml:Feature>
    </xsl:template>

    <xsl:template match="mh:description">
        <mh:description><xsl:value-of select="text()" /></mh:description>
    </xsl:template>

    <xsl:template match="mh:wkb_geometry">
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

