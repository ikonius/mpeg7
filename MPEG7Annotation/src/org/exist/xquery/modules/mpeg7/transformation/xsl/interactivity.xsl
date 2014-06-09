<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001" xmlns:str="http://exslt.org/strings" xmlns:functx="http://www.functx.com" xmlns:xalan="http://xml.apache.org/xalan" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="urn:mpeg:mpeg7:schema:2001 Mpeg7-2001.xsd">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template name="Interaction_Descriptions">
        <xsl:if test="/X3D/Scene/descendant::*[contains(name(.),'Interpolator') or contains(name(.),'Sensor') or contains(name(.),'Trigger') or contains(name(.),'Filter')]">
            <xsl:element name="Collection">
                <xsl:attribute name="xsi:type">
                    <xsl:text>DescriptorCollectionType</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:text>Interactions</xsl:text>
                </xsl:attribute>
                <xsl:for-each select="/X3D/Scene//*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)] | /X3D/Scene/ProtoDeclare/ProtoBody/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]">
                    <xsl:if test="descendant::*[contains(name(.),'Interpolator') or contains(name(.),'Sensor') or contains(name(.),'Trigger') or contains(name(.),'Filter')]">
                        <xsl:element name="DescriptorCollection">
                            <xsl:attribute name="id">
                                <xsl:value-of select="concat('Interaction_',generate-id())"/>
                            </xsl:attribute>
                            <xsl:attribute name="name">
                                <xsl:choose>
                                    <xsl:when test="@DEF != ''">
                                        <xsl:value-of select="concat('Interaction_',@DEF)"/>
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
                            <xsl:for-each select="(.//*)">
                                <xsl:if test="contains(name(.),'Interpolator')">
                                    <xsl:choose>
                                        <xsl:when test="@USE">
                                            <xsl:variable name="Interpolator_DEF" select="@USE"/>
                                            <xsl:value-of select="//*[contains(name(.),'Interpolator')]/@DEF=$Interpolator_DEF"/>
                                            <xsl:element name="Descriptor">
                                                <xsl:attribute name="xsi:type">
                                                    <xsl:text>MotionTrajectoryType</xsl:text>
                                                </xsl:attribute>
                                                <xsl:attribute name="motionType">
                                                    <xsl:value-of select="name(.)"/>
                                                </xsl:attribute>
                                                <xsl:element name="CoordDef">
                                                    <xsl:attribute name="units">
                                                        <xsl:text>meter</xsl:text>
                                                    </xsl:attribute>
                                                </xsl:element>
                                                <xsl:element name="Params">
                                                    <xsl:element name="KeyTimePoint">
                                                        <xsl:for-each select="tokenize(@key,' ')">
                                                            <xsl:element name="MediaRelIncrTimePoint">
                                                                <xsl:value-of select="number(.)"/>
                                                            </xsl:element>
                                                        </xsl:for-each>
                                                    </xsl:element>
                                                    <xsl:element name="InterpolationFunctions">
                                                        <xsl:for-each select="tokenize(@keyValue, ' ')">
                                                            <xsl:element name="KeyValue">
                                                                <xsl:value-of select="number(.)"/>
                                                            </xsl:element>
                                                        </xsl:for-each>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:element name="Descriptor">
                                                <xsl:attribute name="xsi:type">
                                                    <xsl:text>MotionTrajectoryType</xsl:text>
                                                </xsl:attribute>
                                                <xsl:attribute name="motionType">
                                                    <xsl:value-of select="name(.)"/>
                                                </xsl:attribute>
                                                <xsl:element name="CoordDef">
                                                    <xsl:attribute name="units">
                                                        <xsl:text>meter</xsl:text>
                                                    </xsl:attribute>
                                                </xsl:element>
                                                <xsl:element name="Params">
                                                    <xsl:element name="KeyTimePoint">
                                                        <xsl:for-each select="tokenize(@key,' ')">
                                                            <xsl:element name="MediaRelIncrTimePoint">
                                                                <xsl:value-of select="number(.)"/>
                                                            </xsl:element>
                                                        </xsl:for-each>
                                                    </xsl:element>
                                                    <xsl:element name="InterpolationFunctions">
                                                        <xsl:for-each select="tokenize(@keyValue, ' ')">
                                                            <xsl:element name="KeyValue">
                                                                <xsl:value-of select="number(.)"/>
                                                            </xsl:element>
                                                        </xsl:for-each>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select=".//ROUTE">
                                <xsl:variable name="from_node" select="@fromNode"/>
                                <xsl:variable name="to_node" select="@toNode"/>
                                <xsl:element name="Descriptor">
                                    <xsl:attribute name="xsi:type">
                                        <xsl:text>Interactivity3DType</xsl:text>
                                    </xsl:attribute>
                                    <xsl:element name="TriggerSource">
                                        <xsl:choose>
                                            <xsl:when test="name(/X3D/Scene/descendant::*[@DEF=$from_node])='Script'">
                                                <xsl:choose>
                                                    <xsl:when test="/X3D/Scene/descendant::*[@DEF=$from_node]/@url">
                                                        <xsl:text>ExternalScript</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:text>InternalScript</xsl:text>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>UserDefined</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                    <xsl:element name="Route">
                                        <xsl:attribute name="fromNode">
                                            <xsl:value-of select="$from_node"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="fromNodeType">
                                            <xsl:value-of select="name(/X3D/Scene/descendant::*[@DEF=$from_node])"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="toNode">
                                            <xsl:value-of select="$to_node"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="toNodeType">
                                            <xsl:value-of select="name(/X3D/Scene/descendant::*[@DEF=$to_node])"/>
                                        </xsl:attribute>
                                        <xsl:text>/X3D/Scene</xsl:text>
                                        <xsl:for-each select="ancestor-or-self::*">
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
                                        <xsl:for-each select="descendant-or-self::ROUTE">
                                            <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::ROUTE),']')"/>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                        <xsl:element name="DescriptorCollectionRef">
                            <xsl:attribute name="href">
                                <xsl:choose>
                                    <xsl:when test="@DEF != ''">
                                        <xsl:value-of select="concat('#',@DEF)"/>
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
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="/X3D/Scene | /X3D/Scene/ProtoDeclare/ProtoBody">
                    <xsl:if test="child::*[contains(name(.),'Interpolator') or contains(name(.),'Sensor') or contains(name(.),'Trigger') or contains(name(.),'Filter')]">
                        <xsl:element name="DescriptorCollection">
                            <xsl:attribute name="id">
                                <xsl:value-of select="concat('Interaction_',generate-id())"/>
                            </xsl:attribute>
                            <xsl:attribute name="name">
                                <xsl:text>Scene</xsl:text>
                            </xsl:attribute>
                            <xsl:for-each select="(./*)">
                                <xsl:if test="contains(name(.),'Interpolator')">
                                    <xsl:choose>
                                        <xsl:when test="@USE">
                                            <xsl:variable name="Interpolator_DEF" select="@USE"/>
                                            <xsl:variable name="Interpolator_Path" select="/X3D/Scene//*[(contains(name(.),'Interpolator')) and (@DEF=$Interpolator_DEF)]"/>
                                            <xsl:element name="Descriptor">
                                                <xsl:attribute name="xsi:type">
                                                    <xsl:text>MotionTrajectoryType</xsl:text>
                                                </xsl:attribute>
                                                <xsl:attribute name="motionType">
                                                    <xsl:value-of select="name($Interpolator_Path)"/>
                                                </xsl:attribute>
                                                <xsl:element name="CoordDef">
                                                    <xsl:attribute name="units">
                                                        <xsl:text>meter</xsl:text>
                                                    </xsl:attribute>
                                                </xsl:element>
                                                <xsl:element name="Params">
                                                    <xsl:element name="KeyTimePoint">
                                                        <xsl:for-each select="tokenize($Interpolator_Path/@key,' ')">
                                                            <xsl:element name="MediaRelIncrTimePoint">
                                                                <xsl:value-of select="number(.)"/>
                                                            </xsl:element>
                                                        </xsl:for-each>
                                                    </xsl:element>
                                                    <xsl:element name="InterpolationFunctions">
                                                        <xsl:for-each select="tokenize($Interpolator_Path/@keyValue, ' ')">
                                                            <xsl:element name="KeyValue">
                                                                <xsl:value-of select="number(.)"/>
                                                            </xsl:element>
                                                        </xsl:for-each>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:element name="Descriptor">
                                                <xsl:attribute name="xsi:type">
                                                    <xsl:text>MotionTrajectoryType</xsl:text>
                                                </xsl:attribute>
                                                <xsl:attribute name="motionType">
                                                    <xsl:value-of select="name(.)"/>
                                                </xsl:attribute>
                                                <xsl:element name="CoordDef">
                                                    <xsl:attribute name="units">
                                                        <xsl:text>meter</xsl:text>
                                                    </xsl:attribute>
                                                </xsl:element>
                                                <xsl:element name="Params">
                                                    <xsl:element name="KeyTimePoint">
                                                        <xsl:for-each select="tokenize(@key,' ')">
                                                            <xsl:element name="MediaRelIncrTimePoint">
                                                                <xsl:value-of select="number(.)"/>
                                                            </xsl:element>
                                                        </xsl:for-each>
                                                    </xsl:element>
                                                    <xsl:element name="InterpolationFunctions">
                                                        <xsl:for-each select="tokenize(@keyValue, ' ')">
                                                            <xsl:element name="KeyValue">
                                                                <xsl:value-of select="number(.)"/>
                                                            </xsl:element>
                                                        </xsl:for-each>
                                                    </xsl:element>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="./ROUTE">
                                <xsl:variable name="from_node" select="@fromNode"/>
                                <xsl:variable name="to_node" select="@toNode"/>
                                <xsl:element name="Descriptor">
                                    <xsl:attribute name="xsi:type">
                                        <xsl:text>Interactivity3DType</xsl:text>
                                    </xsl:attribute>
                                    <xsl:element name="TriggerSource">
                                        <xsl:choose>
                                            <xsl:when test="name(/X3D/Scene/descendant::*[@DEF=$from_node])='Script'">
                                                <xsl:choose>
                                                    <xsl:when test="/X3D/Scene/descendant::*[@DEF=$from_node]/@url">
                                                        <xsl:text>ExternalScript</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:text>InternalScript</xsl:text>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>UserDefined</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:element>
                                    <xsl:element name="Route">
                                        <xsl:attribute name="fromNode">
                                            <xsl:value-of select="$from_node"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="fromNodeType">
                                            <xsl:value-of select="name(/X3D/Scene/descendant::*[@DEF=$from_node])"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="toNode">
                                            <xsl:value-of select="$to_node"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="toNodeType">
                                            <xsl:value-of select="name(/X3D/Scene/descendant::*[@DEF=$to_node])"/>
                                        </xsl:attribute>
                                        <xsl:text>/X3D/Scene</xsl:text>
                                        <xsl:for-each select="ancestor-or-self::*">
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
                                        <xsl:for-each select="descendant-or-self::ROUTE">
                                            <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::ROUTE),']')"/>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                        <xsl:element name="DescriptorCollectionRef">
                            <xsl:attribute name="href">
                                <xsl:text>#Scene</xsl:text>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>