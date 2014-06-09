<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001" xmlns:str="http://exslt.org/strings" xmlns:functx="http://www.functx.com" xmlns:xalan="http://xml.apache.org/xalan" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="urn:mpeg:mpeg7:schema:2001 Mpeg7-2001.xsd">
    <xsl:import href="geometry_helpers.xsl" xml:base="http://54.72.206.163/exist/apps/annotation/modules/"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>    
    <xsl:param name="IFSPointsExtraction"/>
    <xsl:param name="ILSPointsExtraction"/>
    <xsl:param name="extrusionPointsExtraction"/>
    <xsl:param name="extrusionBBoxParams"/>
    <xsl:param name="EHDs"/>
    <xsl:param name="SCDs"/>
    <xsl:template name="Geometry_Descriptions">
        <xsl:if test="//Shape">
            <xsl:element name="Collection" xsi:type="DescriptorCollectionType">
                <xsl:attribute name="xsi:type">
                    <xsl:text>DescriptorCollectionType</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:text>Geometries</xsl:text>
                </xsl:attribute>
                <xsl:for-each select="/X3D/Scene//*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)] | /X3D/Scene/ProtoDeclare/ProtoBody/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]">
                    <xsl:element name="DescriptorCollection">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('Geometry_',generate-id())"/>
                        </xsl:attribute>
                        <xsl:attribute name="name">
                            <xsl:choose>
                                <xsl:when test="@DEF != ''">
                                    <xsl:value-of select="concat('Geometry_',@DEF)"/>
                                </xsl:when>
                                <xsl:when test="@USE != ''">
                                    <xsl:value-of select="concat('Geometry_',@USE)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="self::Transform">
                                        <xsl:text>Transform_</xsl:text>
                                        <xsl:number count="Transform" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::Group">
                                        <xsl:text>Group_</xsl:text>
                                        <xsl:number count="Group" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::Anchor">
                                        <xsl:text>Anchor_</xsl:text>
                                        <xsl:number count="Anchor" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::Collision">
                                        <xsl:text>Collision_</xsl:text>
                                        <xsl:number count="Collision" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::Billboard">
                                        <xsl:text>Billboard_</xsl:text>
                                        <xsl:number count="Billboard" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::LOD">
                                        <xsl:text>LOD_</xsl:text>
                                        <xsl:number count="LOD" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::Switch">
                                        <xsl:text>Switch_</xsl:text>
                                        <xsl:number count="Switch" from="Scene" level="single"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="(.//Group/@USE) or (.//Transform/@USE)  or (.//Anchor/@USE) or (.//Collision/@USE) or (.//Billboard/@USE) or (.//LOD/@USE) or (.//Switch/@USE)">
                                <xsl:variable name="DEF" select="(.//Transform/@USE) | (.//Group/@USE) | (.//Anchor/@USE) | (.//Collision/@USE) | (.//Billboard/@USE) | (.//LOD/@USE) | (.//Switch/@USE)"/>
                                <xsl:for-each select="(/X3D/Scene//Transform[@DEF=$DEF]//Shape) | (/X3D/Scene//Group[@DEF=$DEF]//Shape) | (/X3D/Scene//Anchor[@DEF=$DEF]//Shape) | (/X3D/Scene//Collision[@DEF=$DEF]//Shape) | (/X3D/Scene//Billboard[@DEF=$DEF]//Shape) | (/X3D/Scene//LOD[@DEF=$DEF]//Shape) |(/X3D/Scene//Switch[@DEF=$DEF]//Shape)">
                                    <xsl:call-template name="Geometry_descriptors">
                                        <xsl:with-param name="path" select="."/>
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select=".//Shape">
                                    <xsl:choose>
                                        <xsl:when test="@USE">
                                            <xsl:variable name="sh_DEF" select="@USE"/>
                                            <xsl:call-template name="Geometry_descriptors">
                                                <xsl:with-param name="path" select="//Shape[$sh_DEF=@DEF]"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="Geometry_descriptors">
                                                <xsl:with-param name="path" select="."/>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:element name="DescriptorCollectionRef">
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="@DEF != ''">
                                    <xsl:value-of select="concat('#',@DEF)"/>
                                </xsl:when>
                                <xsl:when test="@USE != ''">
                                    <xsl:value-of select="concat('#',@USE)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="self::Transform">
                                        <xsl:text>#Transform_</xsl:text>
                                        <xsl:number count="Transform" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::Group">
                                        <xsl:text>#Group_</xsl:text>
                                        <xsl:number count="Group" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::Anchor">
                                        <xsl:text>#Anchor_</xsl:text>
                                        <xsl:number count="Anchor" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::Collision">
                                        <xsl:text>#Collision_</xsl:text>
                                        <xsl:number count="Collision" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::Billboard">
                                        <xsl:text>#Billboard_</xsl:text>
                                        <xsl:number count="Billboard" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::LOD">
                                        <xsl:text>#LOD_</xsl:text>
                                        <xsl:number count="LOD" from="Scene" level="single"/>
                                    </xsl:if>
                                    <xsl:if test="self::Switch">
                                        <xsl:text>#Switch_</xsl:text>
                                        <xsl:number count="Switch" from="Scene" level="single"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
                <xsl:for-each select="//Shape[(not(parent::Transform)) and (not(parent::Group)) and (not(parent::Anchor)) and (not(parent::Collision)) and (not(parent::Billboard)) and (not(parent::LOD)) and (not(parent::Switch))]">
                    <xsl:element name="DescriptorCollection">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('Geometry_',generate-id())"/>
                        </xsl:attribute>
                        <xsl:attribute name="name">
                            <xsl:choose>
                                <xsl:when test="@DEF != ''">
                                    <xsl:value-of select="concat('Geometry_',@DEF)"/>
                                </xsl:when>
                                <xsl:when test="@USE != ''">
                                    <xsl:value-of select="concat('Geometry_',@USE)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="self::Shape">
                                        <xsl:text>Shape_</xsl:text>
                                        <xsl:number count="Shape" from="Scene" level="single"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="@USE">
                                <xsl:variable name="sh_DEF" select="@USE"/>
                                <xsl:call-template name="Geometry_descriptors">
                                    <xsl:with-param name="path" select="//Shape[$sh_DEF=@DEF]"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="Geometry_descriptors">
                                    <xsl:with-param name="path" select="."/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:element name="DescriptorCollectionRef">
                        <xsl:attribute name="href">
                            <xsl:choose>
                                <xsl:when test="@DEF != ''">
                                    <xsl:value-of select="concat('#',@DEF)"/>
                                </xsl:when>
                                <xsl:when test="@USE != ''">
                                    <xsl:value-of select="concat('#',@USE)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="self::Shape">
                                        <xsl:text>#Shape_</xsl:text>
                                        <xsl:number count="Shape" from="Scene" level="single"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="Geometry_descriptors">
        <xsl:param name="path"/>
        <xsl:if test="contains(name($path/child::*),'Metadata')">
            <xsl:variable name="metaPath" select="$path/child::*"/>
            <xsl:element name="Descriptor">
                <xsl:attribute name="xsi:type">
                    <xsl:text>Metadata3DType</xsl:text>
                </xsl:attribute>
                <xsl:if test="$metaPath/attribute::name">
                    <xsl:element name="name">
                        <xsl:value-of select="$metaPath/attribute::name"/>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="type">
                    <xsl:value-of select="name($metaPath)"/>
                </xsl:element>
                <xsl:element name="value">
                    <xsl:choose>
                        <xsl:when test="contains(name($metaPath),'MetadataSet')">
                            <xsl:variable name="internalMetaPath" select="$metaPath/child::*"/>
                            <xsl:for-each select="$metaPath/*">
                                <xsl:if test="./attribute::name">
                                    <xsl:element name="name">
                                        <xsl:value-of select="./attribute::name"/>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:element name="type">
                                    <xsl:value-of select="name(.)"/>
                                </xsl:element>
                                <xsl:element name="value">
                                    <xsl:choose>
                                        <xsl:when test="contains(name(.),'MetadataSet')">
                                            <xsl:text>Internal MetadataSet</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="./attribute::value"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:element>
                                <xsl:if test="./attribute::reference">
                                    <xsl:element name="reference">
                                        <xsl:value-of select="./attribute::reference"/>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$metaPath/attribute::value"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:if test="$metaPath/attribute::reference">
                    <xsl:element name="reference">
                        <xsl:value-of select="$metaPath/attribute::reference"/>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="Ref">
                    <xsl:text>/X3D/Scene</xsl:text>
                    <xsl:for-each select="ancestor::*">
                        <xsl:if test="name() = 'Transform'">
                            <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::Transform),']')"/>
                        </xsl:if>
                        <xsl:if test="name() = 'Group'">
                            <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::Group),']')"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="descendant-or-self::Shape">
                        <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::Shape),']')"/>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:if>
        <xsl:variable name="GeometryType" select="name($path/child::*[(not(self::Appearance)) and (not(contains(name(.),'Metadata')))])"/>
        <xsl:if test="not($GeometryType = 'Text')">
            <xsl:element name="Descriptor">
                <xsl:attribute name="xsi:type">
                    <xsl:text>BoundingBox3DType</xsl:text>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="$GeometryType = 'Box'">
                        <xsl:element name="BoundingBox3DSize">
                            <xsl:choose>
                                <xsl:when test="not((./descendant::Box/attribute::size) = '2 2 2')">
                                    <xsl:attribute name="BoxWidth">
                                        <xsl:value-of select="tokenize(./descendant::Box/attribute::size, ' ')[1]"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="BoxHeight">
                                        <xsl:value-of select="tokenize(./descendant::Box/attribute::size, ' ')[2]"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="BoxDepth">
                                        <xsl:value-of select="tokenize(./descendant::Box/attribute::size, ' ')[3]"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="BoxWidth">
                                        <xsl:value-of select="2"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="BoxHeight">
                                        <xsl:value-of select="2"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="BoxDepth">
                                        <xsl:value-of select="2"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        <xsl:element name="BoundingBox3DCenter">
                            <xsl:attribute name="BoxCenterW">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxCenterH">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxCenterD">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$GeometryType = 'Cone'">
                        <xsl:element name="BoundingBox3DSize">
                            <xsl:attribute name="BoxWidth">
                                <xsl:choose>
                                    <xsl:when test="not((./descendant::Cone/attribute::bottomRadius) = '1')">
                                        <xsl:value-of select="(./descendant::Cone/attribute::bottomRadius) * 2"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="1"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="BoxHeight">
                                <xsl:choose>
                                    <xsl:when test="not((./descendant::Cone/attribute::height) = '2')">
                                        <xsl:value-of select="./descendant::Cone/attribute::height"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="2"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="BoxDepth">
                                <xsl:choose>
                                    <xsl:when test="not((./descendant::Cone/attribute::bottomRadius) = '1')">
                                        <xsl:value-of select="(./descendant::Cone/attribute::bottomRadius) * 2"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="1"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="BoundingBox3DCenter">
                            <xsl:attribute name="BoxCenterW">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxCenterH">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxCenterD">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$GeometryType = 'Cylinder'">
                        <xsl:element name="BoundingBox3DSize">
                            <xsl:attribute name="BoxWidth">
                                <xsl:choose>
                                    <xsl:when test="not((./descendant::Cylinder/attribute::radius) = '1')">
                                        <xsl:value-of select="(./descendant::Cylinder/attribute::radius) * 2"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="1"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="BoxHeight">
                                <xsl:choose>
                                    <xsl:when test="not((./descendant::Cylinder/attribute::height) = '2')">
                                        <xsl:value-of select="./descendant::Cylinder/attribute::height"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="2"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="BoxDepth">
                                <xsl:choose>
                                    <xsl:when test="not((./descendant::Cylinder/attribute::radius) = '1')">
                                        <xsl:value-of select="(./descendant::Cylinder/attribute::radius) * 2"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="1"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="BoundingBox3DCenter">
                            <xsl:attribute name="BoxCenterW">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxCenterH">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxCenterD">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$GeometryType = 'Sphere'">
                        <xsl:element name="BoundingBox3DSize">
                            <xsl:choose>
                                <xsl:when test="not((./descendant::Sphere/attribute::radius) = '1')">
                                    <xsl:attribute name="BoxWidth">
                                        <xsl:value-of select="(./descendant::Sphere/attribute::radius) * 2"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="BoxHeight">
                                        <xsl:value-of select="(./descendant::Sphere/attribute::radius) * 2"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="BoxDepth">
                                        <xsl:value-of select="(./descendant::Sphere/attribute::radius) * 2"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="BoxWidth">
                                        <xsl:value-of select="1"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="BoxHeight">
                                        <xsl:value-of select="1"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="BoxDepth">
                                        <xsl:value-of select="1"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                        <xsl:element name="BoundingBox3DCenter">
                            <xsl:attribute name="BoxCenterW">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxCenterH">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxCenterD">
                                <xsl:value-of select="0"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="($GeometryType = 'IndexedFaceSet') or ($GeometryType = 'IndexedLineSet')">
                        <xsl:variable name="pointCoordinates" select="./descendant::Coordinate/attribute::point"/>
                        <!--<xsl:element name="TEST_POINTS"><xsl:value-of select="$pointCoordinates"/></xsl:element><xsl:element name="POINTS_BY_POINTS"><xsl:variable name="totalPoints" select="tokenize($pointCoordinates, ' ')"/><xsl:for-each select="$totalPoints"><xsl:element name="pointo"><xsl:value-of select="normalize-space(.)"/></xsl:element></xsl:for-each></xsl:element>-->
                        <xsl:variable name="pointsNumber" select="count(tokenize($pointCoordinates, ' '))"/>
                        <!--KALEI ENA TEPLATE GIA THN EYRESI TON MAX KAI MIN TOY X APO TO ATTRIBUTE
                        point TOY NODE Coordinate ENOS IndexedFaceSet. OLA TA TEMPLATE PERIKLEIONTAI
                        SE ENA XEXORISTO VARIABLE POU PERIEXEI TA MIN KAI MAX KATHE AXIS POINT-->
                        <xsl:variable name="XpointsResults">
                            <xsl:call-template name="pointsCalculationX">
                                <xsl:with-param name="count" select="$pointsNumber - 2"/>
                                <xsl:with-param name="count2" select="$pointCoordinates"/>
                                <xsl:with-param name="Xpoint" select="number(tokenize($pointCoordinates, ' ')[$pointsNumber - 2])"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <!--KALEI ENA TEPLATE GIA THN EYRESI TON MAX KAI MIN TOY Y APO TO ATTRIBUTE
                        point TOY NODE Coordinate ENOS IndexedFaceSet-->
                        <xsl:variable name="YpointsResults">
                            <xsl:call-template name="pointsCalculationY">
                                <xsl:with-param name="count" select="$pointsNumber - 1"/>
                                <xsl:with-param name="count2" select="$pointCoordinates"/>
                                <xsl:with-param name="Ypoint" select="number(tokenize($pointCoordinates, ' ')[$pointsNumber - 1])"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <!--KALEI ENA TEPLATE GIA THN EYRESI TON MAX KAI MIN TOY Z APO TO ATTRIBUTE
                        point TOY NODE Coordinate ENOS IndexedFaceSet-->
                        <xsl:variable name="ZpointsResults">
                            <xsl:call-template name="pointsCalculationZ">
                                <xsl:with-param name="count" select="$pointsNumber"/>
                                <xsl:with-param name="count2" select="$pointCoordinates"/>
                                <xsl:with-param name="Zpoint" select="number(tokenize($pointCoordinates, ' ')[$pointsNumber])"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:element name="BoundingBox3DSize">
                            <xsl:attribute name="BoxWidth">
                                <xsl:value-of select="tokenize($XpointsResults, ' ')[2] - tokenize($XpointsResults, ' ')[1]"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxHeight">
                                <xsl:value-of select="tokenize($YpointsResults, ' ')[2] - tokenize($YpointsResults, ' ')[1]"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxDepth">
                                <xsl:value-of select="tokenize($ZpointsResults, ' ')[2] - tokenize($ZpointsResults, ' ')[1]"/>
                            </xsl:attribute>
                        </xsl:element>
                        <xsl:element name="BoundingBox3DCenter">
                            <xsl:attribute name="BoxCenterW">
                                <xsl:value-of select="(tokenize($XpointsResults, ' ')[1] + tokenize($XpointsResults, ' ')[2]) div 2"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxCenterH">
                                <xsl:value-of select="(tokenize($YpointsResults, ' ')[1] + tokenize($YpointsResults, ' ')[2]) div 2"/>
                            </xsl:attribute>
                            <xsl:attribute name="BoxCenterD">
                                <xsl:value-of select="(tokenize($ZpointsResults, ' ')[1] + tokenize($ZpointsResults, ' ')[2]) div 2"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$GeometryType = 'Extrusion'">
                        <xsl:variable name="positionOfExtrForBBox" select="count(preceding::Extrusion) + 1"/>
                        <xsl:call-template name="extrusionBBoxTemplate">
                            <xsl:with-param name="stringOfExtrBBox" select="tokenize($extrusionBBoxParams, '#')[$positionOfExtrForBBox]"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
        <xsl:element name="Descriptor">
            <xsl:attribute name="xsi:type">
                <xsl:text>Geometry3DType</xsl:text>
            </xsl:attribute>
            <xsl:element name="Geometry3D">
                <xsl:attribute name="ObjectType">
                    <xsl:value-of select="name($path/child::*[(not(self::Appearance)) and (not(contains(name(.),'Metadata')))])"/>
                </xsl:attribute>
                <xsl:if test="$path/child::*[not(self::Appearance)]/attribute::DEF">
                    <xsl:attribute name="DEF">
                        <xsl:value-of select="$path/child::*[not(self::Appearance)]/attribute::DEF"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="$path/child::*[not(self::Appearance)]/attribute::convex">
                    <xsl:attribute name="convex">
                        <xsl:value-of select="$path/child::*[not(self::Appearance)]/attribute::convex"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="$path/child::*[not(self::Appearance)]/attribute::creaseAngle">
                    <xsl:attribute name="creaseAngle">
                        <xsl:value-of select="$path/child::*[not(self::Appearance)]/attribute::creaseAngle"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="$path/descendant::Material/attribute::diffuseColor">
                        <xsl:variable name="checkColor" select="$path/descendant::Material/attribute::diffuseColor"/>
                        <xsl:element name="DominantColor3D">
                            <xsl:attribute name="xsi:type">
                                <xsl:text>DominantColorType</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="SpatialCoherency">
                                <xsl:text>0</xsl:text>
                            </xsl:element>
                            <xsl:element name="Value">
                                <xsl:element name="Percentage">
                                    <xsl:text>1</xsl:text>
                                </xsl:element>
                                <xsl:element name="Index">
                                    <xsl:value-of select="ceiling((number(tokenize($checkColor, ' ')[1])) * 255)"/>
                                    <xsl:text/>
                                    <xsl:value-of select="ceiling((number(tokenize($checkColor, ' ')[2])) * 255)"/>
                                    <xsl:text/>
                                    <xsl:value-of select="ceiling((number(tokenize($checkColor, ' ')[3])) * 255)"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="$path/descendant::Material">
                        <xsl:element name="DominantColor3D">
                            <xsl:attribute name="xsi:type">
                                <xsl:text>DominantColorType</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="SpatialCoherency">
                                <xsl:text>0</xsl:text>
                            </xsl:element>
                            <xsl:element name="Value">
                                <xsl:element name="Percentage">
                                    <xsl:text>1</xsl:text>
                                </xsl:element>
                                <xsl:element name="Index">
                                    <xsl:value-of select="ceiling(number(0.8) * 255)"/>
                                    <xsl:text/>
                                    <xsl:value-of select="ceiling(number(0.8) * 255)"/>
                                    <xsl:text/>
                                    <xsl:value-of select="ceiling(number(0.8) * 255)"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="$GeometryType = 'IndexedFaceSet'">
                    <!--AUTO EDO MOU EBGALE TIN PISTI GIA NA MHN PO TPT XEIROETERO,
                    METRAEI POSA IndexedFaceSet YPARXOYN PRIN APO AUTO POU BRISKEI KAI
                    KALEI TO TEMPLATE ME PARAM+1 OSTE NA SPASEI THN GLOBAL VARIABLE
                    pointsExtraction STO ANTISTOIXO KOMMATI POY ANTISTOIXEI. EPISIS
                    MPOREI KAI DIAKRINEI SOSTA TA USE ATTRIBUTES OPOS KAI AN EINAI.-->
                    <xsl:variable name="positionOfIFS" select="count(preceding::IndexedFaceSet) + 1"/>
                    <xsl:call-template name="shapeExtraction">
                        <xsl:with-param name="stringOfIFS" select="tokenize($IFSPointsExtraction, '#')[$positionOfIFS]"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="$GeometryType = 'IndexedLineSet'">
                    <!--TO IDIO GIA IndexedLineSet.-->
                    <xsl:variable name="positionOfILS" select="count(preceding::IndexedLineSet) + 1"/>
                    <xsl:call-template name="shapeExtraction">
                        <xsl:with-param name="stringOfIFS" select="tokenize($ILSPointsExtraction, '#')[$positionOfILS]"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:if test="$GeometryType = 'Extrusion'">
                    <!--TO IDIO GIA EXTRUSION.-->
                    <xsl:variable name="positionOfExtr" select="count(preceding::Extrusion) + 1"/>
                    <xsl:call-template name="extrusionShapeExtraction">
                        <xsl:with-param name="stringOfExtr" select="tokenize($extrusionPointsExtraction, '#')[$positionOfExtr]"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:element>
            <xsl:if test="contains(name($path/child::*[not(self::Appearance)]/child::*),'Metadata')">
                <xsl:variable name="curPath" select="$path/child::*[not(self::Appearance)]/child::*"/>
                <xsl:element name="Metadata3D">
                    <xsl:if test="$curPath/attribute::name">
                        <xsl:element name="name">
                            <xsl:value-of select="$curPath/attribute::name"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="type">
                        <xsl:value-of select="name($curPath)"/>
                    </xsl:element>
                    <xsl:element name="value">
                        <xsl:choose>
                            <xsl:when test="contains(name($curPath),'MetadataSet')">
                                <xsl:variable name="internalPath" select="$curPath/child::*"/>
                                <xsl:for-each select="$curPath/*">
                                    <xsl:if test="./attribute::name">
                                        <xsl:element name="name">
                                            <xsl:value-of select="./attribute::name"/>
                                        </xsl:element>
                                    </xsl:if>
                                    <xsl:element name="type">
                                        <xsl:value-of select="name(.)"/>
                                    </xsl:element>
                                    <xsl:element name="value">
                                        <xsl:choose>
                                            <xsl:when test="contains(name(.),'MetadataSet')">
                                                <xsl:text>Internal MetadataSet</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="./attribute::value"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                    <xsl:if test="./attribute::reference">
                                        <xsl:element name="reference">
                                            <xsl:value-of select="./attribute::reference"/>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$curPath/attribute::value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:if test="$curPath/attribute::reference">
                        <xsl:element name="reference">
                            <xsl:value-of select="$curPath/attribute::reference"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="Ref">
                        <xsl:text>/X3D/Scene</xsl:text>
                        <xsl:for-each select="ancestor::*">
                            <xsl:if test="name() = 'Transform'">
                                <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::Transform),']')"/>
                            </xsl:if>
                            <xsl:if test="name() = 'Group'">
                                <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::Group),']')"/>
                            </xsl:if>
                            <xsl:if test="name() = 'Anchor'">
                                <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::Anchor),']')"/>
                            </xsl:if>
                            <xsl:if test="name() = 'Collision'">
                                <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::Collision),']')"/>
                            </xsl:if>
                            <xsl:if test="name() = 'Billboard'">
                                <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::Billboard),']')"/>
                            </xsl:if>
                            <xsl:if test="name() = 'LOD'">
                                <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::LOD),']')"/>
                            </xsl:if>
                            <xsl:if test="name() = 'Switch'">
                                <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::Switch),']')"/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="descendant-or-self::Shape">
                            <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::Shape),']')"/>
                        </xsl:for-each>
                        <xsl:for-each select="descendant::*[not(self::Appearance) and child::*['Metadata']]">
                            <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::Shape),']')"/>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:element>
        <xsl:if test="string-length($EHDs) &gt; 0">                                                
            <xsl:apply-templates select="$path/descendant::ImageTexture">                
                <xsl:with-param name="position" select="position()"/>               
            </xsl:apply-templates>           
        </xsl:if>
    </xsl:template>
    <xsl:template match="ImageTexture">                
        <xsl:param name="position"/>
        <xsl:element name="Descriptor">
            <xsl:attribute name="xsi:type">
                <xsl:text>EdgeHistogramType</xsl:text>
            </xsl:attribute>
            <xsl:element name="BinCounts">                       
                <xsl:value-of select="tokenize(tokenize($EHDs,'#')[$position],':')[last()]"/>                
            </xsl:element>
        </xsl:element> 
        <xsl:variable name="SCDescrs" select="tokenize($SCDs,'#')[$position]"/>
        <xsl:variable name="SCParts" select="tokenize(tokenize($SCDescrs,':')[last()],';')"/>
        <xsl:element name="Descriptor">
            <xsl:attribute name="xsi:type">
                <xsl:text>ScalableColorType</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="numOfCoeff" select="$SCParts[2]"/>
            <xsl:attribute name="numOfBitplanesDiscarded" select="$SCParts[1]"/>
            <xsl:element name="Coeff">                    
                <xsl:value-of select="$SCParts[last()]"/>
            </xsl:element>
        </xsl:element>        
    </xsl:template>
</xsl:stylesheet>