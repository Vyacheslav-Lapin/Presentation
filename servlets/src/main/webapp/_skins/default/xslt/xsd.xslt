<!DOCTYPE stylesheet [

        <!--*<!DOCTYPE stylesheet PUBLIC 'http://www.w3.org/1999/XSL/Transform' '../../_xml/_xsd/lib/XSLT1/xslt10.dtd' [*-->

        <!ATTLIST stylesheet
                xmlns CDATA "http://www.w3.org/1999/XSL/Transform"
                xmlns:xsd CDATA #IMPLIED
                xmlns:xhtml CDATA #IMPLIED>
        <!ATTLIST text
                xmlns:xsl CDATA "http://www.w3.org/1999/XSL/Transform">

        <!ENTITY copy   "&#169;" ><!--=copyright sign-->
        <!ENTITY reg    "&#174;" ><!--/circledR =registered sign-->
        <!ENTITY rarr   "&#x2192;" ><!--/rightarrow /to A: =rightward arrow-->

        <!ENTITY nl "&#xA0;">
        <!ENTITY lsquo  "&#x2018;" ><!--=single quotation mark, left-->
        <!ENTITY rsquo  "&#x2019;" ><!--=single quotation mark, right-->
        <!ENTITY ldquo  "&#x201C;" ><!--=double quotation mark, left-->
        <!ENTITY rdquo  "&#x201D;" ><!--=double quotation mark, right-->]>
<stylesheet version="1.0"
            xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema"
            xmlns:xhtml="http://www.w3.org/1999/xhtml">

    <!--* xsd.  format an XSD schema document for simple display in a Web browser.
        * http://www.w3.org/XML/2004/xml-schema-test-suite/xsd.xsl
        *
        * Copyright © 2008-2009 World Wide Web Consortium, (Massachusetts
        * Institute of Technology, European Research Consortium for
        * Informatics and Mathematics, Keio University). All Rights
        * Reserved. This work is distributed under the W3C® Software
        * License [1] in the hope that it will be useful, but WITHOUT ANY
        * WARRANTY; without even the implied warranty of MERCHANTABILITY or
        * FITNESS FOR A PARTICULAR PURPOSE.
        *
        * [1] http://www.w3.org/Consortium/Legal/2002/copyright-software-20021231
        *
        *-->

    <!--* Revisions:
        * 2012-05-03 : CMSMcQ : reissue under Software License, not document
        *                       license
        * 2009-01-21 : CMSMcQ : wrap start-tags only when necessary
        * 2009-01-20 : CMSMcQ : wrap start-tags
        * 2008-12-19 : CMSMcQ : add toc for schema documents with more than
        *                       five children of xsd:schema
        * 2008-12-18 : CMSMcQ : fix problems with text breaking
        *                       add rule for top-level attribute groups
        * 2008-09-27 : CMSMcQ : made first version of this stylesheet
        *-->

    <output method="html" indent="yes"/>

    <param name="line-wrap-length" select="60"/>
    <param name="ind-depth" select="6"/>
    <param name="additional-indent" select="substring(
  '                                                                                ',
  1,$ind-depth)"/>

    <variable name="tns">
        <value-of select="/xsd:schema/@targetNamespace"/>
    </variable>

    <!--* 0 Document root *-->
    <template match="/">

        <variable name="doctitle">
            <text>Schema document for </text>
            <choose>
                <when test="xsd:schema/@targetNamespace">
                    <text>namespace </text>
                    <value-of select="$tns"/>
                </when>
                <otherwise>
                    <text>unspecified namespace</text>
                </otherwise>
            </choose>
        </variable>

        <variable name="docHasHeading" select="xsd:schema/xsd:annotation[1]/xsd:documentation/*[1] [self::xhtml:h1 or self::h1] or xsd:schema/xsd:annotation[1]/xsd:documentation/xhtml:div/*[1] [self::xhtml:h1 or self::h1]"/>
        <variable name="docIsProlific" select="count(xsd:schema/child::*) &gt; 5"/>

        <element name="html">
            <element name="head">
                <element name="title">
                    <value-of select="$doctitle"/>
                </element>
                <element name="style">
                    <attribute name="type">text/css</attribute>
                    .bodytext .bodytext {
                    margin-left: 0;
                    margin-right: 0;
                    }
                    .bodytext {
                    margin-left: 15%;
                    margin-right: 2%;
                    }
                    .annotation {
                    <!--* anything special to do here? *-->
                    <!--* color: navy; *-->
                    }
                    .same-ns {
                    color: Green;
                    }
                    .diff-ns {
                    color: maroon;
                    }
                    .warning {
                    color: red;
                    }
                    p.note {
                    font-style: italic;
                    }
                    p.dt {
                    font-weight: bold;
                    }
                    span.rfc {
                    font-variant: small-caps;
                    }
                </element>
            </element>
            <element name="body">

                <choose>
                    <when test="$docHasHeading and not($docIsProlific)">
                        <!--* If the first thing in the first documentation element is a heading,
                            * and there are few children, then don't interfere.
                            *-->
                        <comment>* <value-of select="$doctitle"/> *</comment>
                    </when>
                    <otherwise>
                        <!--* either document has no heading (and needs one), or
                            * we're going to do a toc and need a heading anyway
                            *-->
                        <element name="h1">
                            <value-of select="$doctitle"/>
                        </element>
                        <if test="$docIsProlific">
                            <element name="div">
                                <element name="hr"/>
                                <element name="ul">
                                    <attribute name="class">bodytext</attribute>
                                    <apply-templates mode="toc" select="./xsd:schema/*"/>
                                </element>
                                <element name="hr"/>
                            </element>
                        </if>
                    </otherwise>
                </choose>
                <apply-templates/>
            </element>
        </element>
    </template>

    <!--* 2 Schema element *-->
    <template match="xsd:schema">
        <!--* optional future change:  write out information here about
            * the attributes of xsd:schema:  version, finalDefault, blockDefault,
            * elementFormDefault, atgtributeFormDefault, namespace bindings ...
            *-->
        <apply-templates/>
    </template>

    <!--* 3 Anotation *-->
    <template match="xsd:annotation">
        <element name="div">
            <attribute name="class">annotation</attribute>
            <attribute name="id">
                <call-template name="leid">
                </call-template>
            </attribute>
            <if test="not(./xsd:documentation//*[@class='bodytext'])">
                <element name="h3">Annotation</element>
            </if>
            <element name="div">
                <choose>
                    <when test="./xsd:documentation//*[@class='bodytext']">
                        <!--* if the schema document is already using class=bodytext,
                            * let the schema author control the margins, don't
                            * assign the class here.
                            *-->
                    </when>
                    <otherwise>
                        <attribute name="class">bodytext</attribute>
                    </otherwise>
                </choose>
                <apply-templates/>
            </element>
        </element>
    </template>

    <template match="xsd:documentation">
        <choose>
            <when test=".//xhtml:* or .//div or .//p or .//li">
                <copy-of select="*"/>
            </when>
            <when test="./*">
                <message>! Unrecognized children in xs:documentation element</message>
                <copy-of select="*"/>
            </when>
            <otherwise>
                <call-template name="break-pcdata">
                    <with-param name="s" select="string(.)"/>
                </call-template>
            </otherwise>
        </choose>
    </template>

    <template name="break-pcdata">
        <param name="s"/>

        <choose>
            <when test="starts-with($s,'&#xA0;')">
                <text>&#xA0;</text>
                <element name="br"/>
                <call-template name="break-pcdata">
                    <with-param name="s" select="substring($s,2)"/>
                </call-template>
            </when>
            <when test="starts-with($s,' ')">
                <text>&#xA0;</text>
                <call-template name="break-pcdata">
                    <with-param name="s" select="substring($s,2)"/>
                </call-template>
            </when>
            <when test="contains($s,'&#xA0;')">
                <value-of select="substring-before($s,'&#xA0;')"/>
                <text>&#xA0;</text>
                <element name="br"/>
                <call-template name="break-pcdata">
                    <with-param name="s" select="substring-after($s,'&#xA0;')"/>
                </call-template>
            </when>
            <otherwise>
                <value-of select="$s"/>
            </otherwise>
        </choose>
    </template>

    <!--* 4 Top-level components *-->
    <template match="
    xsd:schema/xsd:attribute
  | xsd:schema/xsd:element
  | xsd:schema/xsd:simpleType
  | xsd:schema/xsd:complexType
  | xsd:schema/xsd:attributeGroup
  | xsd:schema/xsd:import
  | xsd:schema/xsd:group
  | xsd:schema/xsd:notation
  ">
        <call-template name="show-top-level-component"/>
    </template>

    <template name="show-top-level-component">
        <variable name="sort">
            <call-template name="sort"/>
        </variable>
        <variable name="leid">
            <call-template name="leid"/>
        </variable>
        <variable name="has-heading-already">
            <choose>
                <when test="./xsd:annotation[1]/xsd:documentation/*//*
       [self::xhtml:*[starts-with(local-name(),'h')]
        or
        self::*[contains(' h1 h2 h3 h4 h5 ',local-name())]
       ]">
                    <value-of select="'true'"/>
                </when>
                <otherwise>
                    <value-of select="'false'"/>
                </otherwise>
            </choose>
        </variable>

        <element name="div">
            <attribute name="id">
                <value-of select="$leid"/>
            </attribute>
            <element name="h3">
                <element name="a">
                    <attribute name="name">
                        <value-of select="$leid"/>
                    </attribute>
                    <value-of select="concat($sort,' ')"/>
                    <choose>
                        <when test="count(@name) = 1">
                            <element name="em">
                                <value-of select="@name"/>
                            </element>
                        </when>
                        <when test="self::xsd:import and (count(@namespace) = 1)">
                            <element name="code">
                                <value-of select="@namespace"/>
                            </element>
                        </when>
                    </choose>
                </element>
            </element>

            <element name="div">
                <attribute name="class">bodytext</attribute>

                <if test="./xsd:annotation/xsd:documentation">
                    <element name="div">
                        <if test="$has-heading-already = 'false'">
                            <element name="h4">Notes</element>
                        </if><!-- /if .$has-heading-already *-->
                        <apply-templates select="xsd:annotation/xsd:documentation"/>
                        <if test="count(./xsd:annotation/xsd:documentation/@source) = 1">
                            <element name="p">
                                <text>External documentation at </text>
                                <element name="code">
                                    <element name="a">
                                        <attribute name="href">
                                            <value-of select="./xsd:annotation/xsd:documentation/@source"/>
                                        </attribute>
                                        <value-of select="./xsd:annotation/xsd:documentation/@source"/>
                                    </element>
                                </element>
                            </element>
                        </if>
                    </element>
                </if><!-- /if ./xsd:annotation/xsd:documentation *-->

                <element name="div">
                    <element name="h4">Formal declaration in XSD source form</element>
                    <element name="pre">
                        <variable name="preceding-node"
                                  select="./preceding-sibling::node()[1]"/>
                        <if test="not($preceding-node/self::*)
       and (normalize-space($preceding-node) = '')">
                            <value-of select="$preceding-node"/>
                        </if>
                        <apply-templates select="." mode="echo-xml"/>
                    </element>
                </element><!--* div for XSD source form *-->
            </element><!--* div for documentation and formal description *-->

        </element><!--* div for top-level component *-->
    </template>


    <!--* 5 xml mode *-->
    <template match="*" mode="echo-xml">
        <variable name="s0">
            <call-template name="lastline-suffix">
                <with-param name="s0" select="preceding-sibling::text()
     [string-length(.) > 0][1]" />
            </call-template>
        </variable>
        <variable name="width">
            <call-template name="stag-width">
                <with-param name="indent-length" select="string-length($s0)"/>
            </call-template>
        </variable>
        <!--* <message>Start-tag width for <value-of select="name()"/>
              = <value-of select="$width"/></message> *-->

        <text>&lt;</text>
        <value-of select="name()"/>
        <apply-templates select="@*" mode="echo-xml">
            <with-param name="break-or-nobreak">
                <choose>
                    <when test="$width > $line-wrap-length">break</when>
                    <otherwise>nobreak</otherwise>
                </choose>
            </with-param>
            <with-param name="s0">
                <call-template name="lastline-suffix">
                    <with-param name="s0" select="preceding-sibling::text()
      [string-length(.) > 0][1]" />
                </call-template>
            </with-param>
        </apply-templates>
        <choose>
            <when test="child::node()">
                <text>&gt;</text>
                <apply-templates select="node()" mode="echo-xml"/>
                <text>&lt;/</text>
                <value-of select="name()"/>
                <text>&gt;</text>
            </when>
            <otherwise>/&gt;</otherwise>
        </choose>
        <!--*  </element> *-->
    </template>

    <template match="xsd:annotation" mode="echo-xml"/>
    <template match="@xml:space" mode="echo-xml"/>

    <template match="@*" mode="echo-xml">
        <param name="break-or-nobreak">nobreak</param>
        <param name="s0"></param>
        <variable name="indent">
            <choose>
                <when test="normalize-space($s0) = ''">
                    <value-of select="concat($additional-indent,$s0)"/>
                </when>
                <otherwise>
                    <value-of select="'    '"/>
                </otherwise>
            </choose>
        </variable>

        <choose>
            <when test="parent::xsd:* and $break-or-nobreak = 'break'">
                <text>&#xA0;</text>
                <value-of select="$indent"/>
            </when>
            <otherwise>
                <text> </text>
            </otherwise>
        </choose>
        <value-of select="name()"/>
        <text>="</text>
        <choose>
            <when test="(parent::xsd:element) and namespace-uri() = '' and local-name() = 'ref'">
                <call-template name="makelink-maybe"/>
            </when>
            <when test="(parent::xsd:attribute) and namespace-uri() = '' and local-name() = 'ref'">
                <call-template name="makelink-maybe"/>
            </when>
            <when test="parent::xsd:restriction and namespace-uri() = '' and local-name() = 'base'">
                <call-template name="makelink-maybe"/>
            </when>
            <when test="parent::xsd:extension and namespace-uri() = '' and local-name() = 'base'">
                <call-template name="makelink-maybe"/>
            </when>
            <when test="parent::xsd:group and namespace-uri() = '' and local-name() = 'ref'">
                <call-template name="makelink-maybe"/>
            </when>
            <when test="parent::xsd:list and namespace-uri() = '' and local-name() = 'itemType'">
                <call-template name="makelink-maybe"/>
            </when>
            <when test="parent::xsd:union and namespace-uri() = '' and local-name() = 'memberTypes'">
                <call-template name="makelink-several-maybe"/>
            </when>
            <when test="(parent::xsd:element) and namespace-uri() = '' and local-name() = 'type'">
                <call-template name="makelink-maybe"/>
            </when>
            <when test="(parent::xsd:attribute) and namespace-uri() = '' and local-name() = 'type'">
                <call-template name="makelink-maybe"/>
            </when>
            <when test="(parent::xsd:element) and namespace-uri() = '' and local-name() = 'substitutionGroup'">
                <call-template name="makelink-several-maybe"/>
            </when>

            <otherwise>
                <value-of select="."/>
            </otherwise>
        </choose>
        <text>"</text>

    </template>
    <template match="text()" mode="echo-xml">
        <value-of select="."/>
    </template>


    <!--* 6 toc *-->
    <template mode="toc" match="
    xsd:schema/xsd:annotation
  | xsd:schema/xsd:attribute
  | xsd:schema/xsd:element
  | xsd:schema/xsd:simpleType
  | xsd:schema/xsd:complexType
  | xsd:schema/xsd:attributeGroup
  | xsd:schema/xsd:import
  | xsd:schema/xsd:group
  | xsd:schema/xsd:notation
  ">
        <call-template name="toc-entry"/>
    </template>

    <template name="toc-entry">
        <variable name="sort">
            <call-template name="sort"/>
        </variable>
        <variable name="leid">
            <call-template name="leid"/>
        </variable>
        <element name="li">
            <element name="a">
                <attribute name="href">
                    <value-of select="concat('#',$leid)"/>
                </attribute>
                <choose>
                    <when test="self::xsd:annotation
      and
      ( descendant::xhtml:h1 or descendant::xhtml:h2 or descendant::xhtml:h3
        or descendant::h1 or descendant::h2 or descendant::h3)
      ">
                        <choose>
                            <when test="descendant::xhtml:h1">
                                <value-of select="descendant::xhtml:h1[1]"/>
                            </when>
                            <when test="descendant::h1">
                                <value-of select="descendant::h1[1]"/>
                            </when>
                            <when test="descendant::xhtml:h2">
                                <value-of select="descendant::xhtml:h2[1]"/>
                            </when>
                            <when test="descendant::h2">
                                <value-of select="descendant::h2[1]"/>
                            </when>
                            <when test="descendant::xhtml:h3">
                                <value-of select="descendant::xhtml:h3[1]"/>
                            </when>
                            <when test="descendant::h3">
                                <value-of select="descendant::h3[1]"/>
                            </when>
                        </choose>

                    </when>
                    <otherwise>
                        <value-of select="concat($sort,' ')"/>
                        <choose>
                            <when test="count(@name) = 1">
                                <element name="em">
                                    <value-of select="@name"/>
                                </element>
                            </when>
                            <when test="self::xsd:annotation">
                                <value-of select="1 + count(preceding-sibling::xsd:annotation)"/>
                            </when>
                            <when test="self::xsd:import">
                                <element name="code">
                                    <value-of select="@namespace"/>
                                </element>
                            </when>
                            <otherwise>
                                <!--* fake it *-->
                                <variable name="gi" select="local-name()"/>
                                <value-of select="1 + count(preceding-sibling::*[local-name() = $gi])"/>
                            </otherwise>
                        </choose>
                    </otherwise>
                </choose>
            </element>
        </element>

    </template>

    <!--* 7 common code for calculating sort and little-endian IDs *-->
    <template name="sort">
        <choose>
            <when test="self::xsd:annotation">
                <value-of select="'Annotation'"/>
            </when>
            <when test="self::xsd:attribute">
                <value-of select="'Attribute'"/>
            </when>
            <when test="self::xsd:element">
                <value-of select="'Element'"/>
            </when>
            <when test="self::xsd:simpleType">
                <value-of select="'Simple type'"/>
            </when>
            <when test="self::xsd:complexType">
                <value-of select="'Complex type'"/>
            </when>
            <when test="self::xsd:attributeGroup">
                <value-of select="'Attribute group'"/>
            </when>
            <when test="self::xsd:group">
                <value-of select="'Model group'"/>
            </when>
            <otherwise>
                <variable name="gi" select="local-name()"/>
                <value-of select="concat(
      translate(substring($gi,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
      substring($gi,2)
     )"/>
            </otherwise>
        </choose>
    </template>
    <template name="leid">
        <choose>
            <when test="self::xsd:annotation">
                <value-of select="concat('ann_',
     string(1+count(preceding-sibling::xsd:annotation)))"/>
            </when>
            <when test="self::xsd:attribute">
                <value-of select="concat('att_',@name)"/>
            </when>
            <when test="self::xsd:element">
                <value-of select="concat('elem_',@name)"/>
            </when>
            <when test="self::xsd:simpleType">
                <value-of select="concat('type_',@name)"/>
            </when>
            <when test="self::xsd:complexType">
                <value-of select="concat('type_',@name)"/>
            </when>
            <when test="self::xsd:attributeGroup">
                <value-of select="concat('attgrp_',@name)"/>
            </when>
            <when test="self::xsd:group">
                <value-of select="concat('grp_',@name)"/>
            </when>
            <when test="self::xsd:import">
                <value-of select="concat('imp_',
     string(1+count(preceding-sibling::xsd:import)))"/>
            </when>
            <otherwise>
                <choose>
                    <when test="@name">
                        <variable name="sort" select="local-name()"/>
                        <value-of select="concat($sort,'_',@name)"/>
                    </when>
                    <otherwise>
                        <variable name="sort" select="local-name()"/>
                        <variable name="pos"  select="1 + count(preceding-sibling::*[local-name() = $sort])"/>
                        <value-of select="concat($sort,'_',$pos)"/>
                    </otherwise>
                </choose>
            </otherwise>
        </choose>
    </template>

    <!--* 8 unmatched elements (mostly diagnostic for development) *-->
    <template match="*|@*">
        <variable name="fqgi">
            <call-template name="fqgi"/>
        </variable>
        <message>Warning: <value-of select="$fqgi"/> not matched.</message>
        <element name="div">
            <attribute name="class">warning</attribute>
            <value-of select="concat('&lt;',name(),'>')"/>
            <copy>
                <apply-templates select="@*|node()"/>
            </copy>
            <value-of select="concat('&lt;/',name(),'>')"/>
        </element>
    </template>

    <template name="fqgi" match="*" mode="fqgi">
        <param name="sBuf"/>
        <variable name="sCur">
            <choose>
                <when test="self::*">
                    <!--* elements *-->
                    <value-of select="name()"/>
                </when>
                <otherwise>
                    <!--* attributes and other riffraff *-->
                    <value-of select="concat('@',name())"/>
                </otherwise>
            </choose>
        </variable>
        <!--*
        <message>FQGI(<value-of select="concat($sBuf,',',$sCur)"/>)</message>
        *-->
        <choose>
            <when test="parent::*">
                <apply-templates mode="fqgi" select="parent::*">
                    <with-param name="sBuf">
                        <value-of select="concat('/',$sCur,$sBuf)"/>
                    </with-param>
                </apply-templates>
            </when>
            <otherwise>
                <value-of select="concat('/',$sCur,$sBuf)"/>
            </otherwise>
        </choose>
    </template>


    <!--* 9 intra-document link calculation, qname manipulation *-->
    <template name="makelink-several-maybe">
        <param name="lQNames" select="normalize-space(.)"/>
        <choose>
            <when test="contains($lQNames,' ')">
                <!--* recur *-->
                <call-template name="makelink-maybe">
                    <with-param name="qn" select="substring-before($lQNames,' ')"/>
                </call-template>
                <text> </text>
                <call-template name="makelink-several-maybe">
                    <with-param name="lQNames" select="substring-after($lQNames,' ')"/>
                </call-template>
            </when>
            <otherwise>
                <!--* base step, no blank so at most one QName *-->
                <call-template name="makelink-maybe">
                    <with-param name="qn" select="$lQNames"/>
                </call-template>
            </otherwise>
        </choose>
    </template>

    <template name="makelink-maybe">
        <param name="qn" select="."/>
        <param name="refns">
            <call-template name="qname-to-uri">
                <with-param name="qname" select="$qn"/>
            </call-template>
        </param>
        <param name="lname">
            <call-template name="qname-to-ncname">
                <with-param name="qname" select="$qn"/>
            </call-template>
        </param>

        <variable name="linktarget">
            <choose>
                <when test="$tns = $refns">
                    <choose>
                        <when test="(parent::xsd:element) and local-name() = 'ref' and count(/xsd:schema/xsd:element[@name = $lname]) = 1">
                            <value-of select="concat('elem_',$lname)"/>
                        </when>
                        <when test="(parent::xsd:element) and local-name() = 'substitutionGroup' and count(/xsd:schema/xsd:element[@name = $lname]) = 1">
                            <value-of select="concat('elem_',$lname)"/>
                        </when>
                        <when test="(parent::xsd:attribute) and local-name() = 'ref' and count(/xsd:schema/xsd:attribute[@name = $lname]) = 1">
                            <value-of select="concat('att_',$lname)"/>
                        </when>
                        <when test="(parent::xsd:restriction) and count(/xsd:schema/xsd:*[@name = $lname and (self::xsd:simpleType or self::xsd:complexType)]) = 1">
                            <value-of select="concat('type_',$lname)"/>
                        </when>
                        <when test="(parent::xsd:extension) and count(/xsd:schema/xsd:*[@name = $lname and (self::xsd:simpleType or self::xsd:complexType)]) = 1">
                            <value-of select="concat('type_',$lname)"/>
                        </when>
                        <when test="(parent::xsd:element) and local-name() = 'type' and count(/xsd:schema/xsd:*[@name = $lname and (self::xsd:simpleType or self::xsd:complexType)]) = 1">
                            <value-of select="concat('type_',$lname)"/>
                        </when>
                        <when test="(parent::xsd:attribute) and local-name() = 'type' and count(/xsd:schema/xsd:*[@name = $lname and (self::xsd:simpleType or self::xsd:complexType)]) = 1">
                            <value-of select="concat('type_',$lname)"/>
                        </when>
                        <when test="(parent::xsd:list) and count(/xsd:schema/xsd:*[@name = $lname and (self::xsd:simpleType or self::xsd:complexType)]) = 1">
                            <value-of select="concat('type_',$lname)"/>
                        </when>
                        <when test="(parent::xsd:union) and count(/xsd:schema/xsd:*[@name = $lname and (self::xsd:simpleType or self::xsd:complexType)]) = 1">
                            <value-of select="concat('type_',$lname)"/>
                        </when>
                        <when test="(parent::xsd:group) and count(/xsd:schema/xsd:group[@name = $lname]) = 1">
                            <value-of select="concat('grp_',$lname)"/>
                        </when>
                        <when test="(parent::xsd:attributeGroup) and count(/xsd:schema/xsd:atributeGroup[@name = $lname]) = 1">
                            <value-of select="concat('attgrp_',$lname)"/>
                        </when>
                        <!--* static links to built-ins could be handled here *-->
                    </choose>
                </when>
                <when test="count(ancestor::*/namespace::*) = 0">
                    <!--* we are either in a no-namespace document in Opera,
                        * or we are in Firefox, without ns support.
                        *-->
                    <value-of select="'no-ns-support'"/>
                </when>
                <otherwise>
                    <!--* namespaces did not match, no target *-->
                    <value-of select="'no-target'"/>
                </otherwise>
            </choose>
        </variable>

        <choose>
            <when test="($linktarget='no-ns-support')">
                <value-of select="$qn"/>
            </when>
            <when test="($linktarget='no-target' or $linktarget='')
    and ($tns = $refns)">
                <element name="span">
                    <attribute name="class">external-link same-ns</attribute>
                    <value-of select="$qn"/>
                </element>
            </when>
            <when test="($linktarget='no-target')
    and not($tns = $refns)">
                <element name="span">
                    <attribute name="class">external-link diff-ns</attribute>
                    <value-of select="$qn"/>
                </element>
            </when>
            <otherwise>
                <element name="a">
                    <attribute name="href">
                        <value-of select="concat('#',$linktarget)"/>
                    </attribute>
                    <value-of select="$qn"/>
                </element>
            </otherwise>
        </choose>
    </template>

    <template name="qname-to-uri" match="*" mode="qname-to-uri">
        <param name="qname" select="."/>
        <variable name="prefix" select="substring-before($qname,':')"/>
        <choose>
            <when test="(1=1) and ($prefix='xml')">
                <!--* we need to special-case 'xml', since
                    * Opera does not provide a ns node for it.
                    *-->
                <value-of select="'http://www.w3.org/XML/1998/namespace'"/>
            </when>
            <when test="self::*">
                <!--* we're an element *-->
                <value-of select="string(namespace::*[name()=$prefix])"/>
            </when>
            <otherwise>
                <!--* we're not an element *-->
                <value-of select="string(parent::*/namespace::*[name()=$prefix])"/>
            </otherwise>
        </choose>
    </template>
    <template name="qname-to-ncname">
        <param name="qname" select="."/>
        <choose>
            <when test="contains($qname,':')">
                <value-of select="substring-after($qname,':')"/>
            </when>
            <otherwise>
                <value-of select="$qname"/>
            </otherwise>
        </choose>
    </template>

    <template name="lastline-suffix">
        <param name="s0"></param>
        <choose>
            <when test="contains($s0,'&#xA0;')">
                <call-template name="lastline-suffix">
                    <with-param name="s0" select="substring-after($s0,'&#xA0;')"/>
                </call-template>
            </when>
            <otherwise>
                <value-of select="$s0"/>
            </otherwise>
        </choose>
    </template>


    <template name="stag-width">
        <param name="indent-length" select="0"/>

        <variable name="attcount" select="count(@*)"/>
        <variable name="list-attname-lengths">
            <call-template name="make-length-list">
                <with-param name="kw">attnames</with-param>
            </call-template>
        </variable>

        <variable name="list-attval-lengths">
            <call-template name="make-length-list">
                <with-param name="kw">attvals</with-param>
            </call-template>
        </variable>

        <variable name="sum-att-lengths">
            <call-template name="sum-list">
                <with-param name="s0" select="concat($list-attname-lengths,' ',$list-attval-lengths)"/>
            </call-template>
        </variable>

        <!--*
        <message>indent-length = <value-of select="$indent-length"/></message>
        <message>attcount = <value-of select="$attcount"/></message>
        <message>sum-att-lengths = <value-of select="$sum-att-lengths"/></message>
        <message>namelen = <value-of select="string-length(name())"/></message>
        *-->

        <value-of select="$indent-length + (4 * $attcount) + $sum-att-lengths + string-length(name()) + 3"/>

    </template>


    <template name="make-length-list">
        <param name="kw">unknown</param>
        <choose>
            <when test="$kw = 'attnames'">
                <apply-templates select="@*" mode="attnamelength"/>
            </when>
            <when test="$kw = 'attvals'">
                <apply-templates select="@*" mode="attvallength"/>
            </when>
            <otherwise>0</otherwise>
        </choose>
    </template>

    <template name="sum-list">
        <param name="n0" select="0"/>
        <param name="s0"/>

        <variable name="s1" select="normalize-space($s0)"/>

        <!--*
        <message><value-of select="concat('n0 =', $n0, ', s1 = /',$s1,'/')"/></message>
        *-->

        <choose>
            <when test="contains($s1,' ')">
                <variable name="term" select="substring-before($s1,' ')"/>
                <variable name="s2" select="substring-after($s1,' ')"/>
                <call-template name="sum-list">
                    <with-param name="n0" select="$n0 + number($term)"/>
                    <with-param name="s0" select="$s2"/>
                </call-template>
            </when>
            <otherwise>
                <value-of select="$n0 + number($s1)"/>
            </otherwise>
        </choose>
    </template>

    <template match="@*" mode="attnamelength">
        <value-of select="concat(string-length(name()), ' ')"/>
    </template>
    <template match="@*" mode="attvallength">
        <value-of select="concat(string-length(.), ' ')"/>
    </template>

</stylesheet>
        <!-- Keep this comment at the end of the file
        Local variables:
        mode: xml
        sgml-default-dtd-file:"/Library/SGML/Public/Emacs/xslt.ced"
        sgml-omittag:t
        sgml-shorttag:t
        sgml-indent-data:t
        sgml-indent-step:1
        End:
        -->