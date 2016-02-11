# gsc-ar
Augmented Reality Support

## Current state
At the moment there isn't an ARML server providing data required data. 
Instead data are available through the means of "traditional" technologies, such as WFS.

## Solution
The main idea is to convert existing data into ARML. As the data is provided by WFS, in form of an XML document, XSLT is the best technology to perform desired transformation.

[Geoserver](geoserver.org), used as a primary platform to provide geospatial data, includes required functionality. 
Its [XSLT WFS output format module](http://docs.geoserver.org/stable/en/user/extensions/xslt/index.html) can be used for this purpose. Generally it enables to define an XSLT style sheet to transform data outputed by WFS into desired form.

If source data is providing by a WFS which doesn't support XSLT post-processing, another Geoserver's functionality can help. 
There's an extension, called [External Web Feature Server](http://docs.geoserver.org/stable/en/user/data/cascaded/wfs.html).
It forwards incoming request to an external server and performs required data transformation supported by Geoserver.

## Source Code
The source code contains configuration file and XSLT style sheet, as required by XSLT module of Geoserver.

Note that the stylesheet isn't a general one transforming any incoming data into ARML.
Instead, specific style sheet must be defined for each type of input data to reflect its structure.

Current version of the style sheet is just an example of trivial data containg only an idefication and a geometry.
