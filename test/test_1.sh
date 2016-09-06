#!/bin/bash


read -d '' JSON << EOF
<?xml version="1.0" encoding="UTF-8"?>
<wfs:GetFeature service="WFS" version="2.0.0"
    xmlns:wfs="http://www.opengis.net/wfs/2.0"
    xmlns:fes="http://www.opengis.net/fes/2.0"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:sf="http://www.openplans.org/spearfish"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.opengis.net/wfs/2.0
                        http://schemas.opengis.net/wfs/2.0/wfs.xsd
                        http://www.opengis.net/gml/3.2
                        http://schemas.opengis.net/gml/3.2.1/gml.xsd">
    <wfs:Query typeNames='dtmb:vyrez_DTMB'>
        <fes:Filter>
          <fes:BBOX>
            <fes:ValueReference>dtmb:the_geom</fes:ValueReference>
                <gml:Envelope srsName="urn:ogc:def:crs:EPSG::4326">
                    <gml:lowerCorner>49.200574 16.596528</gml:lowerCorner>
                    <gml:upperCorner>49.200594 16.596584</gml:upperCorner>
                </gml:Envelope>

          </fes:BBOX>
        </fes:Filter>
    </wfs:Query>
</wfs:GetFeature>
EOF

curl -i \
     -F event="$JSON" \
     http://localhost:8080/geoserver/wfs
