<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001" xmlns:str="http://exslt.org/strings" xmlns:functx="http://www.functx.com" xmlns:xalan="http://xml.apache.org/xalan" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" xsi:schemaLocation="urn:mpeg:mpeg7:schema:2001 Mpeg7-2001.xsd">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:template name="Texture_Descriptions">
    <xsl:if test="//Appearance/*[not(self::Material)]/attribute::url">
      <xsl:element name="Collection">
        <xsl:attribute name="xsi:type">
          <xsl:text>ContentCollectionType</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="id">
          <xsl:text>Textures</xsl:text>
        </xsl:attribute>
        <xsl:for-each select="/X3D/Scene//*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)] | /X3D/Scene/ProtoDeclare/ProtoBody//*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]">
          <xsl:if test="./Shape/Appearance/*[not(self::Material)]/attribute::url | ./Shape/Appearance/*[not(self::Material)]/attribute::USE | ./Shape/attribute::USE">
            <xsl:element name="ContentCollection">
              <xsl:attribute name="id">
                <xsl:value-of select="concat('Textures_',generate-id(.))"/>
              </xsl:attribute>
              <xsl:attribute name="name">
                <xsl:choose>
                  <xsl:when test="@DEF != ''">
                    <xsl:value-of select="concat('Textures_',@DEF)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="self::Transform">
                      <xsl:value-of select="concat('Transform_',generate-id())"/>
                    </xsl:if>
                    <xsl:if test="self::Group">
                      <xsl:value-of select="concat('Group_',generate-id())"/>
                    </xsl:if>
                    <xsl:if test="self::Anchor">
                      <xsl:value-of select="concat('Anchor_',generate-id())"/>
                    </xsl:if>
                    <xsl:if test="self::Collision">
                      <xsl:value-of select="concat('Collision_',generate-id())"/>
                    </xsl:if>
                    <xsl:if test="self::Billboard">
                      <xsl:value-of select="concat('Billboard_',generate-id())"/>
                    </xsl:if>
                    <xsl:if test="self::LOD">
                      <xsl:value-of select="concat('LOD_',generate-id())"/>
                    </xsl:if>
                    <xsl:if test="self::Switch">
                      <xsl:value-of select="concat('Switch_',generate-id())"/>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:for-each select="./Shape/Appearance/*[(not(self::Material)) and (attribute::url)]">
                <xsl:element name="Content">
                  <xsl:attribute name="xsi:type">
                    <xsl:text>MultimediaType</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="name(.)"/>
                    <xsl:value-of select="concat('_',generate-id(.))"/>
                  </xsl:attribute>
                  <xsl:element name="Multimedia">
                    <xsl:element name="MediaLocator">
                      <xsl:element name="MediaUri">
                        <xsl:value-of select="normalize-space(./attribute::url)"/>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
              <xsl:for-each select="./Shape/Appearance/*[(not(self::Material)) and (attribute::USE)]">
                <xsl:variable name="textures_DEF" select="./attribute::USE"/>
                <xsl:if test="//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url">
                  <xsl:element name="Content">
                    <xsl:attribute name="xsi:type">
                      <xsl:text>MultimediaType</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="name(.)"/>
                      <xsl:value-of select="concat('_',generate-id(.))"/>
                    </xsl:attribute>
                    <xsl:element name="Multimedia">
                      <xsl:element name="MediaLocator">
                        <xsl:element name="MediaUri">
                          <xsl:value-of select="normalize-space(//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url)"/>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>
              </xsl:for-each>
              <xsl:if test="./Shape/attribute::USE">
                <xsl:variable name="Shape_USE" select="./Shape/attribute::USE"/>
                <xsl:if test="//Shape[@DEF=$Shape_USE]/Appearance/*[not(self::Material)]/attribute::url | //Shape/Appearance/*[not(self::Material)]/attribute::USE">
                  <xsl:for-each select="//Shape[@DEF=$Shape_USE]/Appearance/*[(not(self::Material)) and (attribute::url)]">
                    <xsl:element name="Content">
                      <xsl:attribute name="xsi:type">
                        <xsl:text>MultimediaType</xsl:text>
                      </xsl:attribute>
                      <xsl:attribute name="id">
                        <xsl:value-of select="name(.)"/>
                        <xsl:value-of select="concat('_',generate-id($Shape_USE))"/>
                      </xsl:attribute>
                      <xsl:element name="Multimedia">
                        <xsl:element name="MediaLocator">
                          <xsl:element name="MediaUri">
                            <xsl:value-of select="normalize-space(./attribute::url)"/>
                          </xsl:element>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                  </xsl:for-each>
                  <xsl:for-each select="//Shape[@DEF=$Shape_USE]/Appearance/*[(not(self::Material)) and (attribute::USE)]">
                    <xsl:variable name="textures_DEF" select="./attribute::USE"/>
                    <xsl:if test="//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url">
                      <xsl:element name="Content">
                        <xsl:attribute name="xsi:type">
                          <xsl:text>MultimediaType</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="id">
                          <xsl:value-of select="name(.)"/>
                          <xsl:value-of select="concat('_',generate-id($Shape_USE))"/>
                        </xsl:attribute>
                        <xsl:element name="Multimedia">
                          <xsl:element name="MediaLocator">
                            <xsl:element name="MediaUri">
                              <xsl:value-of select="normalize-space(//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url)"/>
                            </xsl:element>
                          </xsl:element>
                        </xsl:element>
                      </xsl:element>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:if>
              </xsl:if>
            </xsl:element>
          </xsl:if>
          <xsl:if test="./attribute::USE">
            <xsl:variable name="cur_node" select="."/>
            <xsl:variable name="node_USE" select="./attribute::USE"/>
            <xsl:variable name="node_DEF" select="/X3D/Scene//*[((self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)) and (@DEF=$node_USE)]"/>
            <xsl:if test="$node_DEF/Shape/Appearance/*[not(self::Material)]/attribute::url | $node_DEF/Shape/Appearance/*[not(self::Material)]/attribute::USE | $node_DEF/Shape/attribute::USE">
              <xsl:element name="ContentCollection">
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('Textures_',generate-id($cur_node))"/>
                </xsl:attribute>
                <xsl:attribute name="name">
                  <xsl:if test="self::Transform">
                    <xsl:value-of select="concat('Transform_',generate-id($cur_node))"/>
                  </xsl:if>
                  <xsl:if test="self::Group">
                    <xsl:value-of select="concat('Group_',generate-id($cur_node))"/>
                  </xsl:if>
                  <xsl:if test="self::Anchor">
                    <xsl:value-of select="concat('Anchor_',generate-id($cur_node))"/>
                  </xsl:if>
                  <xsl:if test="self::Collision">
                    <xsl:value-of select="concat('Collision_',generate-id($cur_node))"/>
                  </xsl:if>
                  <xsl:if test="self::Billboard">
                    <xsl:value-of select="concat('Billboard_',generate-id($cur_node))"/>
                  </xsl:if>
                  <xsl:if test="self::LOD">
                    <xsl:value-of select="concat('LOD_',generate-id($cur_node))"/>
                  </xsl:if>
                  <xsl:if test="self::Switch">
                    <xsl:value-of select="concat('Switch_',generate-id($cur_node))"/>
                  </xsl:if>
                </xsl:attribute>
                <xsl:for-each select="$node_DEF/Shape/Appearance/*[(not(self::Material)) and (attribute::url)]">
                  <xsl:element name="Content">
                    <xsl:attribute name="xsi:type">
                      <xsl:text>MultimediaType</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="name(.)"/>
                      <xsl:value-of select="concat('_',generate-id($cur_node))"/>
                    </xsl:attribute>
                    <xsl:element name="Multimedia">
                      <xsl:element name="MediaLocator">
                        <xsl:element name="MediaUri">
                          <xsl:value-of select="normalize-space(./attribute::url)"/>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:for-each>
                <xsl:for-each select="$node_DEF/Shape/Appearance/*[(not(self::Material)) and (attribute::USE)]">
                  <xsl:variable name="textures_DEF" select="./attribute::USE"/>
                  <xsl:if test="//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url">
                    <xsl:element name="Content">
                      <xsl:attribute name="xsi:type">
                        <xsl:text>MultimediaType</xsl:text>
                      </xsl:attribute>
                      <xsl:attribute name="id">
                        <xsl:value-of select="name(.)"/>
                        <xsl:value-of select="concat('_',generate-id($cur_node))"/>
                      </xsl:attribute>
                      <xsl:element name="Multimedia">
                        <xsl:element name="MediaLocator">
                          <xsl:element name="MediaUri">
                            <xsl:value-of select="normalize-space(//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url)"/>
                          </xsl:element>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                  </xsl:if>
                </xsl:for-each>
                <xsl:if test="$node_DEF/Shape/attribute::USE">
                  <xsl:variable name="Shape_USE" select="$node_DEF/Shape/attribute::USE"/>
                  <xsl:if test="//Shape[@DEF=$Shape_USE]/Appearance/*[not(self::Material)]/attribute::url | ./Shape/Appearance/*[not(self::Material)]/attribute::USE">
                    <xsl:for-each select="//Shape[@DEF=$Shape_USE]/Appearance/*[(not(self::Material)) and (attribute::url)]">
                      <xsl:element name="Content">
                        <xsl:attribute name="xsi:type">
                          <xsl:text>MultimediaType</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="id">
                          <xsl:value-of select="name(.)"/>
                          <xsl:value-of select="concat('_',generate-id($cur_node))"/>
                        </xsl:attribute>
                        <xsl:element name="Multimedia">
                          <xsl:element name="MediaLocator">
                            <xsl:element name="MediaUri">
                              <xsl:value-of select="normalize-space(./attribute::url)"/>
                            </xsl:element>
                          </xsl:element>
                        </xsl:element>
                      </xsl:element>
                    </xsl:for-each>
                    <xsl:for-each select="//Shape[@DEF=$Shape_USE]/Appearance/*[(not(self::Material)) and (attribute::USE)]">
                      <xsl:variable name="textures_DEF" select="./attribute::USE"/>
                      <xsl:if test="//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url">
                        <xsl:element name="Content">
                          <xsl:attribute name="xsi:type">
                            <xsl:text>MultimediaType</xsl:text>
                          </xsl:attribute>
                          <xsl:attribute name="id">
                            <xsl:value-of select="name(.)"/>
                            <xsl:value-of select="concat('_',generate-id($cur_node))"/>
                          </xsl:attribute>
                          <xsl:element name="Multimedia">
                            <xsl:element name="MediaLocator">
                              <xsl:element name="MediaUri">
                                <xsl:value-of select="normalize-space(//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url)"/>
                              </xsl:element>
                            </xsl:element>
                          </xsl:element>
                        </xsl:element>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:if>
                </xsl:if>
              </xsl:element>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="//Shape[(not(parent::Transform)) and (not(parent::Group)) and (not(parent::Anchor)) and (not(parent::Collision)) and (not(parent::Billboard)) and (not(parent::LOD)) and (not(parent::Switch))]">
          <xsl:variable name="curr_node" select="."/>
          <xsl:if test="./Appearance/*[not(self::Material)]/attribute::url">
            <xsl:element name="ContentCollection">
              <xsl:attribute name="id">
                <xsl:value-of select="concat('Textures_',generate-id($curr_node))"/>
              </xsl:attribute>
              <xsl:attribute name="name">
                <xsl:choose>
                  <xsl:when test="@DEF != ''">
                    <xsl:value-of select="concat('Textures_',@DEF)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Shape_</xsl:text>
                    <xsl:number count="Shape" from="Scene" level="single"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:for-each select="./Appearance/*[(not(self::Material)) and (attribute::url)]">
                <xsl:element name="Content">
                  <xsl:attribute name="xsi:type">
                    <xsl:text>MultimediaType</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:value-of select="name(.)"/>
                    <xsl:value-of select="concat('_',generate-id($curr_node))"/>
                  </xsl:attribute>
                  <xsl:element name="Multimedia">
                    <xsl:element name="MediaLocator">
                      <xsl:element name="MediaUri">
                        <xsl:value-of select="normalize-space(./attribute::url)"/>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
              <xsl:for-each select="./Appearance/*[(not(self::Material)) and (attribute::USE)]">
                <xsl:variable name="textures_DEF" select="./attribute::USE"/>
                <xsl:if test="//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url">
                  <xsl:element name="Content">
                    <xsl:attribute name="xsi:type">
                      <xsl:text>MultimediaType</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="name(.)"/>
                      <xsl:value-of select="concat('_',generate-id($curr_node))"/>
                    </xsl:attribute>
                    <xsl:element name="Multimedia">
                      <xsl:element name="MediaLocator">
                        <xsl:element name="MediaUri">
                          <xsl:value-of select="normalize-space(//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url)"/>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>
              </xsl:for-each>
            </xsl:element>
          </xsl:if>
          <xsl:if test="./attribute::USE">
            <xsl:variable name="cur_shape" select="."/>
            <xsl:variable name="shape_USE" select="./attribute::USE"/>
            <xsl:variable name="shape_DEF" select="//Shape[@DEF=$shape_USE]"/>
            <xsl:if test="$shape_DEF/Appearance/*[not(self::Material)]/attribute::url">
              <xsl:element name="ContentCollection">
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('Textures_',generate-id($cur_shape))"/>
                </xsl:attribute>
                <xsl:attribute name="name">
                  <xsl:choose>
                    <xsl:when test="$shape_DEF/@DEF != ''">
                      <xsl:value-of select="concat('Textures_',$shape_DEF/@DEF)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>Shape_</xsl:text>
                      <xsl:number count="Shape" from="Scene" level="single"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:for-each select="$shape_DEF/Appearance/*[(not(self::Material)) and (attribute::url)]">
                  <xsl:element name="Content">
                    <xsl:attribute name="xsi:type">
                      <xsl:text>MultimediaType</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:value-of select="name(.)"/>
                      <xsl:value-of select="concat('_',generate-id($cur_shape))"/>
                    </xsl:attribute>
                    <xsl:element name="Multimedia">
                      <xsl:element name="MediaLocator">
                        <xsl:element name="MediaUri">
                          <xsl:value-of select="normalize-space(./attribute::url)"/>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:for-each>
                <xsl:for-each select="$shape_DEF/Appearance/*[(not(self::Material)) and (attribute::USE)]">
                  <xsl:variable name="textures_DEF" select="./attribute::USE"/>
                  <xsl:if test="//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url">
                    <xsl:element name="Content">
                      <xsl:attribute name="xsi:type">
                        <xsl:text>MultimediaType</xsl:text>
                      </xsl:attribute>
                      <xsl:attribute name="id">
                        <xsl:value-of select="name(.)"/>
                        <xsl:value-of select="concat('_',generate-id($cur_shape))"/>
                      </xsl:attribute>
                      <xsl:element name="Multimedia">
                        <xsl:element name="MediaLocator">
                          <xsl:element name="MediaUri">
                            <xsl:value-of select="normalize-space(//Shape/Appearance/*[(not(self::Material)) and ($textures_DEF=@DEF)]/attribute::url)"/>
                          </xsl:element>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                  </xsl:if>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </xsl:element>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>