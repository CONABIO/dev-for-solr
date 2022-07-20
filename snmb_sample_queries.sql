--- archivo camara ---

SELECT conglomerado_muestra.id AS conglomerado_muestra_id,
    tabla_aux.id,
    tabla_aux.camara_id,
    tabla_aux.archivo_nombre_original,
    tabla_aux.archivo,
    tabla_aux.presencia,
    tabla_aux.nombre_comun,
    tabla_aux.nombre_cientifico,
    tabla_aux.numero_individuos,
    tabla_aux.archivo_nombre_filesystem,
    (((conglomerado_muestra.nombre::text || '/'::text) || to_char(conglomerado_muestra.fecha_visita::timestamp with time zone, 'YYYY_MM'::text)) || '/fotos_videos/'::text) || tabla_aux.archivo_nombre_filesystem AS archivo_ruta_filesystem
   FROM conglomerado_muestra
     JOIN sitio_muestra ON conglomerado_muestra.id = sitio_muestra.conglomerado_muestra_id
     JOIN camara ON sitio_muestra.id = camara.sitio_muestra_id
     JOIN ( SELECT archivo_camara.id,
            archivo_camara.camara_id,
            archivo_camara.archivo_nombre_original,
            archivo_camara.archivo,
            archivo_camara.presencia,
            archivo_camara.nombre_comun,
            archivo_camara.nombre_cientifico,
            archivo_camara.numero_individuos,
            ("substring"(archivo_camara.archivo::text, '(.*\.).*\..*\..*\.'::text) || "substring"(archivo_camara.archivo::text, '.*\..*\.(.*\.).*\.'::text)) || "substring"(archivo_camara.archivo::text, '.*\..*\..*\..*\.(.*)'::text) AS archivo_nombre_filesystem
           FROM archivo_camara
          WHERE archivo_camara.archivo::text ~ similar_escape('_*._*._*._*._*'::text, NULL::text)
        UNION
         SELECT archivo_camara.id,
            archivo_camara.camara_id,
            archivo_camara.archivo_nombre_original,
            archivo_camara.archivo,
            archivo_camara.presencia,
            archivo_camara.nombre_comun,
            archivo_camara.nombre_cientifico,
            archivo_camara.numero_individuos,
            archivo_camara.archivo AS archivo_nombre_filesystem
           FROM archivo_camara
          WHERE archivo_camara.archivo::text !~ similar_escape('_*._*._*._*._*'::text, NULL::text)) tabla_aux ON camara.id = tabla_aux.camara_id



---- conteo de aves

SELECT conglomerado_muestra.id AS conglomerado_muestra_id,
    tabla_aux.id,
    tabla_aux.conteo_ave_id,
    tabla_aux.archivo_nombre_original,
    tabla_aux.archivo,
    tabla_aux.archivo_nombre_filesystem,
    (((conglomerado_muestra.nombre::text || '/'::text) || to_char(conglomerado_muestra.fecha_visita::timestamp with time zone, 'YYYY_MM'::text)) || '/otros/'::text) || tabla_aux.archivo_nombre_filesystem AS archivo_ruta_filesystem
   FROM conglomerado_muestra
     JOIN sitio_muestra ON conglomerado_muestra.id = sitio_muestra.conglomerado_muestra_id
     JOIN punto_conteo_aves ON sitio_muestra.id = punto_conteo_aves.sitio_muestra_id
     JOIN conteo_ave ON punto_conteo_aves.id = conteo_ave.punto_conteo_aves_id
     JOIN ( SELECT archivo_conteo_ave.id,
            archivo_conteo_ave.conteo_ave_id,
            archivo_conteo_ave.archivo_nombre_original,
            archivo_conteo_ave.archivo,
            ("substring"(archivo_conteo_ave.archivo::text, '(.*\.).*\..*\..*\.'::text) || "substring"(archivo_conteo_ave.archivo::text, '.*\..*\.(.*\.).*\.'::text)) || "substring"(archivo_conteo_ave.archivo::text, '.*\..*\..*\..*\.(.*)'::text) AS archivo_nombre_filesystem
           FROM archivo_conteo_ave
          WHERE archivo_conteo_ave.archivo::text ~ similar_escape('_*._*._*._*._*'::text, NULL::text)
        UNION
         SELECT archivo_conteo_ave.id,
            archivo_conteo_ave.conteo_ave_id,
            archivo_conteo_ave.archivo_nombre_original,
            archivo_conteo_ave.archivo,
            archivo_conteo_ave.archivo AS archivo_nombre_filesystem
           FROM archivo_conteo_ave
          WHERE archivo_conteo_ave.archivo::text !~ similar_escape('_*._*._*._*._*'::text, NULL::text)) tabla_aux ON conteo_ave.id = tabla_aux.conteo_ave_id


          ----- archivo grabadora

          SELECT conglomerado_muestra.id AS conglomerado_muestra_id,
    tabla_aux.id,
    tabla_aux.grabadora_id,
    tabla_aux.archivo_nombre_original,
    tabla_aux.archivo,
    tabla_aux.es_audible,
    tabla_aux.archivo_nombre_filesystem,
    (((conglomerado_muestra.nombre::text || '/'::text) || to_char(conglomerado_muestra.fecha_visita::timestamp with time zone, 'YYYY_MM'::text)) || '/grabaciones_audibles/'::text) || tabla_aux.archivo_nombre_filesystem AS archivo_ruta_filesystem
   FROM conglomerado_muestra
     JOIN sitio_muestra ON conglomerado_muestra.id = sitio_muestra.conglomerado_muestra_id
     JOIN grabadora ON sitio_muestra.id = grabadora.sitio_muestra_id
     JOIN ( SELECT archivo_grabadora.id,
            archivo_grabadora.grabadora_id,
            archivo_grabadora.archivo_nombre_original,
            archivo_grabadora.archivo,
            archivo_grabadora.es_audible,
            ("substring"(archivo_grabadora.archivo::text, '(.*\.).*\..*\..*\.'::text) || "substring"(archivo_grabadora.archivo::text, '.*\..*\.(.*\.).*\.'::text)) || "substring"(archivo_grabadora.archivo::text, '.*\..*\..*\..*\.(.*)'::text) AS archivo_nombre_filesystem
           FROM archivo_grabadora
          WHERE archivo_grabadora.archivo::text ~ similar_escape('_*._*._*._*._*'::text, NULL::text)
        UNION
         SELECT archivo_grabadora.id,
            archivo_grabadora.grabadora_id,
            archivo_grabadora.archivo_nombre_original,
            archivo_grabadora.archivo,
            archivo_grabadora.es_audible,
            archivo_grabadora.archivo AS archivo_nombre_filesystem
           FROM archivo_grabadora
          WHERE archivo_grabadora.archivo::text !~ similar_escape('_*._*._*._*._*'::text, NULL::text)) tabla_aux ON grabadora.id = tabla_aux.grabadora_id
  WHERE tabla_aux.es_audible = 'T'::bpchar
UNION
 SELECT conglomerado_muestra.id AS conglomerado_muestra_id,
    tabla_aux.id,
    tabla_aux.grabadora_id,
    tabla_aux.archivo_nombre_original,
    tabla_aux.archivo,
    tabla_aux.es_audible,
    tabla_aux.archivo_nombre_filesystem,
    (((conglomerado_muestra.nombre::text || '/'::text) || to_char(conglomerado_muestra.fecha_visita::timestamp with time zone, 'YYYY_MM'::text)) || '/grabaciones_ultrasonicas/'::text) || tabla_aux.archivo_nombre_filesystem AS archivo_ruta_filesystem
   FROM conglomerado_muestra
     JOIN sitio_muestra ON conglomerado_muestra.id = sitio_muestra.conglomerado_muestra_id
     JOIN grabadora ON sitio_muestra.id = grabadora.sitio_muestra_id
     JOIN ( SELECT archivo_grabadora.id,
            archivo_grabadora.grabadora_id,
            archivo_grabadora.archivo_nombre_original,
            archivo_grabadora.archivo,
            archivo_grabadora.es_audible,
            ("substring"(archivo_grabadora.archivo::text, '(.*\.).*\..*\..*\.'::text) || "substring"(archivo_grabadora.archivo::text, '.*\..*\.(.*\.).*\.'::text)) || "substring"(archivo_grabadora.archivo::text, '.*\..*\..*\..*\.(.*)'::text) AS archivo_nombre_filesystem
           FROM archivo_grabadora
          WHERE archivo_grabadora.archivo::text ~ similar_escape('_*._*._*._*._*'::text, NULL::text)
        UNION
         SELECT archivo_grabadora.id,
            archivo_grabadora.grabadora_id,
            archivo_grabadora.archivo_nombre_original,
            archivo_grabadora.archivo,
            archivo_grabadora.es_audible,
            archivo_grabadora.archivo AS archivo_nombre_filesystem
           FROM archivo_grabadora
          WHERE archivo_grabadora.archivo::text !~ similar_escape('_*._*._*._*._*'::text, NULL::text)) tabla_aux ON grabadora.id = tabla_aux.grabadora_id
  WHERE tabla_aux.es_audible = 'F'::bpchar


  ----- extraccion datos para naturalista


  SELECT './'::text || string_agg(archivo_camara_filesystem.archivo_ruta_filesystem, ', ./'::text) AS "local_photos[0]",
    archivo_camara_filesystem.nombre_cientifico AS "observation[species_guess]",
    conglomerado_muestra_coords_wgs84_cop13.fecha_visita AS "observation[observed_on_string]",
    conglomerado_muestra_coords_wgs84_cop13.lat AS "observation[latitude]",
    conglomerado_muestra_coords_wgs84_cop13.lon AS "observation[longitude]",
    (((conglomerado_muestra_coords_wgs84_cop13.estado::text || ', '::text) || conglomerado_muestra_coords_wgs84_cop13.municipio::text) || ', '::text) || conglomerado_muestra_coords_wgs84_cop13.anp_nombre_oficial::text AS "observation[place_guess]",
    ((((((((((('conglomerado_muestra_id: '::text || conglomerado_muestra_coords_wgs84_cop13.id::text) || ', '::text) || 'conglomerado_nombre: '::text) || conglomerado_muestra_coords_wgs84_cop13.nombre::text) || ', '::text) || 'archivo_camara_id: '::text) || '('::text) || string_agg(archivo_camara_filesystem.id::text, ', '::text)) || ')'::text) || ', '::text) || 'monitoreo_tipo: '::text) || conglomerado_muestra_coords_wgs84_cop13.monitoreo_tipo::text AS "observation[tag_list]"
   FROM conglomerado_muestra_coords_wgs84_cop13
     JOIN archivo_camara_filesystem ON conglomerado_muestra_coords_wgs84_cop13.id = archivo_camara_filesystem.conglomerado_muestra_id
  WHERE archivo_camara_filesystem.presencia = 'T'::bpchar AND conglomerado_muestra_coords_wgs84_cop13.anp_nombre_oficial IS NOT NULL AND archivo_camara_filesystem.archivo_nombre_filesystem ~~* '%.jp%'::text
  GROUP BY archivo_camara_filesystem.nombre_cientifico, conglomerado_muestra_coords_wgs84_cop13.fecha_visita, conglomerado_muestra_coords_wgs84_cop13.lat, conglomerado_muestra_coords_wgs84_cop13.lon, conglomerado_muestra_coords_wgs84_cop13.estado, conglomerado_muestra_coords_wgs84_cop13.municipio, conglomerado_muestra_coords_wgs84_cop13.anp_nombre_oficial, conglomerado_muestra_coords_wgs84_cop13.id, conglomerado_muestra_coords_wgs84_cop13.nombre, conglomerado_muestra_coords_wgs84_cop13.monitoreo_tipo
UNION
 SELECT './'::text || string_agg(archivo_camara_filesystem.archivo_ruta_filesystem, ', ./'::text) AS "local_photos[0]",
    archivo_camara_filesystem.nombre_cientifico AS "observation[species_guess]",
    conglomerado_muestra_coords_wgs84_cop13.fecha_visita AS "observation[observed_on_string]",
    conglomerado_muestra_coords_wgs84_cop13.lat AS "observation[latitude]",
    conglomerado_muestra_coords_wgs84_cop13.lon AS "observation[longitude]",
    (conglomerado_muestra_coords_wgs84_cop13.estado::text || ', '::text) || conglomerado_muestra_coords_wgs84_cop13.municipio::text AS "observation[place_guess]",
    ((((((((((('conglomerado_muestra_id: '::text || conglomerado_muestra_coords_wgs84_cop13.id::text) || ', '::text) || 'conglomerado_nombre: '::text) || conglomerado_muestra_coords_wgs84_cop13.nombre::text) || ', '::text) || 'archivo_camara_id: '::text) || '('::text) || string_agg(archivo_camara_filesystem.id::text, ', '::text)) || ')'::text) || ', '::text) || 'monitoreo_tipo: '::text) || conglomerado_muestra_coords_wgs84_cop13.monitoreo_tipo::text AS "observation[tag_list]"
   FROM conglomerado_muestra_coords_wgs84_cop13
     JOIN archivo_camara_filesystem ON conglomerado_muestra_coords_wgs84_cop13.id = archivo_camara_filesystem.conglomerado_muestra_id
  WHERE archivo_camara_filesystem.presencia = 'T'::bpchar AND conglomerado_muestra_coords_wgs84_cop13.anp_nombre_oficial IS NULL AND archivo_camara_filesystem.archivo_nombre_filesystem ~~* '%.jp%'::text
  GROUP BY archivo_camara_filesystem.nombre_cientifico, conglomerado_muestra_coords_wgs84_cop13.fecha_visita, conglomerado_muestra_coords_wgs84_cop13.lat, conglomerado_muestra_coords_wgs84_cop13.lon, conglomerado_muestra_coords_wgs84_cop13.estado, conglomerado_muestra_coords_wgs84_cop13.municipio, conglomerado_muestra_coords_wgs84_cop13.anp_nombre_oficial, conglomerado_muestra_coords_wgs84_cop13.id, conglomerado_muestra_coords_wgs84_cop13.nombre, conglomerado_muestra_coords_wgs84_cop13.monitoreo_tipo




------- sitio muestra Gemoetria

SELECT tabla_aux.sitio_muestra_id,
    tabla_aux.conglomerado_muestra_id,
    tabla_aux.sitio_numero,
    tabla_aux.lon,
    tabla_aux.lat,
    st_setsrid(st_makepoint(tabla_aux.lon, tabla_aux.lat), 4326) AS the_geom
   FROM ( SELECT sitio_muestra.id AS sitio_muestra_id,
            sitio_muestra.conglomerado_muestra_id,
            sitio_muestra.sitio_numero,
            (abs(sitio_muestra.lon_grado::double precision) + abs(sitio_muestra.lon_min::double precision / 60.0::double precision) + abs(sitio_muestra.lon_seg / 3600.0::double precision)) * '-1.0'::numeric::double precision AS lon,
            abs(sitio_muestra.lat_grado::double precision) + abs(sitio_muestra.lat_min::double precision / 60.0::double precision) + abs(sitio_muestra.lat_seg / 3600.0::double precision) AS lat
           FROM sitio_muestra
          WHERE sitio_muestra.elipsoide::text = 'WGS84'::text) tabla_aux


----- conglomerado muestra geometria

SELECT DISTINCT ON (conglomerado_muestra.id) conglomerado_muestra.id,
    conglomerado_muestra.nombre,
    conglomerado_muestra.fecha_visita,
    conglomerado_muestra.predio,
    conglomerado_muestra.compania,
    conglomerado_muestra.tipo,
    conglomerado_muestra.estado,
    conglomerado_muestra.municipio,
    conglomerado_muestra.tenencia,
    conglomerado_muestra.uso_suelo_tipo,
    conglomerado_muestra.monitoreo_tipo,
    conglomerado_muestra.institucion,
    conglomerado_muestra.vegetacion_tipo,
    conglomerado_muestra.perturbado,
    conglomerado_muestra.comentario,
    sitio_muestra_geometria_wgs84.lat,
    sitio_muestra_geometria_wgs84.lon,
    anp_agosto12gw.id_anp AS anp_clave,
    anp_agosto12gw.nombre AS anp_nombre_oficial,
    dest_2012gw.cve_ent AS estado_clave,
    dest_2012gw.nom_ent AS estado_nombre_oficial,
    muni_2012gw.cve_mun AS municipio_clave,
    muni_2012gw.nom_mun AS municipio_nombre_oficial
   FROM conglomerado_muestra
     JOIN sitio_muestra_geometria_wgs84 ON conglomerado_muestra.id = sitio_muestra_geometria_wgs84.conglomerado_muestra_id
     LEFT JOIN anp_agosto12gw ON st_intersects(sitio_muestra_geometria_wgs84.the_geom, anp_agosto12gw.the_geom)
     LEFT JOIN dest_2012gw ON st_intersects(sitio_muestra_geometria_wgs84.the_geom, dest_2012gw.the_geom)
     LEFT JOIN muni_2012gw ON st_intersects(sitio_muestra_geometria_wgs84.the_geom, muni_2012gw.the_geom)
  WHERE sitio_muestra_geometria_wgs84.sitio_numero::text = 'Centro'::text
  ORDER BY conglomerado_muestra.id, anp_agosto12gw.id_anp, muni_2012gw.cve_mun, dest_2012gw.cve_ent;