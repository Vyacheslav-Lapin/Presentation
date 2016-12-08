<?xml version="1.0" encoding="utf-8" ?>
<?xml-stylesheet type="text/xsl" href="/_skins/default/xslt/xsd.xslt"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:thm="http://vlapin.ru/presentation/theme"
                xmlns:prsn="http://vlapin.ru/presentation/person"
                xmlns:sld="http://vlapin.ru/presentation/slide"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://vlapin.ru/presentation/slide /_schemas/slide.xsd
                                    http://vlapin.ru/presentation/person /_schemas/person.xsd
                                    http://vlapin.ru/presentation/theme /_schemas/theme.xsd">

    <xsl:output method="html" indent="yes"/>

    <xsl:variable name="title">
        <xsl:value-of select="/*/@title"/>
    </xsl:variable>

    <xsl:template match="/">
        <html>
            <xsl:attribute name="lang">
                <xsl:value-of select="*/@lang"/>
            </xsl:attribute>
            <head>
                <title>
                    <xsl:value-of select="$title"/>
                </title>
                <link rel="stylesheet" type="text/less" href="/_skins/default/css/style.less"/>
                <script src="http://cdnjs.cloudflare.com/ajax/libs/less.js/2.7.1/less.min.js"/>
            </head>
            <body>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="/*">
        <section class="cover">
            <header>
                <h1>
                    <xsl:value-of select="$title"/>
                </h1>
                <h2>
                    <xsl:value-of select="@subtitle"/>
                </h2>
            </header>
            <article class="author">
                <xsl:value-of select="thm:authors/prsn:person/prsn:name/@first"/>
                <xsl:value-of select="thm:authors/prsn:person/prsn:name/@last"/>
                <!--<xsl:value-of select="thm:authors/prsn:person/prsn:name/@patronymic"/>-->
            </article>
        </section>

        <xsl:apply-templates/>

        <section class="end">

        </section>
    </xsl:template>

</xsl:stylesheet>