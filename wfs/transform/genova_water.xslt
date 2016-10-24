<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" 
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:gml="http://www.opengis.net/gml" 
    xmlns:gsc="http://www.geosmartcity.eu/"
    xmlns:mh="milady_horakove"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:arml="http://opengeospatial.org/arml/2.0">

    <xsl:output
        method="xml" version="1.0" encoding="UTF-8"
        omit-xml-declaration="no"
        indent="yes"/>
   
    <xsl:strip-space elements="*"/>
     
    <xsl:template match="wfs:FeatureCollection">
        <!-- Top level element. -->
        <arml:arml>
             <arml:ARElements>
  				<xsl:apply-templates />
            </arml:ARElements>
        </arml:arml>
    </xsl:template>

	<xsl:template match="gml:boundedBy">
	</xsl:template>

	<xsl:template match="gml:featureMember|wfs:member">
		<xsl:apply-templates />
	</xsl:template>

    <xsl:template match="gsc:p07_gsc_waterpipe_flat">
        <arml:Feature>
            <arml:anchors>
                <!-- Copy geometry. -->
                <xsl:apply-templates select="gsc:wkb_geometry" />
            </arml:anchors>
            <arml:metadata>
                <!-- Create sewer pipe definition. -->
                <mh:SewerPipe>
					<xsl:attribute name="id">
						<xsl:value-of select="gsc:gml_id" />
					</xsl:attribute>
                    <xsl:call-template name="diameter" />
                    <xsl:call-template name="depth" />
                    <xsl:call-template name="utilityDeliveryType" />
                    <xsl:call-template name="waterType" />
                </mh:SewerPipe>
            </arml:metadata>
        </arml:Feature>
    </xsl:template>

    <xsl:template name="diameter">
        <mh:diameter>
            <xsl:attribute name="uom">
               <xsl:call-template name="convertUnits">
                <xsl:with-param name="unit"><xsl:value-of select="gsc:pipediameter_uom/text()"/></xsl:with-param>
               </xsl:call-template>
            </xsl:attribute>
            <xsl:value-of select="gsc:pipediameter/text()" />
        </mh:diameter>
    </xsl:template>

    <xsl:template name="depth">
        <xsl:if test="gsc:depthmeasure">
            <!-- Don't use zero depth -->
			<xsl:if test="number(gsc:depthmeasure/text()) &gt; 0">
				<mh:depth>
					<xsl:attribute name="uom">
					   <xsl:call-template name="convertUnits">
						<xsl:with-param name="unit"><xsl:value-of select="gsc:depthmeasure_uom/text()"/></xsl:with-param>
					   </xsl:call-template>
					</xsl:attribute>
					<xsl:value-of select="gsc:depthmeasure/text()" />
				</mh:depth>
			</xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="convertUnits">
		<xsl:param name="unit" />
	   <xsl:if test="$unit = 'millimeter'">mm</xsl:if>
	   <xsl:if test="$unit = 'meter'">m</xsl:if>
    </xsl:template>

    <xsl:template name="utilityDeliveryType">
        <mh:utilityDeliveryType>
            <xsl:attribute name="xlink:href">
				<xsl:call-template name="string-trim">
					<xsl:with-param name="string" select="gsc:utilitydeliverytype_href/text()" />
				</xsl:call-template>
			</xsl:attribute>
		</mh:utilityDeliveryType>
    </xsl:template>

    <xsl:template name="waterType">
        <mh:waterType>
            <xsl:attribute name="xlink:href">
				<xsl:call-template name="string-trim">
					<xsl:with-param name="string" select="gsc:watertype_href/text()" />
				</xsl:call-template>
			</xsl:attribute>
		</mh:waterType>
    </xsl:template>

    <xsl:template match="gsc:wkb_geometry">
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

<xsl:variable name="whitespace" select="'&#09;&#10;&#13; '" />

<!-- Strips trailing whitespace characters from 'string' -->
<xsl:template name="string-rtrim">
    <xsl:param name="string" />
    <xsl:param name="trim" select="$whitespace" />

    <xsl:variable name="length" select="string-length($string)" />

    <xsl:if test="$length &gt; 0">
        <xsl:choose>
            <xsl:when test="contains($trim, substring($string, $length, 1))">
                <xsl:call-template name="string-rtrim">
                    <xsl:with-param name="string" select="substring($string, 1, $length - 1)" />
                    <xsl:with-param name="trim"   select="$trim" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
</xsl:template>

<!-- Strips leading whitespace characters from 'string' -->
<xsl:template name="string-ltrim">
    <xsl:param name="string" />
    <xsl:param name="trim" select="$whitespace" />

    <xsl:if test="string-length($string) &gt; 0">
        <xsl:choose>
            <xsl:when test="contains($trim, substring($string, 1, 1))">
                <xsl:call-template name="string-ltrim">
                    <xsl:with-param name="string" select="substring($string, 2)" />
                    <xsl:with-param name="trim"   select="$trim" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
</xsl:template>

<!-- Strips leading and trailing whitespace characters from 'string' -->
<xsl:template name="string-trim">
    <xsl:param name="string" />
    <xsl:param name="trim" select="$whitespace" />
    <xsl:call-template name="string-rtrim">
        <xsl:with-param name="string">
            <xsl:call-template name="string-ltrim">
                <xsl:with-param name="string" select="$string" />
                <xsl:with-param name="trim"   select="$trim" />
            </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="trim"   select="$trim" />
    </xsl:call-template>
</xsl:template>

</xsl:stylesheet>

