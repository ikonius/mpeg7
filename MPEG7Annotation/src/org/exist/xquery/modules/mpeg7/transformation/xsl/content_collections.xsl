<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001" xmlns:str="http://exslt.org/strings" xmlns:functx="http://www.functx.com" xmlns:xalan="http://xml.apache.org/xalan" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="urn:mpeg:mpeg7:schema:2001 Mpeg7-2001.xsd">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template name="Declare_All_Transforms">
        <xsl:if test="//Shape | //Transform | //Group">
            <xsl:element name="Collection">
                <xsl:attribute name="xsi:type">
                    <xsl:text>ContentCollectionType</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:text>Transformations</xsl:text>
                </xsl:attribute>
                <xsl:apply-templates select="/X3D/Scene/*"/>
                <xsl:apply-templates select="//Shape[(not(parent::Transform)) and (not(parent::Group)) and (not(parent::Anchor)) and (not(parent::Collision)) and (not(parent::Billboard)) and (not(parent::LOD)) and (not(parent::Switch))]" mode="topLevel"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="Transform | Group | Anchor | Collision | Billboard | LOD | Switch | ProtoDeclare/ProtoBody/Transform | ProtoDeclare/ProtoBody/Group | ProtoDeclare/ProtoBody/Anchor | ProtoDeclare/ProtoBody/Collision | ProtoDeclare/ProtoBody/Billboard | ProtoDeclare/ProtoBody/LOD | ProtoDeclare/ProtoBody/Switch">
        <xsl:element name="ContentCollection">
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="self::Switch">
                        <xsl:value-of select="concat(name(),'es_',generate-id())"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(name(),'s_',generate-id())"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="string-length(@DEF) != 0">
                        <xsl:value-of select="@DEF"/>
                    </xsl:when>
                    <xsl:when test="string-length(@USE) != 0">
                        <xsl:value-of select="@USE"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(name(),'_')"/>
                        <xsl:variable name="nodeName" select="name()"/>
                        <xsl:number count="node()[name()=$nodeName]" from="Scene" level="single"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:element name="Content" xsi:type="MultimediaType">
                <xsl:attribute name="xsi:type">
                    <xsl:text>MultimediaType</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="concat(name(),'_',generate-id())"/>
                </xsl:attribute>
                <xsl:element name="Multimedia">
                    <xsl:element name="MediaLocator">
                        <xsl:element name="MediaUri">
                            <xsl:text>/X3D/Scene</xsl:text>
                            <xsl:variable name="nodeName" select="name()"/>
                            <xsl:for-each select="ancestor-or-self::*">
                                <xsl:value-of select="concat('/',name(),'[',1+count(preceding-sibling::node()[name()=$nodeName]),']')"/>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:apply-templates select=".//Transform | .//Group | .//Anchor | .//Collision | .//Billboard | .//LOD | .//Switch"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="Shape" mode="topLevel">
        <xsl:element name="ContentCollection">
            <xsl:attribute name="id">
                <xsl:if test="self::Shape">
                    <xsl:value-of select="concat(name(),'s_',generate-id())"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="string-length(@DEF) != 0">
                        <xsl:value-of select="@DEF"/>
                    </xsl:when>
                    <xsl:when test="string-length(@USE) != 0">
                        <xsl:value-of select="@USE"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(name(),_)"/>
                        <xsl:variable name="nodeName" select="name()"/>
                        <xsl:number count="node()[name()=$nodeName]" from="Scene" level="single"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:element name="Content" xsi:type="MultimediaType">
                <xsl:attribute name="xsi:type">
                    <xsl:text>MultimediaType</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="concat(name(),'_',generate-id())"/>
                </xsl:attribute>
                <xsl:element name="Multimedia">
                    <xsl:element name="MediaLocator">
                        <xsl:element name="MediaUri">
                            <xsl:text>/X3D/Scene</xsl:text>
                            <xsl:for-each select="ancestor-or-self::*">
                                <xsl:variable name="curNode" select="name(.)"/>
                                <xsl:if test="name() = 'Shape'">
                                    <xsl:value-of select="concat('/',name(),'[',1+count(./preceding-sibling::Shape),']')"/>
                                </xsl:if>
                                <xsl:if test="(name() != 'Shape') and (name()!='X3D') and (name()!='Scene')">
                                    <xsl:value-of select="concat('/',name(),'[',1+count(./preceding-sibling::*[name() = $curNode]),']')"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>