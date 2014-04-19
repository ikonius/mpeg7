<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:xalan="http://xml.apache.org/xalan" xmlns:str="http://exslt.org/strings" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns="urn:mpeg:mpeg7:schema:2001"
               xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:mpeg:mpeg7:schema:2001 Mpeg7-2001.xsd">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="filename"></xsl:param>
	<xsl:param name="IFSPointsExtraction"></xsl:param>
        <xsl:param name="ILSPointsExtraction"></xsl:param>
        <xsl:param name="extrusionPointsExtraction"></xsl:param>
        <xsl:param name="extrusionBBoxParams"></xsl:param>
	<xsl:template match="/">
		<!--<Mpeg7 xmlns="urn:mpeg:mpeg7:schema:2001" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001" xmlns:xml="http://www.w3.org/XML/1998/namespace" xsi:schemaLocation="urn:mpeg:mpeg7:schema:2001 Mpeg7-2001.xsd">
		</Mpeg7>-->
		<xsl:element name="Mpeg7" xmlns:xml="http://www.w3.org/XML/1998/namespace" xmlns="urn:mpeg:mpeg7:schema:2001" xmlns:mpeg7="urn:mpeg:mpeg7:schema:2001" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		             xsi:schemaLocation="urn:mpeg:mpeg7:schema:2001 Mpeg7-2001.xsd">
			<xsl:call-template name="Initialize_Metadata"/>
			<xsl:element name="Description">
				<xsl:attribute name="xsi:type">
					<xsl:text>ContentEntityType</xsl:text>
				</xsl:attribute>
				<xsl:element name="MultimediaContent">
					<xsl:attribute name="xsi:type">
						<xsl:text>MultimediaCollectionType</xsl:text>
					</xsl:attribute>
					<xsl:element name="StructuredCollection">
						<xsl:call-template name="Declare_All_Transforms"/>
						<xsl:call-template name="Texture_Descriptions"/>
						<xsl:call-template name="Geometry_Descriptions"/>
						<xsl:call-template name="Interaction_Descriptions"/>
						<xsl:call-template name="Viewpoint_Descriptions"/>
						<xsl:call-template name="Lighting_Descriptions"/>
						<xsl:call-template name="Relationships"/>
					</xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

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
		<xsl:if test="/X3D/@version != ''">
			<xsl:element name="Version">
				<xsl:value-of select="/X3D/@version"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template name="ProfileType">
		<xsl:if test="/X3D/@profile != ''">
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
	</xsl:template>

	<xsl:template name="doc_description">
		<xsl:if test="/X3D/head/meta[@name='description']">
			<xsl:element name="Summary">
				<xsl:value-of select="/X3D/head/meta[@name='description']/@content"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<!--
	<xsl:template name="doc_created">
		<xsl:if test="/X3D/head/meta[@name='created']">
			<xsl:element name="CreationTime">
				<xsl:value-of select="/X3D/head/meta[@name='created']/@content"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="doc_modified">
		<xsl:if test="/X3D/head/meta[@name='modified']">
			<xsl:element name="LastUpdate">
				<xsl:value-of select="/X3D/head/meta[@name='modified']/@content"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="doc_creator">
		<xsl:if test="/X3D/head/meta[@name='creator']">
			<xsl:element name="Creator">
				<xsl:value-of select="/X3D/head/meta[@name='creator']/@content"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="doc_rights">
		<xsl:if test="/X3D/head/meta[@name='rights']">
			<xsl:element name="Rights">
				<xsl:value-of select="/X3D/head/meta[@name='rights']/@content"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="doc_">
		<xsl:if test="/X3D/head/meta[@name='']">
			<xsl:element name="Comment">
				<xsl:value-of select="/X3D/head/meta[@name='']/@content"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="doc_">
		<xsl:if test="/X3D/head/meta[@name='']">
			<xsl:element name="PublicIdentifier">
				<xsl:value-of select="/X3D/head/meta[@name='']/@content"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="doc_">
		<xsl:if test="/X3D/head/meta[@name='']">
			<xsl:element name="Confidence">
				<xsl:value-of select="/X3D/head/meta[@name='']/@content"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="doc_">
		<xsl:if test="/X3D/head/meta[@name='']">
			<xsl:element name="CreationLocation">
				<xsl:value-of select="/X3D/head/meta[@name='']/@content"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="doc_">
		<xsl:if test="/X3D/head/meta[@name='']">
			<xsl:element name="Instrument">
				<xsl:value-of select="/X3D/head/meta[@name='']/@content"/>
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
            <xsl:template name="doc_">
            <xsl:if test="/X3D/head/meta[@name='']">
                    <xsl:element name="Package">
                            <xsl:value-of select="/X3D/head/meta[@name='']/@content"/>
                    </xsl:element>
            </xsl:if>
    </xsl:template>
    -->

	<xsl:template name="Declare_All_Transforms">
		<xsl:if test="//Shape | //Transform | //Group">
			<xsl:element name="Collection">
				<xsl:attribute name="xsi:type">
					<xsl:text>ContentCollectionType</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:text>Transformations</xsl:text>
				</xsl:attribute>
				<xsl:for-each select="/X3D/Scene/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)] | /X3D/Scene/ProtoDeclare/ProtoBody/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]">
					<xsl:element name="ContentCollection">
						<xsl:attribute name="id">
							<xsl:if test="self::Transform">
								<xsl:value-of select="concat('Transforms_',generate-id())"/>
							</xsl:if>
							<xsl:if test="self::Group">
								<xsl:value-of select="concat('Groups_',generate-id())"/>
							</xsl:if>
							<xsl:if test="self::Anchor">
								<xsl:value-of select="concat('Anchors_',generate-id())"/>
							</xsl:if>
							<xsl:if test="self::Collision">
								<xsl:value-of select="concat('Collisions_',generate-id())"/>
							</xsl:if>
							<xsl:if test="self::Billboard">
								<xsl:value-of select="concat('Billboards_',generate-id())"/>
							</xsl:if>
							<xsl:if test="self::LOD">
								<xsl:value-of select="concat('LODs_',generate-id())"/>
							</xsl:if>
							<xsl:if test="self::Switch">
								<xsl:value-of select="concat('Switches_',generate-id())"/>
							</xsl:if>
						</xsl:attribute>
						<xsl:attribute name="name">
							<xsl:choose>
								<xsl:when test="@DEF != ''">
									<xsl:value-of select="@DEF"/>
								</xsl:when>
								<xsl:when test="@USE != ''">
									<xsl:value-of select="@USE"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="self::Transform">
										<xsl:text>Transform_</xsl:text>
										<xsl:number level="single" count="Transform" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::Group">
										<xsl:text>Group_</xsl:text>
										<xsl:number level="single" count="Group" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::Anchor">
										<xsl:text>Anchor_</xsl:text>
										<xsl:number level="single" count="Anchor" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::Collision">
										<xsl:text>Collision_</xsl:text>
										<xsl:number level="single" count="Collision" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::Billboard">
										<xsl:text>Billboard_</xsl:text>
										<xsl:number level="single" count="Billboard" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::LOD">
										<xsl:text>LOD_</xsl:text>
										<xsl:number level="single" count="LOD" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::Switch">
										<xsl:text>Switch_</xsl:text>
										<xsl:number level="single" count="Switch" from="Scene"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:element name="Content" xsi:type="MultimediaType">
							<xsl:attribute name="xsi:type">
								<xsl:text>MultimediaType</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="id">
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
							</xsl:attribute>
							<xsl:element name="Multimedia">
								<xsl:element name="MediaLocator">
									<xsl:element name="MediaUri">
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
									</xsl:element>
								</xsl:element>
							</xsl:element>
						</xsl:element>
						<xsl:call-template name="Contents"/>
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="//Shape[(not(parent::Transform)) and (not(parent::Group)) and (not(parent::Anchor)) and (not(parent::Collision)) and (not(parent::Billboard)) and (not(parent::LOD)) and (not(parent::Switch))]">
					<xsl:element name="ContentCollection">
						<xsl:attribute name="id">
							<xsl:if test="self::Shape">
								<xsl:value-of select="concat('Shapes_',generate-id())"/>
							</xsl:if>
						</xsl:attribute>
						<xsl:attribute name="name">
							<xsl:choose>
								<xsl:when test="@DEF != ''">
									<xsl:value-of select="@DEF"/>
								</xsl:when>
								<xsl:when test="@USE != ''">
									<xsl:value-of select="@USE"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="self::Shape">
										<xsl:text>Shape_</xsl:text>
										<xsl:number level="single" count="Shape" from="Scene"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:element name="Content" xsi:type="MultimediaType">
							<xsl:attribute name="xsi:type">
								<xsl:text>MultimediaType</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="id">
								<xsl:if test="self::Shape">
									<xsl:value-of select="concat('Shape_',generate-id())"/>
								</xsl:if>
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
				</xsl:for-each>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template name="Contents">
		<xsl:for-each select=".//Transform | .//Group | .//Anchor | .//Collision | .//Billboard | .//LOD | .//Switch">
			<xsl:element name="Content">
				<xsl:attribute name="xsi:type">
					<xsl:text>MultimediaType</xsl:text>
				</xsl:attribute>
				<!--<xsl:for-each select="ancestor::Transform">-->
				<xsl:attribute name="id">
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
				</xsl:attribute>
				<xsl:element name="Multimedia">
					<xsl:element name="MediaLocator">
						<xsl:element name="MediaUri">
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
						</xsl:element>
					</xsl:element>
				</xsl:element>
				<!--</xsl:for-each>-->
			</xsl:element>
			<!--<xsl:value-of select="Tranform"/>
            <xsl:number level="multiple" count="Transform" from="Scene"/>
                            <xsl:text>.</xsl:text>
            <xsl:text>old</xsl:text>-->
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="Geometry_Descriptions">
		<xsl:if test="//Shape">
			<xsl:element name="Collection" xsi:type="DescriptorCollectionType">
				<xsl:attribute name="xsi:type">
					<xsl:text>DescriptorCollectionType</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="id">
					<xsl:text>Geometries</xsl:text>
				</xsl:attribute>
				<xsl:for-each select="/X3D/Scene/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)] | /X3D/Scene/ProtoDeclare/ProtoBody/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]">
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
										<xsl:number level="single" count="Transform" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::Group">
										<xsl:text>Group_</xsl:text>
										<xsl:number level="single" count="Group" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::Anchor">
										<xsl:text>Anchor_</xsl:text>
										<xsl:number level="single" count="Anchor" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::Collision">
										<xsl:text>Collision_</xsl:text>
										<xsl:number level="single" count="Collision" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::Billboard">
										<xsl:text>Billboard_</xsl:text>
										<xsl:number level="single" count="Billboard" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::LOD">
										<xsl:text>LOD_</xsl:text>
										<xsl:number level="single" count="LOD" from="Scene"/>
									</xsl:if>
									<xsl:if test="self::Switch">
										<xsl:text>Switch_</xsl:text>
										<xsl:number level="single" count="Switch" from="Scene"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<!--DHMIOYRGEI ENA BOUNDING BOX BASH TOY OUTER TRANSFORM (PAROLO POU KATHE SHAPE EXEI
						ENA TRANSFORM, AN AUTA PERIKLEIONTAI MAZI SE AKOMA ENA OUTER TRANSFORM, TOTE GINETAI
						ENA MONO BOUNDING BOX, GIA AUTO KAI THA METAFERTHEI ALLOU GIA TIN APODOSI ANA SHAPE -
						Descriptor xsi:type="Geometry3DType)

<xsl:if test="(attribute::bboxSize) and (attribute::bboxCenter)">
    <xsl:element name="Descriptor">
        <xsl:attribute name="xsi:type">
            <xsl:text>BoundingBox3DType</xsl:text>
        </xsl:attribute>
        <xsl:element name="BoundingBox3DSize">
            <xsl:attribute name="BoxWidth">
                <xsl:value-of select="tokenize(attribute::bboxSize, ' ')[1]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxHeight">
                <xsl:value-of select="tokenize(attribute::bboxSize, ' ')[2]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxDepth">
                <xsl:value-of select="tokenize(attribute::bboxSize, ' ')[3]"/>
            </xsl:attribute>
        </xsl:element>
        <xsl:element name="BoundingBox3DCenter">
            <xsl:attribute name="BoxCenterW">
                <xsl:value-of select="tokenize(attribute::bboxCenter, ' ')[1]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxCenterH">
                <xsl:value-of select="tokenize(attribute::bboxCenter, ' ')[2]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxCenterD">
                <xsl:value-of select="tokenize(attribute::bboxCenter, ' ')[3]"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:element>
</xsl:if>
                        -->
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
                                        <xsl:number level="single" count="Transform" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::Group">
                                        <xsl:text>#Group_</xsl:text>
                                        <xsl:number level="single" count="Group" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::Anchor">
                                        <xsl:text>#Anchor_</xsl:text>
                                        <xsl:number level="single" count="Anchor" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::Collision">
                                        <xsl:text>#Collision_</xsl:text>
                                        <xsl:number level="single" count="Collision" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::Billboard">
                                        <xsl:text>#Billboard_</xsl:text>
                                        <xsl:number level="single" count="Billboard" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::LOD">
                                        <xsl:text>#LOD_</xsl:text>
                                        <xsl:number level="single" count="LOD" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::Switch">
                                        <xsl:text>#Switch_</xsl:text>
                                        <xsl:number level="single" count="Switch" from="Scene"/>
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
                                        <xsl:number level="single" count="Shape" from="Scene"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <!--OMOIOS OPOS KAI PROIGOUMENOS, AFAIREITAI KAI METAFERETAI-PARALASETAI
<xsl:if test="(attribute::bboxSize) and (attribute::bboxCenter)">
    <xsl:element name="Descriptor">
        <xsl:attribute name="xsi:type">
            <xsl:text>BoundingBox3DType</xsl:text>
        </xsl:attribute>
        <xsl:element name="BoundingBox3DSize">
            <xsl:attribute name="BoxWidth">
                <xsl:value-of select="tokenize(attribute::bboxSize, ' ')[1]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxHeight">
                <xsl:value-of select="tokenize(attribute::bboxSize, ' ')[2]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxDepth">
                <xsl:value-of select="tokenize(attribute::bboxSize, ' ')[3]"/>
            </xsl:attribute>
        </xsl:element>
        <xsl:element name="BoundingBox3DCenter">
            <xsl:attribute name="BoxCenterW">
                <xsl:value-of select="tokenize(attribute::bboxCenter, ' ')[1]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxCenterH">
                <xsl:value-of select="tokenize(attribute::bboxCenter, ' ')[2]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxCenterD">
                <xsl:value-of select="tokenize(attribute::bboxCenter, ' ')[3]"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:element>
</xsl:if>
                        -->
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
                                        <xsl:number level="single" count="Shape" from="Scene"/>
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
                        <!--<xsl:element name="TEST_POINTS">
                                <xsl:value-of select="$pointCoordinates"/>
                        </xsl:element>
                        <xsl:element name="POINTS_BY_POINTS">
                                <xsl:variable name="totalPoints" select="tokenize($pointCoordinates, ' ')"/>
                                <xsl:for-each select="$totalPoints">
                                        <xsl:element name="pointo">
                                                <xsl:value-of select="normalize-space(.)"/>
                                        </xsl:element>
                                </xsl:for-each>
                        </xsl:element>-->
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
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="ceiling((number(tokenize($checkColor, ' ')[2])) * 255)"/>
                                    <xsl:text> </xsl:text>
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
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="ceiling(number(0.8) * 255)"/>
                                    <xsl:text> </xsl:text>
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
                    <xsl:variable name="positionOfIFS" select="count(preceding::IndexedLineSet) + 1"/>
                    <xsl:call-template name="shapeExtraction">
                        <xsl:with-param name="stringOfIFS" select="tokenize($ILSPointsExtraction, '#')[$positionOfIFS]"/>
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
    </xsl:template>

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
                                        <xsl:number level="single" count="Shape" from="Scene"/>
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
                                            <xsl:number level="single" count="Shape" from="Scene"/>
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

    <xsl:template name="Interaction_Descriptions">
        <xsl:if test="/X3D/Scene/descendant::*[contains(name(.),'Interpolator') or contains(name(.),'Sensor') or contains(name(.),'Trigger') or contains(name(.),'Filter')]">
            <xsl:element name="Collection">
                <xsl:attribute name="xsi:type">
                    <xsl:text>DescriptorCollectionType</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:text>Interactions</xsl:text>
                </xsl:attribute>
                <xsl:for-each select="/X3D/Scene/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)] | /X3D/Scene/ProtoDeclare/ProtoBody/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]">
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
                                            <xsl:number level="single" count="Transform" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Group">
                                            <xsl:text>Group_</xsl:text>
                                            <xsl:number level="single" count="Group" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Anchor">
                                            <xsl:text>Anchor_</xsl:text>
                                            <xsl:number level="single" count="Anchor" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Collision">
                                            <xsl:text>Collision_</xsl:text>
                                            <xsl:number level="single" count="Collision" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Billboard">
                                            <xsl:text>Billboard_</xsl:text>
                                            <xsl:number level="single" count="Billboard" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::LOD">
                                            <xsl:text>LOD_</xsl:text>
                                            <xsl:number level="single" count="LOD" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Switch">
                                            <xsl:text>Switch_</xsl:text>
                                            <xsl:number level="single" count="Switch" from="Scene"/>
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
                                            <xsl:number level="single" count="Transform" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Group">
                                            <xsl:text>#Group_</xsl:text>
                                            <xsl:number level="single" count="Group" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Anchor">
                                            <xsl:text>#Anchor_</xsl:text>
                                            <xsl:number level="single" count="Anchor" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Collision">
                                            <xsl:text>#Collision_</xsl:text>
                                            <xsl:number level="single" count="Collision" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Billboard">
                                            <xsl:text>#Billboard_</xsl:text>
                                            <xsl:number level="single" count="Billboard" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::LOD">
                                            <xsl:text>#LOD_</xsl:text>
                                            <xsl:number level="single" count="LOD" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Switch">
                                            <xsl:text>#Switch_</xsl:text>
                                            <xsl:number level="single" count="Switch" from="Scene"/>
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

    <xsl:template name="Relationships">
        <xsl:element name="Relationships">
            <xsl:for-each select="/X3D/Scene//*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]| /X3D/Scene/ProtoDeclare/ProtoBody//*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]">
                <xsl:if test="(name(..)='Transform') or (name(..)='Group') or (name(..)='Anchor') or (name(..)='Collision') or (name(..)='Billboard') or (name(..)='LOD') or (name(..)='Switch')">
                    <xsl:element name="Relation">
                        <xsl:attribute name="type">
                            <xsl:text>urn:mpeg:mpeg7:cs:BaseRelationCS:2001:member</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="source">
                            <xsl:choose>
                                <xsl:when test="../@DEF != ''">
                                    <xsl:if test="(name(..)='Transform')">
                                        <xsl:value-of select="concat('#',../@DEF,'_Transform')"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='Group')">
                                        <xsl:value-of select="concat('#',../@DEF,'_Group')"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='Anchor')">
                                        <xsl:value-of select="concat('#',../@DEF,'_Anchor')"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='Collision')">
                                        <xsl:value-of select="concat('#',../@DEF,'_Collision')"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='Billboard')">
                                        <xsl:value-of select="concat('#',../@DEF,'_Billboard')"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='LOD')">
                                        <xsl:value-of select="concat('#',../@DEF,'_LOD')"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='Switch')">
                                        <xsl:value-of select="concat('#',../@DEF,'_Switch')"/>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="(name(..)='Transform')">
                                        <xsl:text>#Transform_</xsl:text>
                                        <xsl:number level="single" count="/X3D/Scene/Transform | /X3D/Scene/ProtoDeclare/ProtoBody/Transform" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='Group')">
                                        <xsl:text>#Group_</xsl:text>
                                        <xsl:number level="single" count="/X3D/Scene/Group | /X3D/Scene/ProtoDeclare/ProtoBody/Group" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='Anchor')">
                                        <xsl:text>#Anchor_</xsl:text>
                                        <xsl:number level="single" count="/X3D/Scene/Anchor | /X3D/Scene/ProtoDeclare/ProtoBody/Anchor" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='Collision')">
                                        <xsl:text>#Collision_</xsl:text>
                                        <xsl:number level="single" count="/X3D/Scene/Collision | /X3D/Scene/ProtoDeclare/ProtoBody/Collision" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='Billboard')">
                                        <xsl:text>#Billboard_</xsl:text>
                                        <xsl:number level="single" count="/X3D/Scene/Billboard | /X3D/Scene/ProtoDeclare/ProtoBody/Billboard" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='LOD')">
                                        <xsl:text>#LOD_</xsl:text>
                                        <xsl:number level="single" count="/X3D/Scene/LOD | /X3D/Scene/ProtoDeclare/ProtoBody/LOD" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="(name(..)='Switch')">
                                        <xsl:text>#Switch_</xsl:text>
                                        <xsl:number level="single" count="/X3D/Scene/Switch | /X3D/Scene/ProtoDeclare/ProtoBody/Switch" from="Scene"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="target">
                            <xsl:choose>
                                <xsl:when test="@DEF != ''">
                                    <xsl:if test="self::Transform">
                                        <xsl:value-of select="concat('#',@DEF,'_Transform')"/>
                                    </xsl:if>
                                    <xsl:if test="self::Group">
                                        <xsl:value-of select="concat('#',@DEF,'_Group')"/>
                                    </xsl:if>
                                    <xsl:if test="self::Anchor">
                                        <xsl:value-of select="concat('#',@DEF,'_Anchor')"/>
                                    </xsl:if>
                                    <xsl:if test="self::Collision">
                                        <xsl:value-of select="concat('#',@DEF,'_Collision')"/>
                                    </xsl:if>
                                    <xsl:if test="self::Billboard">
                                        <xsl:value-of select="concat('#',@DEF,'_Billboard')"/>
                                    </xsl:if>
                                    <xsl:if test="self::LOD">
                                        <xsl:value-of select="concat('#',@DEF,'_LOD')"/>
                                    </xsl:if>
                                    <xsl:if test="self::Switch">
                                        <xsl:value-of select="concat('#',@DEF,'_Switch')"/>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:when test="@USE != ''">
                                    <xsl:value-of select="concat('#',@USE,'_USE')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="self::Transform">
                                        <xsl:text>#Transform_</xsl:text>
                                        <xsl:number level="multiple" count="Transform | Group | Anchor | Collision | Billboard | LOD | Switch" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::Group">
                                        <xsl:text>#Group_</xsl:text>
                                        <xsl:number level="multiple" count="Transform | Group | Anchor | Collision | Billboard | LOD | Switch" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::Anchor">
                                        <xsl:text>#Anchor_</xsl:text>
                                        <xsl:number level="multiple" count="Transform | Group | Anchor | Collision | Billboard | LOD | Switch" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::Collision">
                                        <xsl:text>#Collision_</xsl:text>
                                        <xsl:number level="multiple" count="Transform | Group | Anchor | Collision | Billboard | LOD | Switch" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::Billboard">
                                        <xsl:text>#Billboard_</xsl:text>
                                        <xsl:number level="multiple" count="Transform | Group | Anchor | Collision | Billboard | LOD | Switch" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::LOD">
                                        <xsl:text>#LOD_</xsl:text>
                                        <xsl:number level="multiple" count="Transform | Group | Anchor | Collision | Billboard | LOD | Switch" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::Switch">
                                        <xsl:text>#Switch_</xsl:text>
                                        <xsl:number level="multiple" count="Transform | Group | Anchor | Collision | Billboard | LOD | Switch" from="Scene"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Viewpoint_Descriptions">
        <xsl:if test="//Viewpoint">
            <xsl:element name="Collection" xsi:type="DescriptorCollectionType">
                <xsl:attribute name="xsi:type">
                    <xsl:text>DescriptorCollectionType</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:text>Viewpoints</xsl:text>
                </xsl:attribute>
                <xsl:for-each select="/X3D/Scene/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)] | /X3D/Scene/ProtoDeclare/ProtoBody/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]">
                    <xsl:if test=".//Viewpoint">
                        <xsl:element name="DescriptorCollection">
                            <xsl:attribute name="id">
                                <xsl:value-of select="concat('Viewpoint_',generate-id())"/>
                            </xsl:attribute>
                            <xsl:attribute name="name">
                                <xsl:choose>
                                    <xsl:when test="@DEF != ''">
                                        <xsl:value-of select="concat('Viewpoint_',@DEF)"/>
                                    </xsl:when>
                                    <xsl:when test="@USE != ''">
                                        <xsl:value-of select="concat('Viewpoint_',@USE)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="self::Transform">
                                            <xsl:text>Transform_</xsl:text>
                                            <xsl:number level="single" count="Transform" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Group">
                                            <xsl:text>Group_</xsl:text>
                                            <xsl:number level="single" count="Group" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Anchor">
                                            <xsl:text>Anchor_</xsl:text>
                                            <xsl:number level="single" count="Anchor" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Collision">
                                            <xsl:text>Collision_</xsl:text>
                                            <xsl:number level="single" count="Collision" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Billboard">
                                            <xsl:text>Billboard_</xsl:text>
                                            <xsl:number level="single" count="Billboard" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::LOD">
                                            <xsl:text>LOD_</xsl:text>
                                            <xsl:number level="single" count="LOD" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Switch">
                                            <xsl:text>Switch_</xsl:text>
                                            <xsl:number level="single" count="Switch" from="Scene"/>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>

                            <xsl:choose>
                                <xsl:when test="(self::*/@USE)">
                                    <xsl:variable name="DEF" select="(self::*/@USE)"/>
                                    <xsl:for-each select="(/X3D/Scene//Transform[@DEF=$DEF]//Viewpoint) | (/X3D/Scene//Group[@DEF=$DEF]//Viewpoint) | (/X3D/Scene//Anchor[@DEF=$DEF]//Viewpoint) | (/X3D/Scene//Collision[@DEF=$DEF]//Viewpoint) | (/X3D/Scene//Billboard[@DEF=$DEF]//Viewpoint) | (/X3D/Scene//LOD[@DEF=$DEF]//Viewpoint) |(/X3D/Scene//Switch[@DEF=$DEF]//Viewpoint)">
                                        <xsl:call-template name="Viewpoint_descriptors">
                                            <xsl:with-param name="path"
                                                                                                        select="(/X3D/Scene//Transform[@DEF=$DEF]//Viewpoint) | (/X3D/Scene//Group[@DEF=$DEF]//Viewpoint) | (/X3D/Scene//Anchor[@DEF=$DEF]//Viewpoint) | (/X3D/Scene//Collision[@DEF=$DEF]//Viewpoint) | (/X3D/Scene//Billboard[@DEF=$DEF]//Viewpoint) | (/X3D/Scene//LOD[@DEF=$DEF]//Viewpoint) |(/X3D/Scene//Switch[@DEF=$DEF]//Viewpoint)"/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select=".//Viewpoint">
                                        <xsl:choose>
                                            <xsl:when test="@USE">
                                                <xsl:variable name="sh_DEF" select="@USE"/>
                                                <xsl:call-template name="Viewpoint_descriptors">
                                                    <xsl:with-param name="path" select="//Viewpoint[$sh_DEF=@DEF]"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="Viewpoint_descriptors">
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
                                            <xsl:text>Transform_</xsl:text>
                                            <xsl:number level="single" count="Transform" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Group">
                                            <xsl:text>Group_</xsl:text>
                                            <xsl:number level="single" count="Group" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Anchor">
                                            <xsl:text>Anchor_</xsl:text>
                                            <xsl:number level="single" count="Anchor" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Collision">
                                            <xsl:text>Collision_</xsl:text>
                                            <xsl:number level="single" count="Collision" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Billboard">
                                            <xsl:text>Billboard_</xsl:text>
                                            <xsl:number level="single" count="Billboard" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::LOD">
                                            <xsl:text>LOD_</xsl:text>
                                            <xsl:number level="single" count="LOD" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Switch">
                                            <xsl:text>Switch_</xsl:text>
                                            <xsl:number level="single" count="Switch" from="Scene"/>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>

                <xsl:for-each select="//Viewpoint[(not(parent::Transform)) and (not(parent::Group)) and (not(parent::Anchor)) and (not(parent::Collision)) and (not(parent::Billboard)) and (not(parent::LOD)) and (not(parent::Switch))]">
                    <xsl:element name="DescriptorCollection">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('Viewpoint_',generate-id())"/>
                        </xsl:attribute>
                        <xsl:attribute name="name">
                            <xsl:choose>
                                <xsl:when test="@DEF != ''">
                                    <xsl:value-of select="concat('Viewpoint_',@DEF)"/>
                                </xsl:when>
                                <xsl:when test="@USE != ''">
                                    <xsl:value-of select="concat('Viewpoint_',@USE)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="self::Viewpoint">
                                        <xsl:text>Viewpoint_</xsl:text>
                                        <xsl:number level="single" count="Viewpoint" from="Scene"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="@USE">
                                <xsl:variable name="sh_DEF" select="@USE"/>
                                <xsl:call-template name="Viewpoint_descriptors">
                                    <xsl:with-param name="path" select="//Viewpoint[$sh_DEF=@DEF]"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="Viewpoint_descriptors">
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
                                    <xsl:if test="self::Viewpoint">
                                        <xsl:text>#Viewpoint_</xsl:text>
                                        <xsl:number level="single" count="Viewpoint" from="Scene"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Viewpoint_descriptors">
        <xsl:param name="path"/>
        <xsl:element name="Descriptor">
            <xsl:attribute name="xsi:type">
                <xsl:text>Viewpoint3DType</xsl:text>
            </xsl:attribute>
            <xsl:element name="Viewpoint3D">
                <xsl:if test="$path/attribute::description">
                    <xsl:attribute name="description">
                        <xsl:value-of select="$path/attribute::description"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:attribute name="isAnimated">
                    <xsl:choose>
                        <xsl:when test="//ROUTE/@toNode = $path/attribute::DEF">
                            <xsl:text>true</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>false</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <!--MH YLOPOIHSIMO PROS TO PARON
                AFOU EINAI KAI OPTIONAL STO MPEG7 XSD
                <xsl:attribute name="animatedBy">
                        <xsl:value-of select="?????????"/>
                </xsl:attribute>
                PERIPTOSEIS fromNode toy ROUTE gia interpolator
                PERIPTOSEIS toField toy ROUTE gia interpolator, node kai script
                -->
                <xsl:attribute name="fieldOfView">
                    <xsl:choose>
                        <xsl:when test="$path/attribute::fieldOfView">
                            <xsl:value-of select="$path/attribute::fieldOfView"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>0.7854</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:element>
            <xsl:element name="Viewpoint3DPosition">
                <xsl:element name="Orientation">
                    <xsl:choose>
                        <xsl:when test="$path/attribute::orientation">
                            <xsl:value-of select="$path/attribute::orientation"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>0 0 1 0</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:element name="Position">
                    <xsl:choose>
                        <xsl:when test="$path/attribute::position">
                            <xsl:value-of select="$path/attribute::position"/>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:text>0 0 10</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <xsl:element name="CenterOfRotation">
                    <xsl:choose>
                        <xsl:when test="$path/attribute::centerOfRotation">
                            <xsl:value-of select="$path/attribute::centerOfRotation"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>0 0 0</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Lighting_Descriptions">
        <xsl:if test="//SpotLight | //DirectionalLight | //PointLight">
            <xsl:element name="Collection" xsi:type="DescriptorCollectionType">
                <xsl:attribute name="xsi:type">
                    <xsl:text>DescriptorCollectionType</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:text>Lightings</xsl:text>
                </xsl:attribute>

                <xsl:for-each select="/X3D/Scene/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)] | /X3D/Scene/ProtoDeclare/ProtoBody/*[(self::Transform) or (self::Group) or (self::Anchor) or (self::Collision) or (self::Billboard) or (self::LOD) or (self::Switch)]">
                    <xsl:if test=".//SpotLight | .//DirectionalLight | .//PointLight">
                        <xsl:element name="DescriptorCollection">
                            <xsl:attribute name="id">
                                <xsl:value-of select="concat('Lighting_',generate-id())"/>
                            </xsl:attribute>
                            <xsl:attribute name="name">
                                <xsl:choose>
                                    <xsl:when test="@DEF != ''">
                                        <xsl:value-of select="concat('Lighting_',@DEF)"/>
                                    </xsl:when>
                                    <xsl:when test="@USE != ''">
                                        <xsl:value-of select="concat('Lighting_',@USE)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if test="self::Transform">
                                            <xsl:text>Transform_</xsl:text>
                                            <xsl:number level="single" count="Transform" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Group">
                                            <xsl:text>Group_</xsl:text>
                                            <xsl:number level="single" count="Group" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Anchor">
                                            <xsl:text>Anchor_</xsl:text>
                                            <xsl:number level="single" count="Anchor" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Collision">
                                            <xsl:text>Collision_</xsl:text>
                                            <xsl:number level="single" count="Collision" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Billboard">
                                            <xsl:text>Billboard_</xsl:text>
                                            <xsl:number level="single" count="Billboard" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::LOD">
                                            <xsl:text>LOD_</xsl:text>
                                            <xsl:number level="single" count="LOD" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Switch">
                                            <xsl:text>Switch_</xsl:text>
                                            <xsl:number level="single" count="Switch" from="Scene"/>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>

                            <xsl:choose>
                                <xsl:when test="(self::*/@USE)">
                                    <xsl:variable name="DEF" select="(self::*/@USE)"/>
                                    <xsl:for-each select="(/X3D/Scene//Transform[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Group[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Anchor[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Collision[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Billboard[@DEF=$DEF]//SpotLight) | (/X3D/Scene//LOD[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Switch[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Transform[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Group[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Anchor[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Collision[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Billboard[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//LOD[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Switch[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Transform[@DEF=$DEF]//PointLight) | (/X3D/Scene//Group[@DEF=$DEF]//PointLight) | (/X3D/Scene//Anchor[@DEF=$DEF]//PointLight) | (/X3D/Scene//Collision[@DEF=$DEF]//PointLight) | (/X3D/Scene//Billboard[@DEF=$DEF]//PointLight) | (/X3D/Scene//LOD[@DEF=$DEF]//PointLight) | (/X3D/Scene//Switch[@DEF=$DEF]//PointLight)">

                                        <xsl:call-template name="Lighting_descriptors">
                                            <xsl:with-param name="path"
                                                                                                        select="(/X3D/Scene//Transform[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Group[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Anchor[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Collision[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Billboard[@DEF=$DEF]//SpotLight) | (/X3D/Scene//LOD[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Switch[@DEF=$DEF]//SpotLight) | (/X3D/Scene//Transform[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Group[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Anchor[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Collision[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Billboard[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//LOD[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Switch[@DEF=$DEF]//DirectionalLight) | (/X3D/Scene//Transform[@DEF=$DEF]//PointLight) | (/X3D/Scene//Group[@DEF=$DEF]//PointLight) | (/X3D/Scene//Anchor[@DEF=$DEF]//PointLight) | (/X3D/Scene//Collision[@DEF=$DEF]//PointLight) | (/X3D/Scene//Billboard[@DEF=$DEF]//PointLight) | (/X3D/Scene//LOD[@DEF=$DEF]//PointLight) | (/X3D/Scene//Switch[@DEF=$DEF]//PointLight)"/>
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select=".//SpotLight | .//DirectionalLight | .//PointLight">
                                        <xsl:choose>
                                            <xsl:when test="@USE">
                                                <xsl:variable name="sh_DEF" select="@USE"/>
                                                <xsl:call-template name="Lighting_descriptors">
                                                    <xsl:with-param name="path" select="//SpotLight[$sh_DEF=@DEF] | //DirectionalLight[$sh_DEF=@DEF] | //PointLight[$sh_DEF=@DEF]"/>
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:call-template name="Lighting_descriptors">
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
                                            <xsl:text>Transform_</xsl:text>
                                            <xsl:number level="single" count="Transform" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Group">
                                            <xsl:text>Group_</xsl:text>
                                            <xsl:number level="single" count="Group" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Anchor">
                                            <xsl:text>Anchor_</xsl:text>
                                            <xsl:number level="single" count="Anchor" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Collision">
                                            <xsl:text>Collision_</xsl:text>
                                            <xsl:number level="single" count="Collision" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Billboard">
                                            <xsl:text>Billboard_</xsl:text>
                                            <xsl:number level="single" count="Billboard" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::LOD">
                                            <xsl:text>LOD_</xsl:text>
                                            <xsl:number level="single" count="LOD" from="Scene"/>
                                        </xsl:if>
                                        <xsl:if test="self::Switch">
                                            <xsl:text>Switch_</xsl:text>
                                            <xsl:number level="single" count="Switch" from="Scene"/>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>

                <xsl:for-each select="//SpotLight[(not(parent::Transform)) and (not(parent::Group)) and (not(parent::Anchor)) and (not(parent::Collision)) and (not(parent::Billboard)) and (not(parent::LOD)) and (not(parent::Switch))] | //DirectionalLight[(not(parent::Transform)) and (not(parent::Group)) and (not(parent::Anchor)) and (not(parent::Collision)) and (not(parent::Billboard)) and (not(parent::LOD)) and (not(parent::Switch))] | //PointLight[(not(parent::Transform)) and (not(parent::Group)) and (not(parent::Anchor)) and (not(parent::Collision)) and (not(parent::Billboard)) and (not(parent::LOD)) and (not(parent::Switch))]">
                    <xsl:element name="DescriptorCollection">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('Lighting_',generate-id())"/>
                        </xsl:attribute>
                        <xsl:attribute name="name">
                            <xsl:choose>
                                <xsl:when test="@DEF != ''">
                                    <xsl:value-of select="concat('Lighting_',@DEF)"/>
                                </xsl:when>
                                <xsl:when test="@USE != ''">
                                    <xsl:value-of select="concat('Lighting_',@USE)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="self::SpotLight">
                                        <xsl:text>SpotLight_</xsl:text>
                                        <xsl:number level="single" count="SpotLight" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::DirectionalLight">
                                        <xsl:text>DirectionalLight_</xsl:text>
                                        <xsl:number level="single" count="DirectionalLight" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::PointLight">
                                        <xsl:text>PointLight_</xsl:text>
                                        <xsl:number level="single" count="PointLight" from="Scene"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="@USE">
                                <xsl:variable name="sh_DEF" select="@USE"/>
                                <xsl:call-template name="Lighting_descriptors">
                                    <xsl:with-param name="path" select="//Lighting[$sh_DEF=@DEF]"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="Lighting_descriptors">
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
                                    <xsl:if test="self::SpotLight">
                                        <xsl:text>SpotLight_</xsl:text>
                                        <xsl:number level="single" count="SpotLight" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::DirectionalLight">
                                        <xsl:text>DirectionalLight_</xsl:text>
                                        <xsl:number level="single" count="DirectionalLight" from="Scene"/>
                                    </xsl:if>
                                    <xsl:if test="self::PointLight">
                                        <xsl:text>PointLight_</xsl:text>
                                        <xsl:number level="single" count="PointLight" from="Scene"/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="Lighting_descriptors">
        <xsl:param name="path"/>
        <xsl:element name="Descriptor">
            <xsl:attribute name="xsi:type">
                <xsl:text>Lighting3DType</xsl:text>
            </xsl:attribute>
            <xsl:element name="Lighting3D">
                <xsl:attribute name="name">
                    <xsl:choose>
                        <xsl:when test="@DEF != ''">
                            <xsl:value-of select="@DEF"/>
                        </xsl:when>
                        <xsl:when test="@USE != ''">
                            <xsl:value-of select="@USE"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="self::SpotLight">
                                <xsl:text>SpotLight_</xsl:text>
                                <xsl:number level="single" count="SpotLight" from="Scene"/>
                            </xsl:if>
                            <xsl:if test="self::DirectionalLight">
                                <xsl:text>DirectionalLight_</xsl:text>
                                <xsl:number level="single" count="DirectionalLight" from="Scene"/>
                            </xsl:if>
                            <xsl:if test="self::PointLight">
                                <xsl:text>PointLight_</xsl:text>
                                <xsl:number level="single" count="PointLight" from="Scene"/>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="lightingType">
                    <xsl:value-of select="name()"/>
                </xsl:attribute>
                <xsl:attribute name="isOn">
                    <xsl:choose>
                        <xsl:when test="@on">
                            <xsl:value-of select="@on"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>true</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="usedGlobally">
                    <xsl:choose>
                        <xsl:when test="@global">
                            <xsl:value-of select="@global"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>false</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:element>
            <xsl:element name="Lighting3DCharacteristics">
                <xsl:attribute name="ambientIntensity">
                    <xsl:choose>
                        <xsl:when test="@ambientIntensity">
                            <xsl:value-of select="@ambientIntensity"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>0</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="intensity">
                    <xsl:choose>
                        <xsl:when test="@intensity">
                            <xsl:value-of select="@intensity"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>1</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:if test="name()='SpotLight'">
                    <xsl:attribute name="beamWidth">
                        <xsl:choose>
                            <xsl:when test="@beamWidth">
                                <xsl:value-of select="@beamWidth"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>1.570796</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="name()='SpotLight'">
                    <xsl:attribute name="cutOffAngle">
                        <xsl:choose>
                            <xsl:when test="@cutOffAngle">
                                <xsl:value-of select="@cutOffAngle"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0.7854</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:if>
                <xsl:if test="(name()='SpotLight') or (name()='PointLight')">
                    <xsl:attribute name="radius">
                        <xsl:choose>
                            <xsl:when test="@radius">
                                <xsl:value-of select="@radius"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>100</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:if>
            </xsl:element>
            <xsl:element name="Lighting3DSpecs">
                <xsl:if test="(name()='SpotLight') or (name()='PointLight')">
                    <xsl:element name="Attenuation">
                        <xsl:choose>
                            <xsl:when test="@attenuation">
                                <xsl:value-of select="@attenuation"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>1 0 0</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
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
                            <xsl:choose>
                                <xsl:when test="@color">
                                    <xsl:value-of select="ceiling((number(tokenize(@color, ' ')[1])) * 255)"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="ceiling((number(tokenize(@color, ' ')[2])) * 255)"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="ceiling((number(tokenize(@color, ' ')[3])) * 255)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>1 1 1</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:if test="(name()='SpotLight') or (name()='DirectionalLight')">
                    <xsl:element name="Direction">
                        <xsl:choose>
                            <xsl:when test="@direction">
                                <xsl:value-of select="@direction"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0 0 0</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
                <xsl:if test="(name()='SpotLight') or (name()='PointLight')">
                    <xsl:element name="Location">
                        <xsl:choose>
                            <xsl:when test="@location">
                                <xsl:value-of select="@location"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>0 0 0</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="pointsCalculationX">
        <xsl:param name="count"/>
        <xsl:param name="count2"/>
        <xsl:param name="Xpoint"/>
        <xsl:param name="XpointMax" select="$Xpoint"/>
        <xsl:choose>
            <xsl:when test="$count &gt; 1">
                <!--<xsl:element name="POSITION">
                        <xsl:value-of select="$count"/>
                </xsl:element>-->
                <xsl:variable name="minXpoint" select="min(($Xpoint,number(tokenize($count2, ' ')[$count])))"/>
                <xsl:variable name="maxXpoint" select="max(($XpointMax,number(tokenize($count2, ' ')[$count])))"/>
                <!--<xsl:element name="NUMBERS">
                        <xsl:value-of select="tokenize($count2, ' ')[$count]"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$Xpoint"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$XpointMax"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$minXpoint"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$maxXpoint"/>
                </xsl:element>-->
                <xsl:call-template name="pointsCalculationX">
                    <xsl:with-param name="count" select="$count - 3"/>
                    <xsl:with-param name="count2" select="$count2"/>
                    <xsl:with-param name="Xpoint" select="$minXpoint"/>
                    <xsl:with-param name="XpointMax" select="$maxXpoint"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="XpointMinAndMax">
                    <xsl:value-of select="min(($Xpoint,number(tokenize($count2, ' ')[$count])))"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="max(($XpointMax,number(tokenize($count2, ' ')[$count])))"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="pointsCalculationY">
        <xsl:param name="count"/>
        <xsl:param name="count2"/>
        <xsl:param name="Ypoint"/>
        <xsl:param name="YpointMax" select="$Ypoint"/>
        <xsl:choose>
            <xsl:when test="$count &gt; 2">
                <!--<xsl:element name="POSITION">
                        <xsl:value-of select="$count"/>
                </xsl:element>-->
                <xsl:variable name="minYpoint" select="min(($Ypoint,number(tokenize($count2, ' ')[$count])))"/>
                <xsl:variable name="maxYpoint" select="max(($YpointMax,number(tokenize($count2, ' ')[$count])))"/>
                <!--<xsl:element name="NUMBERS">
                        <xsl:value-of select="tokenize($count2, ' ')[$count]"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$Ypoint"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$YpointMax"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$minYpoint"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$maxYpoint"/>
                </xsl:element>-->
                <xsl:call-template name="pointsCalculationY">
                    <xsl:with-param name="count" select="$count - 3"/>
                    <xsl:with-param name="count2" select="$count2"/>
                    <xsl:with-param name="Ypoint" select="$minYpoint"/>
                    <xsl:with-param name="YpointMax" select="$maxYpoint"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="YpointMINAndMAX">
                    <xsl:value-of select="min(($Ypoint,number(tokenize($count2, ' ')[$count])))"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="max(($YpointMax,number(tokenize($count2, ' ')[$count])))"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="pointsCalculationZ">
        <xsl:param name="count"/>
        <xsl:param name="count2"/>
        <xsl:param name="Zpoint"/>
        <xsl:param name="ZpointMax" select="$Zpoint"/>
        <xsl:choose>
            <xsl:when test="$count &gt; 3">
                <!--<xsl:element name="POSITION">
                        <xsl:value-of select="$count"/>
                </xsl:element>-->
                <xsl:variable name="minZpoint" select="min(($Zpoint,number(tokenize($count2, ' ')[$count])))"/>
                <xsl:variable name="maxZpoint" select="max(($ZpointMax,number(tokenize($count2, ' ')[$count])))"/>
                <!--<xsl:element name="NUMBERS">
                        <xsl:value-of select="tokenize($count2, ' ')[$count]"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$Zpoint"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$ZpointMax"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$minZpoint"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$maxZpoint"/>
                </xsl:element>-->
                <xsl:call-template name="pointsCalculationZ">
                    <xsl:with-param name="count" select="$count - 3"/>
                    <xsl:with-param name="count2" select="$count2"/>
                    <xsl:with-param name="Zpoint" select="$minZpoint"/>
                    <xsl:with-param name="ZpointMax" select="$maxZpoint"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="ZpointMINAndMAX">
                    <xsl:value-of select="min(($Zpoint,number(tokenize($count2, ' ')[$count])))"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="max(($ZpointMax,number(tokenize($count2, ' ')[$count])))"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="shapeExtraction">
        <xsl:param name="stringOfIFS"/>
        <xsl:variable name="countPoints" select="count(tokenize($stringOfIFS, ' '))"/>
        <xsl:element name="Shape3DType">
            <xsl:attribute name="xsi:type">
                <xsl:text>Shape3DType</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="bitsPerBin">
                <xsl:value-of select="tokenize($stringOfIFS, ' ')[1]"/>
            </xsl:attribute>
            <xsl:element name="Spectrum">
                <xsl:variable name="subtractLastPoint">
                    <xsl:call-template name="substring-before-last">
                        <xsl:with-param name="allIfsString" select="substring-after($stringOfIFS, ' ')"/>
                        <xsl:with-param name="delimiter" select="' '"/>
                    </xsl:call-template>
                </xsl:variable>
                <!--KALEITAI ALLI MIA ORA OSTE NA AFAIRETHEI KAI TO PROTELEUTAIO POINT-->
                <xsl:call-template name="substring-before-last">
                    <xsl:with-param name="allIfsString" select="$subtractLastPoint"/>
                    <xsl:with-param name="delimiter" select="' '"/>
                </xsl:call-template>
            </xsl:element>
            <xsl:element name="PlanarSurfaces">
                <xsl:value-of select="tokenize($stringOfIFS, ' ')[$countPoints - 1]"/>
            </xsl:element>
            <xsl:element name="SingularSurfaces">
                <xsl:value-of select="tokenize($stringOfIFS, ' ')[$countPoints]"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="extrusionShapeExtraction">
        <xsl:param name="stringOfExtr"/>
        <xsl:variable name="countPoints" select="count(tokenize($stringOfExtr, ' '))"/>
        <xsl:element name="Shape3DType">
            <xsl:attribute name="xsi:type">
                <xsl:text>Shape3DType</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="bitsPerBin">
                <xsl:value-of select="tokenize($stringOfExtr, ' ')[1]"/>
            </xsl:attribute>
            <xsl:element name="Spectrum">
                <xsl:variable name="subtractLastPoint">
                    <xsl:call-template name="substring-before-last">
                        <xsl:with-param name="allIfsString" select="substring-after($stringOfExtr, ' ')"/>
                        <xsl:with-param name="delimiter" select="' '"/>
                    </xsl:call-template>
                </xsl:variable>
                <!--KALEITAI ALLI MIA ORA OSTE NA AFAIRETHEI KAI TO PROTELEUTAIO POINT-->
                <xsl:call-template name="substring-before-last">
                    <xsl:with-param name="allIfsString" select="$subtractLastPoint"/>
                    <xsl:with-param name="delimiter" select="' '"/>
                </xsl:call-template>
            </xsl:element>
            <xsl:element name="PlanarSurfaces">
                <xsl:value-of select="tokenize($stringOfExtr, ' ')[$countPoints - 1]"/>
            </xsl:element>
            <xsl:element name="SingularSurfaces">
                <xsl:value-of select="tokenize($stringOfExtr, ' ')[$countPoints]"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="extrusionBBoxTemplate">
        <xsl:param name="stringOfExtrBBox"/>
        <xsl:element name="BoundingBox3DSize">
            <xsl:attribute name="BoxWidth">
                <xsl:value-of select="tokenize($stringOfExtrBBox, ' ')[1]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxHeight">
                <xsl:value-of select="tokenize($stringOfExtrBBox, ' ')[2]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxDepth">
                <xsl:value-of select="tokenize($stringOfExtrBBox, ' ')[3]"/>
            </xsl:attribute>
        </xsl:element>
        <xsl:element name="BoundingBox3DCenter">
            <xsl:attribute name="BoxCenterW">
                <xsl:value-of select="tokenize($stringOfExtrBBox, ' ')[4]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxCenterH">
                <xsl:value-of select="tokenize($stringOfExtrBBox, ' ')[5]"/>
            </xsl:attribute>
            <xsl:attribute name="BoxCenterD">
                <xsl:value-of select="tokenize($stringOfExtrBBox, ' ')[6]"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <xsl:template name="substring-before-last">
        <xsl:param name="allIfsString"/>
        <xsl:param name="delimiter"/>
        <xsl:choose>
            <xsl:when test="contains($allIfsString, $delimiter)">
                <xsl:value-of select="substring-before($allIfsString, $delimiter)"/>
                <xsl:choose>
                    <xsl:when test="contains(substring-after($allIfsString, $delimiter), $delimiter)">
                        <xsl:value-of select="$delimiter"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:call-template name="substring-before-last">
                    <xsl:with-param name="allIfsString" select="substring-after($allIfsString, $delimiter)"/>
                    <xsl:with-param name="delimiter" select="$delimiter"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:transform>