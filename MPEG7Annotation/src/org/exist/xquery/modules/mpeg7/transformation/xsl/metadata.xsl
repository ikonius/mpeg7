<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001" xmlns:str="http://exslt.org/strings" xmlns:functx="http://www.functx.com" xmlns:xalan="http://xml.apache.org/xalan" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="urn:mpeg:mpeg7:schema:2001 Mpeg7-2001.xsd">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:param name="filename"/>
    <xsl:template name="Initialize_Metadata">
        <xsl:element name="Description">
            <xsl:attribute name="xsi:type">
                <xsl:text>ContentEntityType</xsl:text>
            </xsl:attribute>
            <xsl:element name="DescriptionMetadata">
                <xsl:call-template name="version"/>
                <xsl:call-template name="doc_identifiers"/>
                <xsl:call-template name="ProfileType"/>
                <xsl:call-template name="ScriptType"/>
            </xsl:element>
            <xsl:element name="MultimediaContent">
                <xsl:attribute name="xsi:type">
                    <xsl:text>MultimediaType</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="tokenize($filename, '/')[last()]"/>
                </xsl:attribute>
                <xsl:element name="Multimedia">
                    <xsl:element name="MediaLocator">
                        <xsl:element name="MediaUri">
                            <xsl:value-of select="$filename"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="version">
        <xsl:if test="string-length(/X3D/@version) != 0">
            <xsl:element name="Version">
                <xsl:value-of select="/X3D/@version"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="ProfileType">
        <xsl:if test="string-length(/X3D/@profile) != 0">
            <xsl:element name="Profile3D">
                <xsl:value-of select="/X3D/@profile"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="ScriptType">
        <xsl:if test="//Script">
            <xsl:element name="Script3D">
                <xsl:variable name="url" select="X3D/Scene//Script/@url"/>
                <xsl:choose>
                    <xsl:when test="contains($url,'.class')">
                        <xsl:element name="externalScript">
                            <xsl:text>Java</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="contains($url,'.js')">
                        <xsl:element name="externalScript">
                            <xsl:text>JScript</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="internalScript">
                            <xsl:text>JavaScript</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template name="doc_identifiers">
        <xsl:if test="/X3D/head/meta[@name='identifier']">
            <xsl:element name="PrivateIdentifier">
                <xsl:value-of select="/X3D/head/meta[@name='identifier']/@content"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="/X3D/head/meta[@name='description']">
            <xsl:element name="Summary">
                <xsl:value-of select="/X3D/head/meta[@name='description']/@content"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
