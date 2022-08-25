# MANUAL CONFIGURACIÓN SOLR

Supongamos que queremos hacer una búsqueda en Solr que nos devuelva los siguientes campos de la tabla images:

```
url
id
date_captured
latitude
longitude
monitoring_type
anp
```

Además, supongamos que queremos filtrar por el campo `label` que se encuentra en la tabla de `annotations`. 

Para este proceso, vamos a crear un nuevo core desde la terminal:

## 1.	Primero nos conectaremos a Alfresco con ssh

Para hacerlo, debemos de estar ubicados en la carpeta en la que tenemos nuestra llave (el archivo .cer).
Una vez que nos encontremos ahí, nos conectaremos con el siguiente comando:

```
ssh -i alfrescoregon.cer ec2-user@44.234.42.238 -o ServerAliveInterval=60
```

## 2.	Posterior, como la tabla de `images` se encuentra en la base de Zendro, nos iremos a dicha base con el siguiente comando:

```
psql postgresql://alfresco:alfresco@localhost:5432/zendro_development
```

## 3.	Crearemos el query que deseamos obtener desde solr. En este caso haremos un left join:

```
SELECT a.label, i.url, i.id, i.date_captured, i.latitude, i.longitude, i.monitoring_type, i.anp FROM IMAGES i  LEFT JOIN  ANNOTATIONS a ON a.image_id=i.id
```

## 4.	Una vez que estamos seguros que el query que necesitamos sea ese, vamos a proceder a hacer un core para hacer nuestra indexación y posterior poder realizar nuestras búsquedas.

## 5.	Para esto, debemos de salirnos del psql y dirigirnos a solr. Posterior, con el siguiente comando iniciaremos el nuevo core:

```
bin/solr create_core [-c name] [-d confdir] [-p port]
bin/solr create_core -c core_tutorial -p 8989
```

(Podemos especificar un nombre, un puerto y una configuración, sin embargo, solo indicaremos el nombre y puerto ya que la configuración la realizaremos en este tutorial).

En el siguiente link hay una referencia que puede ser de ayuda para crear el core:

[solr-create-core](https://factorpad.com/tech/solr/reference/solr-create-core.html)

## 6.	Notamos que se crearon los siguientes archivos en nuestra carpeta de configuración:

```
managed-schema
protwords.txt
solrconfig.xml
stopwords.txt
synonyms.txt
```

## 7.	Vamos a modificar los archivos de `managed-schema` y `solrconfig.xml` además de crear una nuevo archivo de configuración de los datos. 

Yo le llamaré `data-config.xml`, sin embargo, le puedes otorgar el nombre que desees, siempre y cuando sea consistente en el archivo de `solrconfig.xml`.

## 8.	MANAGED-SCHEMA: 

En nuestro `managed-schema` vamos a declarar los campos que se utilizarán. Indicando el tipo de campo que existe. Muy importante que estos *field names* sean los mismos que se utilizarán en los *field columns* del archivo `data-config`.

```
    <field name="date_captured"  type="string" indexed="true" stored="true"/>
    <field name="url"  type="string" indexed="true" stored="true"/>
    <field name="latitude"  type="pint" indexed="true" stored="true"/>
    <field name="longitude"  type="pint" indexed="true" stored="true"/>
    <field name="monitoring_type"  type="string" indexed="true" stored="true"/>
    <field name="anp"  type="string" indexed="true" stored="true"/>
    <field name="label"  type="string" indexed="true" stored="true"/>
```

## 9.	SOLRCONFIG.XML:  

Debes de agregar las siguientes líneas de configuración que indicarán a Solr que registre el controlador de importación de datos. El único parámetro que se requiere es la `config` que especifica la ubicación donde se encuentra el archivo de configuración del controlador de importación de datos. Este archivo contiene detalles sobre cómo conectarse a la fuente de datos para saber cómo obtener los datos y cómo procesarlos para generar documentos Solr para indexarlos (en nuestro caso se trata del `data-config.xml`).

```
  	<lib dir="${solr.install.dir:../../../..}/contrib/dataimporthandler/lib" regex=".*\.jar"/>
  	<lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-dataimporthandler-.*\.jar"/>
  	<requestHandler name="/dataimport" class="org.apache.solr.handler.dataimport.DataImportHandler">
    	  <lst name="defaults">
      	    <str name="config">data-config.xml</str>
    	  </lst>
  	</requestHandler>

```

## 10. DATA-CONFIG.XML: 

Va a estar contenido por un *data source*, que es la conexión que se hará con nuestra base de datos de alfresco. Debemos de indicar `url, user y passsword`. Crearemos un nuevo documento con los campos que vamos a obtener de nuestro query. Debemos de indicar todos los campos. En este caso, como necesitamos `id, date, url, latitude, longitude, monitoring_type, anp y label`, vamos a indicar esos campos, tal y como se muestra en el siguiente ejemplo: 

```
<dataConfig>

  <dataSource type="JdbcDataSource" name="snmb" driver="org.postgresql.Driver" url="jdbc:postgresql://localhost:5432/snmb_development" user="alfresco" password="alfresco" />
  <dataSource type="JdbcDataSource" name="zendro" driver="org.postgresql.Driver" url="jdbc:postgresql://localhost:5432/zendro_development" user="alfresco" password="alfresco" />
  <document name="new_document">
     <entity name="images_1" dataSource="zendro" query="SELECT a.label, i.url, i.id, i.date_captured, i.latitude, i.longitude, i.monitoring_type, i.anp FROM IMAGES i  LEFT JOIN  ANNOTATIONS a ON a.image_id=i.id;">
    <field column="id" name="id"/>
    <field column="date_captured" name="date_captured"/>
    <field column="url" name="url"/>
    <field column="latitude" name="latitude"/>
    <field column="longitude" name="longitude"/>
    <field column="monitoring_type" name="monitoring_type"/>
    <field column="anp" name="anp"/>
    <field column="label" name="label"/>
    </entity> 
  </document>
</dataConfig>
```

## 11. Una vez que se hayan hecho las configuraciones necesarias, vamos a apagar Solr y reiniciarlo ejecutando los siguientes comandos:

```
bin/solr stop -all
bin/solr start -p 8989
```

Es muy importante hacer estos pasos ya que de esa forma solr se reinicia y lee las configuraciones que previamente se hicieron.

## 12. 

Si todo está bien, el `SolrCore Initialization Failures` de la página de inicio de Solr no indicará ninguna alerta. En caso de que haya algún error, este se indicará en la página de inicio. Los errores que nos encontramos fueron que algún campo en el `managed-schema` se encontraba repetido o que no se encontraba. Hay que tener en cuenta que el `managed-schema` contiene un campo `id` por *default*, por lo cual, habrá que tener cuidado de no repetir dicho campo.

# MANUAL IMPORTACIÓN DE DATOS

Nos vamos a la pestaña de Dataimport dentro de nuestro core

(imagen)

En la sección de `Entity`, seleccionamos el *entity* del cual queremos hacer nuestra importación de datos. En este caso,  en el `data-config.xml` lo nombramos `images_1`, seleccionamos `Auto-refresh Status` para ver el status automáticamente y  presionamos el botón de `execute`.

Una vez que tenemos los datos, podemos hacer nuestras búsquedas en la pestaña de `Query`.

# ¿Cómo hacer nuestros queries?

En la pestaña `query` podemos hacer filtros extras o búsquedas de nuestros entities previamente importados.

En la sección de `query: q`, podemos indicar `*:*` para seleccionar todo. Podemos hacer filtrados por el campo que deseemos, también. Por ejemplo: `label:Homo sapiens`.

En la sección de `sort` podemos reacomodar nuestra búsqueda por algún campo de interés. Por ejemplo: `date_captured asc` o `date_captured desc`.

En la sección de `start, rows` podemos hacer una selección del número de elementos que utilizaremos.

En la sección de `fl` podemos hacer una subselección de los campos que necesitamos para nuestro *query*. Por ejemplo, si solo necesitamos el `url` y el `id`, indicamos: `url, id`.

(imagen)

En caso de necesitar eliminar los datos de nuestro core, seleccionamos la sección de `Documents`, document type: `xml`, pegamos el siguiente documento y seleccionamos `submit document`:

```
<delete><query>*:*</query></delete>
```








