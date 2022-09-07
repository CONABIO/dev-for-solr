```python
pip install simplejson
```

    Requirement already satisfied: simplejson in /Users/rodrigojuarez/opt/anaconda3/lib/python3.8/site-packages (3.17.6)
    Note: you may need to restart the kernel to use updated packages.


### Solr

Es posible hacer consultas a Solr mediante HTTP a partir de Python sin requerir la instalación de un cliente adicional.

Para construir un query es necesario especificar: 

* Request-Handler: para definir si queremos hacer una consulta o una actualización de documentos 

* q: query string o parámetro q. Syntax: name:canon  | field:value format. Los resultados aparecen por relevancia

* fq: filtrado del query. 

* sort: definimos la variable y si el órden es asc o desc

* start, rows: definimos el número de resultados mostrados por página

* fl: aquí se define qué campos regresa la búsqueda 

* df: campo de búsqueda por default  

* wt: definimos el formato de la respuesta, por default json. Puede ser json, xml, python, ruby, php o csv 

Hay atributos de búsqueda más avanzados como el faceting y hl highlighting.



```python
import urllib
import simplejson
import pprint
import sys

from urllib.request import urlopen
```

Definimos el url y la colección de documents, después el query a realizar. 

#### Filtrar archivos por nodo


```python
host       = "alfresco.sipecam.conabio.gob.mx"
port       = "8983" 
collection = "alfresco" #Nombre del core
qt         = "select"
url        = 'http://' + host + ':' + port + '/solr/' + collection + '/' + qt + '?' #creación de url
q          = "q=sipecam_CumulusName:95"
fl         = ""
fl         = fl + ",[cached]&indent=on"
wt         = "wt=json"
group      = "group=true"
groupf     = "group.field=TYPE"
params     = [fl, q, wt, group, groupf] 
p          = "&".join(params)
```


```python
html = urlopen(url+p)
print(html)
connection = html
if wt == "wt=json":
  response   = simplejson.load(connection) 
else:
  response   = eval(connection.read())
```

    <http.client.HTTPResponse object at 0x7fc1a8616e20>


Número de resultados de la búsqueda.


```python
print(response['grouped']['TYPE']['groups'])
```

    [{'groupValue': '{sipecam}image', 'doclist': {'numFound': 27101, 'start': 0, 'docs': [{}]}}, {'groupValue': '{sipecam}audio', 'doclist': {'numFound': 20528, 'start': 0, 'docs': [{}]}}, {'groupValue': '{sipecam}video', 'doclist': {'numFound': 16761, 'start': 0, 'docs': [{}]}}]


#### Filtrar archivos por cúmulo con tipo de ecosistema


```python
q          = "q=sipecam_CumulusName:95 AND sipecam_EcosystemsName:Bosques templados"
fl         = "fl=sipecam_EcosystemsName,id,DBID"
fl         = fl + ",[cached]&indent=on"
wt         = "wt=json"
params     = [fl, q, wt] 
p          = "&".join(params)
p          = p.replace(' ', '%20')
```


```python
html = urlopen(url+p)
print(html)
connection = html
if wt == "wt=json":
  response   = simplejson.load(connection) 
else:
  response   = eval(connection.read())
```

    <http.client.HTTPResponse object at 0x7fc1a6abc0a0>



```python
print("Number of hits: " + str(response['response']['numFound']))
```

    Number of hits: 64390



```python
pprint.pprint(response['response']['docs'])
```

    [{'DBID': 509633,
      'id': '_DEFAULT_!800000000007c6c1',
      'sipecam_EcosystemsName': 'Bosques templados'},
     {'DBID': 505196,
      'id': '_DEFAULT_!800000000007b56c',
      'sipecam_EcosystemsName': 'Bosques templados'},
     {'DBID': 495155,
      'id': '_DEFAULT_!8000000000078e33',
      'sipecam_EcosystemsName': 'Bosques templados'},
     {'DBID': 502202,
      'id': '_DEFAULT_!800000000007a9ba',
      'sipecam_EcosystemsName': 'Bosques templados'},
     {'DBID': 505526,
      'id': '_DEFAULT_!800000000007b6b6',
      'sipecam_EcosystemsName': 'Bosques templados'},
     {'DBID': 503333,
      'id': '_DEFAULT_!800000000007ae25',
      'sipecam_EcosystemsName': 'Bosques templados'},
     {'DBID': 498224,
      'id': '_DEFAULT_!8000000000079a30',
      'sipecam_EcosystemsName': 'Bosques templados'},
     {'DBID': 493853,
      'id': '_DEFAULT_!800000000007891d',
      'sipecam_EcosystemsName': 'Bosques templados'},
     {'DBID': 505580,
      'id': '_DEFAULT_!800000000007b6ec',
      'sipecam_EcosystemsName': 'Bosques templados'},
     {'DBID': 498245,
      'id': '_DEFAULT_!8000000000079a45',
      'sipecam_EcosystemsName': 'Bosques templados'}]


## Para pipelines de audio y video

### Producto: Soundscapes

#### Audio: Filtrar archivos por cúmulo y sample rate (de a 48,000 Hz). Para los cúmulos 92, 95, 32, y 13


```python
host       = "alfresco.sipecam.conabio.gob.mx"
port       = "8983" 
collection = "alfresco" #Nombre del core
qt         = "select"
url        = 'http://' + host + ':' + port + '/solr/' + collection + '/' + qt + '?' #creación de url
q          = "q=TYPE:{sipecam}audio AND sipecam_SampleRate:48000 AND sipecam_CumulusName:92"
fl         = "fl=sipecam_CumulusName,sipecam_NodeCategoryIntegrity,sipecam_NomenclatureNode,sipecam_SerialNumber,sipecam_DateDeployment,DBID,id"
fl         = fl + ",[cached]&indent=on"
wt         = "wt=json"
params     = [fl, q, wt] 
p          = "&".join(params)
p          = p.replace(' ', '%20')
```


```python
html = urlopen(url+p)
print(html)
connection = html
if wt == "wt=json":
  response   = simplejson.load(connection) 
else:
  response   = eval(connection.read())
```

    <http.client.HTTPResponse object at 0x7fc1a8d6adc0>



```python
print("Number of hits: " + str(response['response']['numFound']))
```

    Number of hits: 34670



```python
pprint.pprint(response['response']['docs'])
```

    [{'DBID': 231087,
      'id': '_DEFAULT_!80000000000386af',
      'sipecam_CumulusName': '92',
      'sipecam_DateDeployment': '2021-07-28T00:00:00Z',
      'sipecam_NodeCategoryIntegrity': 'Integro',
      'sipecam_NomenclatureNode': '3_92_1_1338',
      'sipecam_SerialNumber': '2453AC025DAEB645'},
     {'DBID': 239606,
      'id': '_DEFAULT_!800000000003a7f6',
      'sipecam_CumulusName': '92',
      'sipecam_DateDeployment': '2021-07-28T00:00:00Z',
      'sipecam_NodeCategoryIntegrity': 'Integro',
      'sipecam_NomenclatureNode': '3_92_1_1338',
      'sipecam_SerialNumber': '2411E5085944299F'},
     {'DBID': 237806,
      'id': '_DEFAULT_!800000000003a0ee',
      'sipecam_CumulusName': '92',
      'sipecam_DateDeployment': '2021-07-28T00:00:00Z',
      'sipecam_NodeCategoryIntegrity': 'Integro',
      'sipecam_NomenclatureNode': '3_92_1_1338',
      'sipecam_SerialNumber': '2411E5085944299F'},
     {'DBID': 239705,
      'id': '_DEFAULT_!800000000003a859',
      'sipecam_CumulusName': '92',
      'sipecam_DateDeployment': '2021-07-28T00:00:00Z',
      'sipecam_NodeCategoryIntegrity': 'Integro',
      'sipecam_NomenclatureNode': '3_92_1_1338',
      'sipecam_SerialNumber': '2411E5085944299F'},
     {'DBID': 226740,
      'id': '_DEFAULT_!80000000000375b4',
      'sipecam_CumulusName': '92',
      'sipecam_DateDeployment': '2021-07-28T00:00:00Z',
      'sipecam_NodeCategoryIntegrity': 'Integro',
      'sipecam_NomenclatureNode': '3_92_1_1338',
      'sipecam_SerialNumber': '2453AC025DAEB645'},
     {'DBID': 237938,
      'id': '_DEFAULT_!800000000003a172',
      'sipecam_CumulusName': '92',
      'sipecam_DateDeployment': '2021-07-28T00:00:00Z',
      'sipecam_NodeCategoryIntegrity': 'Integro',
      'sipecam_NomenclatureNode': '3_92_1_1338',
      'sipecam_SerialNumber': '2411E5085944299F'},
     {'DBID': 243341,
      'id': '_DEFAULT_!800000000003b68d',
      'sipecam_CumulusName': '92',
      'sipecam_DateDeployment': '2021-07-28T00:00:00Z',
      'sipecam_NodeCategoryIntegrity': 'Integro',
      'sipecam_NomenclatureNode': '3_92_1_1338',
      'sipecam_SerialNumber': '2411E5085944299F'},
     {'DBID': 231306,
      'id': '_DEFAULT_!800000000003878a',
      'sipecam_CumulusName': '92',
      'sipecam_DateDeployment': '2021-07-28T00:00:00Z',
      'sipecam_NodeCategoryIntegrity': 'Integro',
      'sipecam_NomenclatureNode': '3_92_1_1338',
      'sipecam_SerialNumber': '2453AC025DAEB645'},
     {'DBID': 243356,
      'id': '_DEFAULT_!800000000003b69c',
      'sipecam_CumulusName': '92',
      'sipecam_DateDeployment': '2021-07-28T00:00:00Z',
      'sipecam_NodeCategoryIntegrity': 'Integro',
      'sipecam_NomenclatureNode': '3_92_1_1338',
      'sipecam_SerialNumber': '2411E5085944299F'},
     {'DBID': 229215,
      'id': '_DEFAULT_!8000000000037f5f',
      'sipecam_CumulusName': '92',
      'sipecam_DateDeployment': '2021-07-28T00:00:00Z',
      'sipecam_NodeCategoryIntegrity': 'Integro',
      'sipecam_NomenclatureNode': '3_92_1_1338',
      'sipecam_SerialNumber': '2453AC025DAEB645'}]


### Detección y classificación de Murcielagos

#### Filtrar archivos por cúmulo y sample rate (mayor a 100,000 Hz). Para los cúmulos 92, 95, 32, y 13


```python
q          = "q=sipecam_CumulusName:13 OR sipecam_CumulusName:32 OR sipecam_CumulusName:92 OR sipecam_CumulusName:95 AND TYPE:{sipecam}audio AND audio_sampleRate: [0 TO 48000]"
fl         = "fl=PATH,sipecam*"
fl         = fl + ",[cached]&indent=on"
wt         = "wt=json"
params     = [fl, q, wt] 
p          = "&".join(params)
p          = p.replace(' ', '%20')
```


```python
html = urlopen(url+p)
print(html)
connection = html
if wt == "wt=json":
  response   = simplejson.load(connection) 
else:
  response   = eval(connection.read())
```

    <http.client.HTTPResponse object at 0x7fc1a8e41f70>



```python
print("Number of hits: " + str(response['response']['numFound']))
```

    Number of hits: 154861



```python
pprint.pprint(response['response']['docs'])
```

    [{'PATH': ['/{http://www.alfresco.org/model/application/1.0}company_home/{http://www.alfresco.org/model/site/1.0}sites/{http://www.alfresco.org/model/content/1.0}sipecam/{http://www.alfresco.org/model/content/1.0}documentLibrary/{http://www.alfresco.org/model/content/1.0}_x0039_5/{http://www.alfresco.org/model/content/1.0}_x0031__95_0_1348/{http://www.alfresco.org/model/content/1.0}_x0032_48C7D075B1FB916/{http://www.alfresco.org/model/content/1.0}_x0032_021-08-04/{http://www.alfresco.org/model/content/1.0}audios/{http://www.alfresco.org/model/content/1.0}Audible/{http://www.alfresco.org/model/content/1.0}_x0031_2f920cd8625390b19908062274f9876.WAV'],
      'id': '_DEFAULT_!800000000004ed14',
      'sipecam:Comment': ['Recorded at 00:20:00 06/09/2021 (UTC-5) by AudioMoth '
                          '248C7D075B1FB916 at medium gain setting while battery '
                          'state was 3.9V and temperature was 20.1C.'],
      'sipecam_AvgBytesPerSec': 96000.0,
      'sipecam_Battery': '3.9V',
      'sipecam_BitRate': '768.0 Kbit/sec',
      'sipecam_BitsPerSample': 16.0,
      'sipecam_CentroidCumulusLatitude': 31.22829,
      'sipecam_CentroidCumulusLongitude': -108.85782,
      'sipecam_CumulusName': '95',
      'sipecam_DateDeployment': '2021-08-04T00:00:00Z',
      'sipecam_DateDeployment_unit_of_time_day_of_month': 4,
      'sipecam_DateDeployment_unit_of_time_day_of_week': 3,
      'sipecam_DateDeployment_unit_of_time_day_of_year': 216,
      'sipecam_DateDeployment_unit_of_time_month': 8,
      'sipecam_DateDeployment_unit_of_time_quarter': 3,
      'sipecam_DateDeployment_unit_of_time_year': 2021,
      'sipecam_DateTimeOriginal': '2021-09-06T05:20:00Z',
      'sipecam_DateTimeOriginal_unit_of_time_day_of_month': 6,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_week': 1,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_year': 249,
      'sipecam_DateTimeOriginal_unit_of_time_hour': 5,
      'sipecam_DateTimeOriginal_unit_of_time_minute': 20,
      'sipecam_DateTimeOriginal_unit_of_time_month': 9,
      'sipecam_DateTimeOriginal_unit_of_time_quarter': 3,
      'sipecam_DateTimeOriginal_unit_of_time_second': 0,
      'sipecam_DateTimeOriginal_unit_of_time_year': 2021,
      'sipecam_Duration': 60.005085,
      'sipecam_EcosystemsName': 'Bosques templados',
      'sipecam_Encoding': 'Microsoft PCM',
      'sipecam_FileSize': 5767168,
      'sipecam_Gain': 'medium',
      'sipecam_Latitude': 31.25407,
      'sipecam_Longitude': -108.95226,
      'sipecam_NodeCategoryIntegrity': 'Degradado',
      'sipecam_NomenclatureNode': '1_95_0_1348',
      'sipecam_NumChannels': 1,
      'sipecam_SampleRate': 48000.0,
      'sipecam_SerialNumber': '248C7D075B1FB916',
      'sipecam_Timeexp': 1.0,
      'sipecam_Timezone': 'UTC'},
     {'PATH': ['/{http://www.alfresco.org/model/application/1.0}company_home/{http://www.alfresco.org/model/site/1.0}sites/{http://www.alfresco.org/model/content/1.0}sipecam/{http://www.alfresco.org/model/content/1.0}documentLibrary/{http://www.alfresco.org/model/content/1.0}_x0039_5/{http://www.alfresco.org/model/content/1.0}_x0031__95_0_1348/{http://www.alfresco.org/model/content/1.0}_x0032_48C7D075B1FB916/{http://www.alfresco.org/model/content/1.0}_x0032_021-08-04/{http://www.alfresco.org/model/content/1.0}audios/{http://www.alfresco.org/model/content/1.0}Audible/{http://www.alfresco.org/model/content/1.0}_x0033_20e6721fead7e5e6bdf654bf815aac6.WAV'],
      'id': '_DEFAULT_!8000000000050c4f',
      'sipecam:Comment': ['Recorded at 02:10:00 28/08/2021 (UTC-5) by AudioMoth '
                          '248C7D075B1FB916 at medium gain setting while battery '
                          'state was 4.2V and temperature was 22.8C.'],
      'sipecam_AvgBytesPerSec': 96000.0,
      'sipecam_Battery': '4.2V',
      'sipecam_BitRate': '768.0 Kbit/sec',
      'sipecam_BitsPerSample': 16.0,
      'sipecam_CentroidCumulusLatitude': 31.22829,
      'sipecam_CentroidCumulusLongitude': -108.85782,
      'sipecam_CumulusName': '95',
      'sipecam_DateDeployment': '2021-08-04T00:00:00Z',
      'sipecam_DateDeployment_unit_of_time_day_of_month': 4,
      'sipecam_DateDeployment_unit_of_time_day_of_week': 3,
      'sipecam_DateDeployment_unit_of_time_day_of_year': 216,
      'sipecam_DateDeployment_unit_of_time_month': 8,
      'sipecam_DateDeployment_unit_of_time_quarter': 3,
      'sipecam_DateDeployment_unit_of_time_year': 2021,
      'sipecam_DateTimeOriginal': '2021-08-28T07:10:00Z',
      'sipecam_DateTimeOriginal_unit_of_time_day_of_month': 28,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_week': 6,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_year': 240,
      'sipecam_DateTimeOriginal_unit_of_time_hour': 7,
      'sipecam_DateTimeOriginal_unit_of_time_minute': 10,
      'sipecam_DateTimeOriginal_unit_of_time_month': 8,
      'sipecam_DateTimeOriginal_unit_of_time_quarter': 3,
      'sipecam_DateTimeOriginal_unit_of_time_second': 0,
      'sipecam_DateTimeOriginal_unit_of_time_year': 2021,
      'sipecam_Duration': 60.005085,
      'sipecam_EcosystemsName': 'Bosques templados',
      'sipecam_Encoding': 'Microsoft PCM',
      'sipecam_FileSize': 5767168,
      'sipecam_Gain': 'medium',
      'sipecam_Latitude': 31.25407,
      'sipecam_Longitude': -108.95226,
      'sipecam_NodeCategoryIntegrity': 'Degradado',
      'sipecam_NomenclatureNode': '1_95_0_1348',
      'sipecam_NumChannels': 1,
      'sipecam_SampleRate': 48000.0,
      'sipecam_SerialNumber': '248C7D075B1FB916',
      'sipecam_Timeexp': 1.0,
      'sipecam_Timezone': 'UTC'},
     {'PATH': ['/{http://www.alfresco.org/model/application/1.0}company_home/{http://www.alfresco.org/model/site/1.0}sites/{http://www.alfresco.org/model/content/1.0}sipecam/{http://www.alfresco.org/model/content/1.0}documentLibrary/{http://www.alfresco.org/model/content/1.0}_x0039_5/{http://www.alfresco.org/model/content/1.0}_x0031__95_0_1348/{http://www.alfresco.org/model/content/1.0}_x0032_48C7D075B1FB916/{http://www.alfresco.org/model/content/1.0}_x0032_021-08-04/{http://www.alfresco.org/model/content/1.0}audios/{http://www.alfresco.org/model/content/1.0}Audible/{http://www.alfresco.org/model/content/1.0}_x0030_0729fb2e4e8a7b59d9ba253b7f14a03.WAV'],
      'id': '_DEFAULT_!800000000004d15d',
      'sipecam:Comment': ['Recorded at 00:50:00 31/08/2021 (UTC-5) by AudioMoth '
                          '248C7D075B1FB916 at medium gain setting while battery '
                          'state was 4.1V and temperature was 23.3C.'],
      'sipecam_AvgBytesPerSec': 96000.0,
      'sipecam_Battery': '4.1V',
      'sipecam_BitRate': '768.0 Kbit/sec',
      'sipecam_BitsPerSample': 16.0,
      'sipecam_CentroidCumulusLatitude': 31.22829,
      'sipecam_CentroidCumulusLongitude': -108.85782,
      'sipecam_CumulusName': '95',
      'sipecam_DateDeployment': '2021-08-04T00:00:00Z',
      'sipecam_DateDeployment_unit_of_time_day_of_month': 4,
      'sipecam_DateDeployment_unit_of_time_day_of_week': 3,
      'sipecam_DateDeployment_unit_of_time_day_of_year': 216,
      'sipecam_DateDeployment_unit_of_time_month': 8,
      'sipecam_DateDeployment_unit_of_time_quarter': 3,
      'sipecam_DateDeployment_unit_of_time_year': 2021,
      'sipecam_DateTimeOriginal': '2021-08-31T05:50:00Z',
      'sipecam_DateTimeOriginal_unit_of_time_day_of_month': 31,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_week': 2,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_year': 243,
      'sipecam_DateTimeOriginal_unit_of_time_hour': 5,
      'sipecam_DateTimeOriginal_unit_of_time_minute': 50,
      'sipecam_DateTimeOriginal_unit_of_time_month': 8,
      'sipecam_DateTimeOriginal_unit_of_time_quarter': 3,
      'sipecam_DateTimeOriginal_unit_of_time_second': 0,
      'sipecam_DateTimeOriginal_unit_of_time_year': 2021,
      'sipecam_Duration': 60.005085,
      'sipecam_EcosystemsName': 'Bosques templados',
      'sipecam_Encoding': 'Microsoft PCM',
      'sipecam_FileSize': 5767168,
      'sipecam_Gain': 'medium',
      'sipecam_Latitude': 31.25407,
      'sipecam_Longitude': -108.95226,
      'sipecam_NodeCategoryIntegrity': 'Degradado',
      'sipecam_NomenclatureNode': '1_95_0_1348',
      'sipecam_NumChannels': 1,
      'sipecam_SampleRate': 48000.0,
      'sipecam_SerialNumber': '248C7D075B1FB916',
      'sipecam_Timeexp': 1.0,
      'sipecam_Timezone': 'UTC'},
     {'PATH': ['/{http://www.alfresco.org/model/application/1.0}company_home/{http://www.alfresco.org/model/site/1.0}sites/{http://www.alfresco.org/model/content/1.0}sipecam/{http://www.alfresco.org/model/content/1.0}documentLibrary/{http://www.alfresco.org/model/content/1.0}_x0039_5/{http://www.alfresco.org/model/content/1.0}_x0031__95_0_1348/{http://www.alfresco.org/model/content/1.0}_x0032_48C7D075B1FB916/{http://www.alfresco.org/model/content/1.0}_x0032_021-08-04/{http://www.alfresco.org/model/content/1.0}audios/{http://www.alfresco.org/model/content/1.0}Audible/{http://www.alfresco.org/model/content/1.0}_x0033_4cc27df0217fbd4995ac4ac3d3e1917.WAV'],
      'id': '_DEFAULT_!800000000004dab1',
      'sipecam:Comment': ['Recorded at 18:40:00 29/08/2021 (UTC-5) by AudioMoth '
                          '248C7D075B1FB916 at medium gain setting while battery '
                          'state was 4.2V and temperature was 37.2C.'],
      'sipecam_AvgBytesPerSec': 96000.0,
      'sipecam_Battery': '4.2V',
      'sipecam_BitRate': '768.0 Kbit/sec',
      'sipecam_BitsPerSample': 16.0,
      'sipecam_CentroidCumulusLatitude': 31.22829,
      'sipecam_CentroidCumulusLongitude': -108.85782,
      'sipecam_CumulusName': '95',
      'sipecam_DateDeployment': '2021-08-04T00:00:00Z',
      'sipecam_DateDeployment_unit_of_time_day_of_month': 4,
      'sipecam_DateDeployment_unit_of_time_day_of_week': 3,
      'sipecam_DateDeployment_unit_of_time_day_of_year': 216,
      'sipecam_DateDeployment_unit_of_time_month': 8,
      'sipecam_DateDeployment_unit_of_time_quarter': 3,
      'sipecam_DateDeployment_unit_of_time_year': 2021,
      'sipecam_DateTimeOriginal': '2021-08-29T23:40:00Z',
      'sipecam_DateTimeOriginal_unit_of_time_day_of_month': 29,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_week': 7,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_year': 241,
      'sipecam_DateTimeOriginal_unit_of_time_hour': 23,
      'sipecam_DateTimeOriginal_unit_of_time_minute': 40,
      'sipecam_DateTimeOriginal_unit_of_time_month': 8,
      'sipecam_DateTimeOriginal_unit_of_time_quarter': 3,
      'sipecam_DateTimeOriginal_unit_of_time_second': 0,
      'sipecam_DateTimeOriginal_unit_of_time_year': 2021,
      'sipecam_Duration': 60.005085,
      'sipecam_EcosystemsName': 'Bosques templados',
      'sipecam_Encoding': 'Microsoft PCM',
      'sipecam_FileSize': 5767168,
      'sipecam_Gain': 'medium',
      'sipecam_Latitude': 31.25407,
      'sipecam_Longitude': -108.95226,
      'sipecam_NodeCategoryIntegrity': 'Degradado',
      'sipecam_NomenclatureNode': '1_95_0_1348',
      'sipecam_NumChannels': 1,
      'sipecam_SampleRate': 48000.0,
      'sipecam_SerialNumber': '248C7D075B1FB916',
      'sipecam_Timeexp': 1.0,
      'sipecam_Timezone': 'UTC'},
     {'PATH': ['/{http://www.alfresco.org/model/application/1.0}company_home/{http://www.alfresco.org/model/site/1.0}sites/{http://www.alfresco.org/model/content/1.0}sipecam/{http://www.alfresco.org/model/content/1.0}documentLibrary/{http://www.alfresco.org/model/content/1.0}_x0039_5/{http://www.alfresco.org/model/content/1.0}_x0031__95_0_1348/{http://www.alfresco.org/model/content/1.0}_x0032_48C7D075B1FB916/{http://www.alfresco.org/model/content/1.0}_x0032_021-08-04/{http://www.alfresco.org/model/content/1.0}audios/{http://www.alfresco.org/model/content/1.0}Audible/{http://www.alfresco.org/model/content/1.0}_x0032_a36409523c982ea1d53501e544fa56c.WAV'],
      'id': '_DEFAULT_!800000000004d5ef',
      'sipecam:Comment': ['Recorded at 00:50:00 22/08/2021 (UTC-5) by AudioMoth '
                          '248C7D075B1FB916 at medium gain setting while battery '
                          'state was 4.3V and temperature was 22.9C.'],
      'sipecam_AvgBytesPerSec': 96000.0,
      'sipecam_Battery': '4.3V',
      'sipecam_BitRate': '768.0 Kbit/sec',
      'sipecam_BitsPerSample': 16.0,
      'sipecam_CentroidCumulusLatitude': 31.22829,
      'sipecam_CentroidCumulusLongitude': -108.85782,
      'sipecam_CumulusName': '95',
      'sipecam_DateDeployment': '2021-08-04T00:00:00Z',
      'sipecam_DateDeployment_unit_of_time_day_of_month': 4,
      'sipecam_DateDeployment_unit_of_time_day_of_week': 3,
      'sipecam_DateDeployment_unit_of_time_day_of_year': 216,
      'sipecam_DateDeployment_unit_of_time_month': 8,
      'sipecam_DateDeployment_unit_of_time_quarter': 3,
      'sipecam_DateDeployment_unit_of_time_year': 2021,
      'sipecam_DateTimeOriginal': '2021-08-22T05:50:00Z',
      'sipecam_DateTimeOriginal_unit_of_time_day_of_month': 22,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_week': 7,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_year': 234,
      'sipecam_DateTimeOriginal_unit_of_time_hour': 5,
      'sipecam_DateTimeOriginal_unit_of_time_minute': 50,
      'sipecam_DateTimeOriginal_unit_of_time_month': 8,
      'sipecam_DateTimeOriginal_unit_of_time_quarter': 3,
      'sipecam_DateTimeOriginal_unit_of_time_second': 0,
      'sipecam_DateTimeOriginal_unit_of_time_year': 2021,
      'sipecam_Duration': 60.005085,
      'sipecam_EcosystemsName': 'Bosques templados',
      'sipecam_Encoding': 'Microsoft PCM',
      'sipecam_FileSize': 5767168,
      'sipecam_Gain': 'medium',
      'sipecam_Latitude': 31.25407,
      'sipecam_Longitude': -108.95226,
      'sipecam_NodeCategoryIntegrity': 'Degradado',
      'sipecam_NomenclatureNode': '1_95_0_1348',
      'sipecam_NumChannels': 1,
      'sipecam_SampleRate': 48000.0,
      'sipecam_SerialNumber': '248C7D075B1FB916',
      'sipecam_Timeexp': 1.0,
      'sipecam_Timezone': 'UTC'},
     {'PATH': ['/{http://www.alfresco.org/model/application/1.0}company_home/{http://www.alfresco.org/model/site/1.0}sites/{http://www.alfresco.org/model/content/1.0}sipecam/{http://www.alfresco.org/model/content/1.0}documentLibrary/{http://www.alfresco.org/model/content/1.0}_x0039_5/{http://www.alfresco.org/model/content/1.0}_x0031__95_0_1348/{http://www.alfresco.org/model/content/1.0}_x0032_48C7D075B1FB916/{http://www.alfresco.org/model/content/1.0}_x0032_021-08-04/{http://www.alfresco.org/model/content/1.0}audios/{http://www.alfresco.org/model/content/1.0}Audible/{http://www.alfresco.org/model/content/1.0}_x0030_da93a658939add1a4994b8d11a9978c.WAV'],
      'id': '_DEFAULT_!800000000004f7d0',
      'sipecam:Comment': ['Recorded at 16:20:00 16/09/2021 (UTC-5) by AudioMoth '
                          '248C7D075B1FB916 at medium gain setting while battery '
                          'state was 3.5V and temperature was 35.6C.'],
      'sipecam_AvgBytesPerSec': 96000.0,
      'sipecam_Battery': '3.5V',
      'sipecam_BitRate': '768.0 Kbit/sec',
      'sipecam_BitsPerSample': 16.0,
      'sipecam_CentroidCumulusLatitude': 31.22829,
      'sipecam_CentroidCumulusLongitude': -108.85782,
      'sipecam_CumulusName': '95',
      'sipecam_DateDeployment': '2021-08-04T00:00:00Z',
      'sipecam_DateDeployment_unit_of_time_day_of_month': 4,
      'sipecam_DateDeployment_unit_of_time_day_of_week': 3,
      'sipecam_DateDeployment_unit_of_time_day_of_year': 216,
      'sipecam_DateDeployment_unit_of_time_month': 8,
      'sipecam_DateDeployment_unit_of_time_quarter': 3,
      'sipecam_DateDeployment_unit_of_time_year': 2021,
      'sipecam_DateTimeOriginal': '2021-09-16T21:20:00Z',
      'sipecam_DateTimeOriginal_unit_of_time_day_of_month': 16,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_week': 4,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_year': 259,
      'sipecam_DateTimeOriginal_unit_of_time_hour': 21,
      'sipecam_DateTimeOriginal_unit_of_time_minute': 20,
      'sipecam_DateTimeOriginal_unit_of_time_month': 9,
      'sipecam_DateTimeOriginal_unit_of_time_quarter': 3,
      'sipecam_DateTimeOriginal_unit_of_time_second': 0,
      'sipecam_DateTimeOriginal_unit_of_time_year': 2021,
      'sipecam_Duration': 60.005085,
      'sipecam_EcosystemsName': 'Bosques templados',
      'sipecam_Encoding': 'Microsoft PCM',
      'sipecam_FileSize': 5767168,
      'sipecam_Gain': 'medium',
      'sipecam_Latitude': 31.25407,
      'sipecam_Longitude': -108.95226,
      'sipecam_NodeCategoryIntegrity': 'Degradado',
      'sipecam_NomenclatureNode': '1_95_0_1348',
      'sipecam_NumChannels': 1,
      'sipecam_SampleRate': 48000.0,
      'sipecam_SerialNumber': '248C7D075B1FB916',
      'sipecam_Timeexp': 1.0,
      'sipecam_Timezone': 'UTC'},
     {'PATH': ['/{http://www.alfresco.org/model/application/1.0}company_home/{http://www.alfresco.org/model/site/1.0}sites/{http://www.alfresco.org/model/content/1.0}sipecam/{http://www.alfresco.org/model/content/1.0}documentLibrary/{http://www.alfresco.org/model/content/1.0}_x0039_5/{http://www.alfresco.org/model/content/1.0}_x0031__95_0_1348/{http://www.alfresco.org/model/content/1.0}_x0032_48C7D075B1FB916/{http://www.alfresco.org/model/content/1.0}_x0032_021-08-04/{http://www.alfresco.org/model/content/1.0}audios/{http://www.alfresco.org/model/content/1.0}Audible/{http://www.alfresco.org/model/content/1.0}_x0032_9b071d57b535d00e8c13a05add2926b.WAV'],
      'id': '_DEFAULT_!800000000004e462',
      'sipecam:Comment': ['Recorded at 04:50:00 20/08/2021 (UTC-5) by AudioMoth '
                          '248C7D075B1FB916 at medium gain setting while battery '
                          'state was 4.3V and temperature was 19.0C.'],
      'sipecam_AvgBytesPerSec': 96000.0,
      'sipecam_Battery': '4.3V',
      'sipecam_BitRate': '768.0 Kbit/sec',
      'sipecam_BitsPerSample': 16.0,
      'sipecam_CentroidCumulusLatitude': 31.22829,
      'sipecam_CentroidCumulusLongitude': -108.85782,
      'sipecam_CumulusName': '95',
      'sipecam_DateDeployment': '2021-08-04T00:00:00Z',
      'sipecam_DateDeployment_unit_of_time_day_of_month': 4,
      'sipecam_DateDeployment_unit_of_time_day_of_week': 3,
      'sipecam_DateDeployment_unit_of_time_day_of_year': 216,
      'sipecam_DateDeployment_unit_of_time_month': 8,
      'sipecam_DateDeployment_unit_of_time_quarter': 3,
      'sipecam_DateDeployment_unit_of_time_year': 2021,
      'sipecam_DateTimeOriginal': '2021-08-20T09:50:00Z',
      'sipecam_DateTimeOriginal_unit_of_time_day_of_month': 20,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_week': 5,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_year': 232,
      'sipecam_DateTimeOriginal_unit_of_time_hour': 9,
      'sipecam_DateTimeOriginal_unit_of_time_minute': 50,
      'sipecam_DateTimeOriginal_unit_of_time_month': 8,
      'sipecam_DateTimeOriginal_unit_of_time_quarter': 3,
      'sipecam_DateTimeOriginal_unit_of_time_second': 0,
      'sipecam_DateTimeOriginal_unit_of_time_year': 2021,
      'sipecam_Duration': 60.005085,
      'sipecam_EcosystemsName': 'Bosques templados',
      'sipecam_Encoding': 'Microsoft PCM',
      'sipecam_FileSize': 5767168,
      'sipecam_Gain': 'medium',
      'sipecam_Latitude': 31.25407,
      'sipecam_Longitude': -108.95226,
      'sipecam_NodeCategoryIntegrity': 'Degradado',
      'sipecam_NomenclatureNode': '1_95_0_1348',
      'sipecam_NumChannels': 1,
      'sipecam_SampleRate': 48000.0,
      'sipecam_SerialNumber': '248C7D075B1FB916',
      'sipecam_Timeexp': 1.0,
      'sipecam_Timezone': 'UTC'},
     {'PATH': ['/{http://www.alfresco.org/model/application/1.0}company_home/{http://www.alfresco.org/model/site/1.0}sites/{http://www.alfresco.org/model/content/1.0}sipecam/{http://www.alfresco.org/model/content/1.0}documentLibrary/{http://www.alfresco.org/model/content/1.0}_x0039_5/{http://www.alfresco.org/model/content/1.0}_x0031__95_0_1348/{http://www.alfresco.org/model/content/1.0}_x0032_48C7D075B1FB916/{http://www.alfresco.org/model/content/1.0}_x0032_021-08-04/{http://www.alfresco.org/model/content/1.0}audios/{http://www.alfresco.org/model/content/1.0}Audible/{http://www.alfresco.org/model/content/1.0}_x0030_5038e2d2b3b194ba412e1249eee5eb4.WAV'],
      'id': '_DEFAULT_!8000000000050c6d',
      'sipecam:Comment': ['Recorded at 19:30:00 12/09/2021 (UTC-5) by AudioMoth '
                          '248C7D075B1FB916 at medium gain setting while battery '
                          'state was 3.6V and temperature was 29.0C.'],
      'sipecam_AvgBytesPerSec': 96000.0,
      'sipecam_Battery': '3.6V',
      'sipecam_BitRate': '768.0 Kbit/sec',
      'sipecam_BitsPerSample': 16.0,
      'sipecam_CentroidCumulusLatitude': 31.22829,
      'sipecam_CentroidCumulusLongitude': -108.85782,
      'sipecam_CumulusName': '95',
      'sipecam_DateDeployment': '2021-08-04T00:00:00Z',
      'sipecam_DateDeployment_unit_of_time_day_of_month': 4,
      'sipecam_DateDeployment_unit_of_time_day_of_week': 3,
      'sipecam_DateDeployment_unit_of_time_day_of_year': 216,
      'sipecam_DateDeployment_unit_of_time_month': 8,
      'sipecam_DateDeployment_unit_of_time_quarter': 3,
      'sipecam_DateDeployment_unit_of_time_year': 2021,
      'sipecam_DateTimeOriginal': '2021-09-13T00:30:00Z',
      'sipecam_DateTimeOriginal_unit_of_time_day_of_month': 13,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_week': 1,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_year': 256,
      'sipecam_DateTimeOriginal_unit_of_time_hour': 0,
      'sipecam_DateTimeOriginal_unit_of_time_minute': 30,
      'sipecam_DateTimeOriginal_unit_of_time_month': 9,
      'sipecam_DateTimeOriginal_unit_of_time_quarter': 3,
      'sipecam_DateTimeOriginal_unit_of_time_second': 0,
      'sipecam_DateTimeOriginal_unit_of_time_year': 2021,
      'sipecam_Duration': 60.005085,
      'sipecam_EcosystemsName': 'Bosques templados',
      'sipecam_Encoding': 'Microsoft PCM',
      'sipecam_FileSize': 5767168,
      'sipecam_Gain': 'medium',
      'sipecam_Latitude': 31.25407,
      'sipecam_Longitude': -108.95226,
      'sipecam_NodeCategoryIntegrity': 'Degradado',
      'sipecam_NomenclatureNode': '1_95_0_1348',
      'sipecam_NumChannels': 1,
      'sipecam_SampleRate': 48000.0,
      'sipecam_SerialNumber': '248C7D075B1FB916',
      'sipecam_Timeexp': 1.0,
      'sipecam_Timezone': 'UTC'},
     {'PATH': ['/{http://www.alfresco.org/model/application/1.0}company_home/{http://www.alfresco.org/model/site/1.0}sites/{http://www.alfresco.org/model/content/1.0}sipecam/{http://www.alfresco.org/model/content/1.0}documentLibrary/{http://www.alfresco.org/model/content/1.0}_x0039_5/{http://www.alfresco.org/model/content/1.0}_x0031__95_0_1348/{http://www.alfresco.org/model/content/1.0}_x0032_48C7D075B1FB916/{http://www.alfresco.org/model/content/1.0}_x0032_021-08-04/{http://www.alfresco.org/model/content/1.0}audios/{http://www.alfresco.org/model/content/1.0}Audible/{http://www.alfresco.org/model/content/1.0}_x0030_65d7be12fa0bef71613bec50f89daad.WAV'],
      'id': '_DEFAULT_!800000000004e936',
      'sipecam:Comment': ['Recorded at 15:10:00 03/09/2021 (UTC-5) by AudioMoth '
                          '248C7D075B1FB916 at medium gain setting while battery '
                          'state was 4.1V and temperature was 31.2C.'],
      'sipecam_AvgBytesPerSec': 96000.0,
      'sipecam_Battery': '4.1V',
      'sipecam_BitRate': '768.0 Kbit/sec',
      'sipecam_BitsPerSample': 16.0,
      'sipecam_CentroidCumulusLatitude': 31.22829,
      'sipecam_CentroidCumulusLongitude': -108.85782,
      'sipecam_CumulusName': '95',
      'sipecam_DateDeployment': '2021-08-04T00:00:00Z',
      'sipecam_DateDeployment_unit_of_time_day_of_month': 4,
      'sipecam_DateDeployment_unit_of_time_day_of_week': 3,
      'sipecam_DateDeployment_unit_of_time_day_of_year': 216,
      'sipecam_DateDeployment_unit_of_time_month': 8,
      'sipecam_DateDeployment_unit_of_time_quarter': 3,
      'sipecam_DateDeployment_unit_of_time_year': 2021,
      'sipecam_DateTimeOriginal': '2021-09-03T20:10:00Z',
      'sipecam_DateTimeOriginal_unit_of_time_day_of_month': 3,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_week': 5,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_year': 246,
      'sipecam_DateTimeOriginal_unit_of_time_hour': 20,
      'sipecam_DateTimeOriginal_unit_of_time_minute': 10,
      'sipecam_DateTimeOriginal_unit_of_time_month': 9,
      'sipecam_DateTimeOriginal_unit_of_time_quarter': 3,
      'sipecam_DateTimeOriginal_unit_of_time_second': 0,
      'sipecam_DateTimeOriginal_unit_of_time_year': 2021,
      'sipecam_Duration': 60.005085,
      'sipecam_EcosystemsName': 'Bosques templados',
      'sipecam_Encoding': 'Microsoft PCM',
      'sipecam_FileSize': 5767168,
      'sipecam_Gain': 'medium',
      'sipecam_Latitude': 31.25407,
      'sipecam_Longitude': -108.95226,
      'sipecam_NodeCategoryIntegrity': 'Degradado',
      'sipecam_NomenclatureNode': '1_95_0_1348',
      'sipecam_NumChannels': 1,
      'sipecam_SampleRate': 48000.0,
      'sipecam_SerialNumber': '248C7D075B1FB916',
      'sipecam_Timeexp': 1.0,
      'sipecam_Timezone': 'UTC'},
     {'PATH': ['/{http://www.alfresco.org/model/application/1.0}company_home/{http://www.alfresco.org/model/site/1.0}sites/{http://www.alfresco.org/model/content/1.0}sipecam/{http://www.alfresco.org/model/content/1.0}documentLibrary/{http://www.alfresco.org/model/content/1.0}_x0039_5/{http://www.alfresco.org/model/content/1.0}_x0031__95_0_1348/{http://www.alfresco.org/model/content/1.0}_x0032_48C7D075B1FB916/{http://www.alfresco.org/model/content/1.0}_x0032_021-08-04/{http://www.alfresco.org/model/content/1.0}audios/{http://www.alfresco.org/model/content/1.0}Audible/{http://www.alfresco.org/model/content/1.0}_x0031_b89f34475c9258d3aaac39e97f6602d.WAV'],
      'id': '_DEFAULT_!800000000004d163',
      'sipecam:Comment': ['Recorded at 03:30:00 04/09/2021 (UTC-5) by AudioMoth '
                          '248C7D075B1FB916 at medium gain setting while battery '
                          'state was 3.9V and temperature was 21.0C.'],
      'sipecam_AvgBytesPerSec': 96000.0,
      'sipecam_Battery': '3.9V',
      'sipecam_BitRate': '768.0 Kbit/sec',
      'sipecam_BitsPerSample': 16.0,
      'sipecam_CentroidCumulusLatitude': 31.22829,
      'sipecam_CentroidCumulusLongitude': -108.85782,
      'sipecam_CumulusName': '95',
      'sipecam_DateDeployment': '2021-08-04T00:00:00Z',
      'sipecam_DateDeployment_unit_of_time_day_of_month': 4,
      'sipecam_DateDeployment_unit_of_time_day_of_week': 3,
      'sipecam_DateDeployment_unit_of_time_day_of_year': 216,
      'sipecam_DateDeployment_unit_of_time_month': 8,
      'sipecam_DateDeployment_unit_of_time_quarter': 3,
      'sipecam_DateDeployment_unit_of_time_year': 2021,
      'sipecam_DateTimeOriginal': '2021-09-04T08:30:00Z',
      'sipecam_DateTimeOriginal_unit_of_time_day_of_month': 4,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_week': 6,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_year': 247,
      'sipecam_DateTimeOriginal_unit_of_time_hour': 8,
      'sipecam_DateTimeOriginal_unit_of_time_minute': 30,
      'sipecam_DateTimeOriginal_unit_of_time_month': 9,
      'sipecam_DateTimeOriginal_unit_of_time_quarter': 3,
      'sipecam_DateTimeOriginal_unit_of_time_second': 0,
      'sipecam_DateTimeOriginal_unit_of_time_year': 2021,
      'sipecam_Duration': 60.005085,
      'sipecam_EcosystemsName': 'Bosques templados',
      'sipecam_Encoding': 'Microsoft PCM',
      'sipecam_FileSize': 5767168,
      'sipecam_Gain': 'medium',
      'sipecam_Latitude': 31.25407,
      'sipecam_Longitude': -108.95226,
      'sipecam_NodeCategoryIntegrity': 'Degradado',
      'sipecam_NomenclatureNode': '1_95_0_1348',
      'sipecam_NumChannels': 1,
      'sipecam_SampleRate': 48000.0,
      'sipecam_SerialNumber': '248C7D075B1FB916',
      'sipecam_Timeexp': 1.0,
      'sipecam_Timezone': 'UTC'}]


### Video

Al finalizar el pipeline de procesamiento de video se debe asociar a cada imagen obtenida (dado que en el pipeline de video se segmenta en frames el video, son 2 imágenes como máximo que se obtienen por decisión con el equipo de ciencia) con su metadata. Por ejemplo, qué día se tomó el video, en qué coordenadas, etc.


```python
q          = "q=cm:name:0d05d10d2939c0351a837b6bb2c53f1d_0528.mp4"
fl         = "fl=cm_name,cm_versionType,cm_versionLabel,audio_sampleRate,sipecam*"
fl         = fl + ",[cached]&indent=on"
wt         = "wt=json"
params     = [fl, q, wt] 
p          = "&".join(params)
p          = p.replace(' ', '%20')
```


```python
html = urlopen(url+p)
print(html)
connection = html
if wt == "wt=json":
  response   = simplejson.load(connection) 
else:
  response   = eval(connection.read())
```

    <http.client.HTTPResponse object at 0x7fc1a6abc1c0>



```python
print("Number of hits: " + str(response['response']['numFound']))
```

    Number of hits: 1



```python
pprint.pprint(response['response']['docs'])
```

    [{'audio_sampleRate': 1000,
      'cm_name': '0d05d10d2939c0351a837b6bb2c53f1d_0528.mp4',
      'cm_versionLabel': '1.0',
      'cm_versionType': 'MAJOR',
      'id': '_DEFAULT_!800000000008ac30',
      'sipecam_AudioBitRate': '256.4 Kbit/sec',
      'sipecam_AudioCompression': 'Microsoft Pulse Code Modulation (PCM)',
      'sipecam_AudioCompressionRate': '1.0x',
      'sipecam_AudioSampleCount': 0,
      'sipecam_AudioSampleRate': '16.0 kHz',
      'sipecam_AvgBytesPerSec': 32050.0,
      'sipecam_BMPVersion': 'Windows V3',
      'sipecam_BitRate': '5.3 Mbit/sec',
      'sipecam_BitsPerSample': 16.0,
      'sipecam_CentroidCumulusLatitude': 18.16965,
      'sipecam_CentroidCumulusLongitude': -91.82522,
      'sipecam_CumulusName': '13',
      'sipecam_DateDeployment': '2022-02-21T00:00:00Z',
      'sipecam_DateDeployment_unit_of_time_day_of_month': 21,
      'sipecam_DateDeployment_unit_of_time_day_of_week': 1,
      'sipecam_DateDeployment_unit_of_time_day_of_year': 52,
      'sipecam_DateDeployment_unit_of_time_month': 2,
      'sipecam_DateDeployment_unit_of_time_quarter': 1,
      'sipecam_DateDeployment_unit_of_time_year': 2022,
      'sipecam_DateTimeOriginal': '2022-03-19T21:50:39Z',
      'sipecam_DateTimeOriginal_unit_of_time_day_of_month': 19,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_week': 6,
      'sipecam_DateTimeOriginal_unit_of_time_day_of_year': 78,
      'sipecam_DateTimeOriginal_unit_of_time_hour': 21,
      'sipecam_DateTimeOriginal_unit_of_time_minute': 50,
      'sipecam_DateTimeOriginal_unit_of_time_month': 3,
      'sipecam_DateTimeOriginal_unit_of_time_quarter': 1,
      'sipecam_DateTimeOriginal_unit_of_time_second': 39,
      'sipecam_DateTimeOriginal_unit_of_time_year': 2022,
      'sipecam_Duration': 5.12,
      'sipecam_EcosystemsName': 'Selvas humedas',
      'sipecam_Encoding': 'Microsoft PCM',
      'sipecam_Endianness': 'Little endian',
      'sipecam_FileSize': 3355443,
      'sipecam_FrameCount': 64,
      'sipecam_FrameRate': 12,
      'sipecam_ImageHeight': 720,
      'sipecam_ImageLength': '2211840',
      'sipecam_ImageWidth': 1024,
      'sipecam_Latitude': 18.1404,
      'sipecam_LatitudeRef': 'North',
      'sipecam_Longitude': -91.9463,
      'sipecam_LongitudeRef': 'West',
      'sipecam_MaxDataRate': 26542080,
      'sipecam_Megapixels': 0.73728,
      'sipecam_NodeCategoryIntegrity': 'Degradado',
      'sipecam_NomenclatureNode': '3_13_0_1398',
      'sipecam_NumChannels': 1,
      'sipecam_NumColors': 'Use BitDepth',
      'sipecam_NumImportantColors': 'All',
      'sipecam_PixelsPerMeterX': '0',
      'sipecam_PixelsPerMeterY': '0',
      'sipecam_Planes': 1,
      'sipecam_SerialNumber': 'HLPXGM09048448',
      'sipecam_StreamCount': 2,
      'sipecam_VideoBitsPerPixel': 24,
      'sipecam_VideoCompression': 'Motion JPEG DIB (fourcc:"MJPG")'}]


[SOLR client APIs, Capillas C.](https://www.zylk.net/en/web-2-0/blog/-/blogs/solr-client-apis)
