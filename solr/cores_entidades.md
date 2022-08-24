## Introducción a *cores* y *entidades*
En Solr existen dos conceptos importantes a configurar, por un lado están los *cores* y por otro lado están las *entidades*. De acuerdo con la documentación de Solr<sup>1</sup> es posible segmentar Solr en múltiples *cores*, cada uno con su propia configuración e indexación; la recomendación es tener un *core* dedicado a una sola aplicación o fuente de datos y la ventaja de Solr es que pueden ser administrados desde una interfaz común. Por otro lado, también tenemos las *entidades* que pueden pensarse como elementos dentro de una aplicación, por ejemplo, una tabla dentro de una base de datos o un cruce de tablas. En este tutorial estaremos explicando cómo crear un *core*, cómo crear *entidades* dentro de ese *core* y cómo hacer consultas de información.

## Creación de *cores*
Para crear un *core*, se debe ejecutar la siguiente sentencia en la carpeta donde está instalado Solr:
```
bin/solr create -c nombre_core -p 8989
```
donde: `nombre_core` es el nombre con el que identificaremos al *core* y `8989` es el puerto donde está instalado Solr.

Una vez creado el `core` vamos a poder visualizarlo dentro de la interfaz Web de la siguiente manera:
![image](https://user-images.githubusercontent.com/21049770/186309088-a7cf2ce8-5344-445a-a334-58a50012362e.png)

## Creación de *entidades*
Para este ejemplo, cada *entidad* será una tabla o una resultado de una consulta entre tablas de una misma fuente de datos, en este caso estaremos usando la fuente de datos de zendro que contiene información de sonozotz (audios e imágenes). 

El primer paso es agregar el controlador de importación de zendro en el archivo de configuración `solrconfig.xml` ubicado en la ruta `solr-8.11.2/server/solr/nombre_core/conf/` de la siguiente forma:
![image](https://user-images.githubusercontent.com/21049770/186311201-600c8fdd-ef20-44aa-b2a7-d7a0e588fa93.png)

En este caso hemos llamado al archivo de configuración de *entidades* `data-config.xml`, este documento debe ser creado en la misma carpeta con el mismo nombre para que pueda ser identificado por `solrconfig.xml`. Dentro de este documento se configuran las entidades que queremos consumir en nuestro *core*. En el siguiente ejemplo, estamos creando dos entidades, una con la información de la tabla *imagenes* y otra con la información de la tabla *audios*. El archivo de configuración se ve de la siguiente manera:

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
  </document>
</dataConfig>
```
En este caso, podemos notar que:
* El *tag* de *\<dataConfig\>* indica el inicio y fin del contenido del documento.
* El *tag* de *\<dataSource\>* contiene la configuración de la fuente de datos de zendro.
* El *tag* de *\<entity\>* contiene la definición de las entidades usando la definición de una consulta *query* dentro de la tabla para definir las mismas.
* El *tag* de *\<field\>* contiene las columnas que queremos visualizar de las consultas.

Adicionalmente, necesitamos configurar el archivo `managed-schema` agregando los campos de interés, es aquí donde se indexan, se indica el tipo de dato que es y permite que el archivo `data-config.xml` entienda los campos que estamos trabajando. Se agregan los distintos agregando líneas de la siguiente manera:

![image](https://user-images.githubusercontent.com/21049770/186325080-e3170bbc-fc50-4824-be8d-919adadd4506.png)

Una vez finalizada la configuración se procede a reiniciar Solr en la carpeta donde está instalado el mismo, con la finalidad de poder visualizar los cambios:
```
bin/solr restart -p 8989
```

## Consulta de información y *endpoints*
Una vez cargadas las entidades, vamos a poder visualizarlas dentro de la interfaz de Solr y procedemos a importar la información dejando activa la opción *full-import*, seleccionamos la entidad de interés en este caso *imagenes* y damos click en *Execute* como se muestra a continuación:
![image](https://user-images.githubusercontent.com/21049770/186326143-8f638df3-297f-46c3-bfcc-084da74df2da.png)

Una vez ejecutado vamos a ver el siguiente mensaje que indica que la información fue indexada correctamente:
![image](https://user-images.githubusercontent.com/21049770/186326436-0f456bf6-e59c-474c-ba26-1099af82f271.png)
Para cargar la información de la tabla de *audios* repetimos los pasos anteriores seleccionando la entidad *audios*.

Ahora procedemos a hacer consultas a la información, si observamos cuidadosamente el documento `data-config.xml` existe un renglón con un campo denominado *base* `<field column="base" />`, este campo también es parte del *query* y se crea *al vuelo* dentro de la misma consulta `query="select 'imagenes' as base`. Este campo es clave para poder hacer las consultas e identificar las distintas tablas de interés.

En el siguiente ejemplo hacemos una consulta dentro de la interfaz de Solr a la tabla de *imagenes* donde resultan 2,824 documentos y el endpoint para consumir la información es el *http* que se encuentra en la parte superior:
![image](https://user-images.githubusercontent.com/21049770/186327435-2a7b19f9-317d-400d-b4a8-e37796896f32.png)

Por último, en este ejemplo hacemos una consulta a la tabla *audios* y filtramos para quedarnos únicamente con los campos *Especie* y *Id_Grabacion*
![image](https://user-images.githubusercontent.com/21049770/186327825-1d0a8316-f0f8-4c73-ade0-dcf699c03e96.png)


<sup>1</sup> https://solr.apache.org/guide/8_1/defining-core-properties.html
