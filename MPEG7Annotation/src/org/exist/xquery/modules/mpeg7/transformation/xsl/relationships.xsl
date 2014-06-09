<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001" xmlns:str="http://exslt.org/strings" xmlns:functx="http://www.functx.com" xmlns:xalan="http://xml.apache.org/xalan" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="urn:mpeg:mpeg7:schema:2001 Mpeg7-2001.xsd">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template name="Relationships">
        <xsl:element name="Relationships">
            <xsl:apply-templates select="/X3D/Scene//*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]| /X3D/Scene/ProtoDeclare/ProtoBody//*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]">
                <xsl:with-param name="parentNodeName" select="name(..)"/>
                <xsl:with-param name="parentDEF" select="../@DEF | ../@USE"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <xsl:template match="Transform | Group | Anchor | Collision | Billboard | LOD | Switch">
        <xsl:param name="parentNodeName"/>
        <xsl:param name="parentDEF"/>
        <xsl:if test="$parentNodeName = ('Transform' or 'Group' or 'Anchor' or 'Collision' or 'Billboard' or 'LOD' or 'Switch')">
            <xsl:element name="Relation">
                <xsl:attribute name="type">
                    <xsl:text>urn:mpeg:mpeg7:cs:BaseRelationCS:2001:member</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="source">
                    <xsl:choose>
                        <xsl:when test="string-length($parentDEF) != 0">
                            <xsl:value-of select="concat('#',$parentDEF,'_', $parentNodeName)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('#',name(.),'_')"/>
                            <xsl:number count="/X3D/Scene/node()[name()=$parentNodeName] | /X3D/Scene/ProtoDeclare/ProtoBody/node()[name()=$parentNodeName]" from="Scene" level="single"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="target">
                    <xsl:choose>
                        <xsl:when test="string-length(@DEF) != 0">
                            <xsl:value-of select="concat('#',@DEF,'_', name(.))"/>
                        </xsl:when>
                        <xsl:when test="string-length(@USE) != 0">
                            <xsl:value-of select="concat('#',@USE,'_USE')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('#',name(.),'_')"/>
                            <xsl:number count="Transform | Group | Anchor | Collision | Billboard | LOD | Switch" from="Scene" level="multiple"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:element>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>