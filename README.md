# Objetivo 📋

El objetivo de este repositorio es documentar el uso de Solr para crear consultas de las distintas fuentes de datos que componen el proyecto SipeCam en CONABIO. Las fuentes pueden ser bases de datos relacionales de PostgreSQL o un Solr con información proveniente de Alfresco.

---

# Estructura ✒️

El repositorio está ordenado de la siguiente manera y se recomienda explorarlo en este mismo orden:

```  
├── solr              <- Carpeta que contiene guía de configuración de Solr.
├── consultas         <- Distintas consultas para diversas fuentes de datos SipeCam.
│   ├── alfresco      <- Configuración y consultas para la fuente de datos de Alfresco.
│   ├── snmb          <- Configuración y consultas para las tablas de zendro correspondientes a snmb.
│   └── sonozotz      <- Configuración y consultas para las tablas de zendro correspondientes a sonozotz.
├── python            <- Uso de solr a través de python.
└── README.md         
```
