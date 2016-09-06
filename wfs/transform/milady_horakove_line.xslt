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
        match="mh:parovod_line|mh:plynovod_line|mh:vodovod_line|mh:kanalizace_line|mh:kabel_vo_line|mh:kabel_dpmb_line|mh:mikuluvka_line|mh:vm_kanalizace_line|mh:vm_plyn_line|mh:vm_voda_line">
        <arml:Feature>
            <arml:anchors>
                <xsl:apply-templates select="mh:wkb_geometry" />
            </arml:anchors>
            <arml:metadata>
                <mh:SewerPipe>
					<xsl:attribute name="id">
						<xsl:value-of select="mh:gml_id" />
					</xsl:attribute>
                    <xsl:apply-templates select="mh:diameter" />
                    <xsl:apply-templates select="mh:nodes" />
                </mh:SewerPipe>
            </arml:metadata>
        </arml:Feature>
    </xsl:template>

    <xsl:template match="mh:diameter">
        <mh:diameter>
            <xsl:attribute name="uom">mm</xsl:attribute>
            <xsl:value-of select="text()" />
        </mh:diameter>
    </xsl:template>

    <xsl:template match="mh:nodes">
        <mh:nodes>
            <xsl:attribute name="start">
               <xsl:value-of select="../mh:startnode" />
           </xsl:attribute>
            <xsl:attribute name="end">
               <xsl:value-of select="../mh:endnode" />
           </xsl:attribute>
            <xsl:attribute name="typeName">
               <xsl:variable name="name">
                   <xsl:value-of select="local-name(..)"/>
               </xsl:variable>
               <xsl:if test="$name = 'kanalizace_line'">mh:kanalizace_point</xsl:if>
               <xsl:if test="$name = 'vodovod_linestring'">mh:vodovod_point</xsl:if>
               <xsl:if test="$name = 'parovod_linestring'">mh:parovod_point</xsl:if>
               <xsl:if test="$name = 'plynovod_linestring'">mh:plynovod_point</xsl:if>
               <xsl:if test="$name = 'kabel_vo_linestring'">mh:kabel_vo_point</xsl:if>
               <xsl:if test="$name = 'kabel_dpmb_linestring'">mh:kabel_dpmb_point</xsl:if>
           </xsl:attribute>
            <xsl:attribute name="valueReference">mh:id</xsl:attribute>
            <xsl:value-of select="text()" />
        </mh:nodes>
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

