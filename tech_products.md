Instalar solr localmente

1. Ir a [Installing Solr](https://solr.apache.org/downloads.html).
   En nuestro caso, instalamos el Binary release 8.11.2
2. Unzippear la carpeta instalada: tar -xvzf ./solr-8.11.2.tgz -C {your_choosen_directory}
3. export solr_home=/Users/rodrigojuarez/Documents/Estancia/solr-8.11.2 #guardamos el solr_home
4. cd $solr_home #cambiamos al directorio
5. bin/solr start -p 8983
6. Entrar a http://localhost:8983/solr/#/
7. Add core (nombre y directorio) En mi caso: /Users/rodrigojuarez/Documents/Estancia/solr-8.11.2/server/solr/configsets/sample_techproducts_configs
8. Agregamos data vía cd $solr_home y cd example/exampledocs
9. java -jar -Dc=tech_products post.jar *.xml
