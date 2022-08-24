## Introducción a *cores* y *entidades*
En Solr existen dos conceptos importantes a configurar, por un lado están los *cores* y por otro lado están las *entidades*. De acuerdo con la documentación de Solr<sup>1</sup> es posible segmentar Solr en múltiples *cores*, cada uno con su propia configuración e indexación; la recomendación es tener un *core* dedicado a una sola aplicación o fuente de datos y la ventaja de Solr es que pueden ser administrados desde una interfaz común. Por otro lado, también tenemos las *entidades* que pueden pensarse como elementos dentro de una aplicación, por ejemplo, una tabla dentro de una base de datos o un cruce de tablas. En este tutorial estaremos explicando cómo crear un *core*, cómo crear *entidades* dentro de ese *core* y cómo hacer consultas de información.

## Creación de *cores*
Para crear un *core*, se debe ejecutar la siguiente sentencia en la carpeta donde está instalado Solr:
```
bin/solr create -c nombre_core -p 8989
```
donde `nombre_core` es el nombre con el que identificaremos al *core* y `8989` es el puerto donde está instalado Solr.

Una vez creado el `core` vamos a poder visualizarlo dentro de la interfaz Web de la siguiente manera:
![image](https://user-images.githubusercontent.com/21049770/186309088-a7cf2ce8-5344-445a-a334-58a50012362e.png)

## Creación de *entidades*
Para este ejemplo, cada *entidad* será una tabla o una resultado de una consulta entre tablas de una misma fuente de datos, en este caso estaremos usando la fuente de datos de zendro que contiene información de sonozotz (audios e imágenes). El primer paso es agregar el controlador de importación de zendro en el archivo de configuración `solrconfig.xml` ubicado en la ruta `solr-8.11.2/server/solr/nombre_core/conf/` de la siguiente forma:
![image](https://user-images.githubusercontent.com/21049770/186311201-600c8fdd-ef20-44aa-b2a7-d7a0e588fa93.png)

En este caso hemos llamado al archivo de configuración de *entidades* `data-config.xml`, este documento debe ser creado en la misma carpeta con el mismo nombre para que pueda ser identificado por `solrconfig.xml`. Dentro de este documento se configuran las entidades que queremos consumir en nuestro *core*. En el siguiente ejemplo, estamos creando tres entidades, una con la información de la tabla *audios*, otra con la información de la tabla *imagenes* y por último una con el cruce de ambas tablas *join_images_audios*. El archivo de configuración se ve de la siguiente manera:

```xml
<dataConfig>
  <dataSource type="JdbcDataSource" name="zendro" driver="org.postgresql.Driver" url="jdbc:postgresql://localhost:5432/zendro_development" user="xxxxxx" password="xxxxxx" />
  <document name="nombre_documento">
    <entity name="imagenes" dataSource="zendro"  query="select 'imagenes' as base, &quot;Id_Ejemplar&quot;, &quot;Archivo&quot;, &quot;Familia&quot;, &quot;Genero&quot;, &quot;Especie&quot; from imagenes;">
      <field column="base" />
      <field column="Id_Ejemplar" />
      <field column="Archivo" />
      <field column="Familia" />
      <field column="Genero" />
      <field column="Especie" />
    </entity>
    <entity name="audios" dataSource="zendro" query="select 'audios' as base, &quot;Id_Ejemplar&quot;, &quot;Id_Grabacion&quot;, &quot;Familia&quot;, &quot;Genero&quot;, &quot;Especie&quot; from audios;">
      <field column="base" />
      <field column="Id_Ejemplar" />
      <field column="Id_Grabacion" />
      <field column="Familia" />
      <field column="Genero" />
      <field column="Especie" />
    </entity>
    <entity name="join_images_audios" dataSource="zendro" query="select imagenes.&quot;Id_Ejemplar&quot;, imagenes.&quot;Archivo&quot;, imagenes.&quot;Familia&quot;, imagenes.&quot;Genero&quot;, imagenes.&quot;Especie&quot;, audios.&quot;Id_Grabacion&quot;, audios.&quot;Familia&quot;, audios.&quot;Genero&quot;, audios.&quot;Especie&quot; FROM imagenes INNER JOIN audios ON imagenes.&quot;Id_Ejemplar&quot;=audios.&quot;Id_Ejemplar&quot;;">
      <field column="Id_Ejemplar" />
      <field column="Archivo" />
      <field column="Familia" />
      <field column="Genero" />
      <field column="Especie" />
      <field column="Id_Grabacion" />
    </entity>
  </document>
</dataConfig>
```




<sup>1</sup> https://solr.apache.org/guide/8_1/defining-core-properties.html
