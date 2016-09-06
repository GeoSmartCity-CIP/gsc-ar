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
   
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>

