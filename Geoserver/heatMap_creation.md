# Création et réalisation de HeatMap sur Geoserver


######            ######
####  Paramétrage   ####
######            ######

Pour la création de carte de chaleur dans Geoserver, vous allez avoir besoin de créer un style SLD que vous pourrez ensuite choisir dans chaque couche que vous aurez.

1. Allez donc dans `Styles` dan sla barre à gauche puis dans `Ajouter un nouvau style`.
2. Donnez lui un nom (ex : Heatmap).
3. Vous n'êtes pas obligé de lui spécifier un espace de travail.
4. Sélectionnez `SLD` dans le menu déroulant du `Format`
5. Dans la partie code copiez collez le code suivant :



```
<?xml version="1.0" encoding="ISO-8859-1"?>
     <StyledLayerDescriptor version="1.0.0"
         xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
         xmlns="http://www.opengis.net/sld"
         xmlns:ogc="http://www.opengis.net/ogc"
         xmlns:xlink="http://www.w3.org/1999/xlink"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
       <NamedLayer>
         <Name>Heatmap</Name>
        <UserStyle>
          <Title>Heatmap</Title>
          <Abstract>A heatmap surface showing population density</Abstract>
          <FeatureTypeStyle>
            <Transformation>
              <ogc:Function name="vec:Heatmap">
                <ogc:Function name="parameter">
                  <ogc:Literal>data</ogc:Literal>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>weightAttr</ogc:Literal>
                  <ogc:Literal>pop2000</ogc:Literal>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>radiusPixels</ogc:Literal>
                  <ogc:Function name="env">
                    <ogc:Literal>radius</ogc:Literal>
                    <ogc:Literal>100</ogc:Literal>
                  </ogc:Function>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>pixelsPerCell</ogc:Literal>
                  <ogc:Literal>10</ogc:Literal>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>outputBBOX</ogc:Literal>
                  <ogc:Function name="env">
                    <ogc:Literal>wms_bbox</ogc:Literal>
                  </ogc:Function>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>outputWidth</ogc:Literal>
                  <ogc:Function name="env">
                    <ogc:Literal>wms_width</ogc:Literal>
                  </ogc:Function>
                </ogc:Function>
                <ogc:Function name="parameter">
                  <ogc:Literal>outputHeight</ogc:Literal>
                  <ogc:Function name="env">
                    <ogc:Literal>wms_height</ogc:Literal>
                  </ogc:Function>
                </ogc:Function>
              </ogc:Function>
            </Transformation>
           <Rule>
             <RasterSymbolizer>
             <!-- specify geometry attribute to pass validation -->
               <Geometry>
                 <ogc:PropertyName>the_geom</ogc:PropertyName></Geometry>
               <Opacity>0.6</Opacity>
               <ColorMap type="ramp" >
                 <ColorMapEntry color="#FFFFFF" quantity="0" label="nodata"
                   opacity="0"/>
                 <ColorMapEntry color="#FFFFFF" quantity="0.02" label="nodata"
                   opacity="0"/>
                 <ColorMapEntry color="#4444FF" quantity=".1" label="nodata"/>
                 <ColorMapEntry color="#FF0000" quantity=".5" label="values" />
                 <ColorMapEntry color="#FFFF00" quantity="1.0" label="values" />
               </ColorMap>
             </RasterSymbolizer>
            </Rule>
          </FeatureTypeStyle>
        </UserStyle>
      </NamedLayer>
     </StyledLayerDescriptor>
```

source : `https://docs.geoserver.org/latest/en/user/styling/sld/extensions/rendering-transform.html`

# /!\ Attention, pensez à changer le nom dans les balises <Name> et <Title> en fonction du nom de votre style.


### Lecture du SLD

https://docs.geoserver.org/latest/en/user/styling/sld/extensions/substitution.html#sld-variable-substitution



### Change opacity of polygon

```
<?xml version="1.0" encoding="ISO-8859-1"?>
     <StyledLayerDescriptor version="1.0.0"
         xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
         xmlns="http://www.opengis.net/sld"
         xmlns:ogc="http://www.opengis.net/ogc"
         xmlns:xlink="http://www.w3.org/1999/xlink"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
       <NamedLayer>
         <Name>ChangePolygonOpacity</Name>
        <UserStyle>
          <Title>ChangePolygonOpacity</Title>
          <Abstract>A SLD which change the opacity of the layer </Abstract>
          <FeatureTypeStyle>   
            <Rule>
              <PolygonSymbolizer>
                <Fill>
                  <CssParameter name="fill">#000080</CssParameter>
                  <CssParameter name="fill-opacity">0.5</CssParameter>
                </Fill>
                <Stroke>
                  <CssParameter name="stroke">#FFFFFF</CssParameter>
                  <CssParameter name="stroke-width">2</CssParameter>
                </Stroke>
              </PolygonSymbolizer>
            </Rule>
          </FeatureTypeStyle>
        </UserStyle>
      </NamedLayer>
     </StyledLayerDescriptor>
```

https://gis.stackexchange.com/search?q=heatmap+polygon