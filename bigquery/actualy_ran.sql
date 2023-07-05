CREATE TABLE road_config.road_config_geo
(
  road_id INT64,
  geom GEOGRAPHY,
  osm_id INT64,
  osm_code INT64,
  osm_fclass STRING,
  osm_name STRING,
  osm_ref STRING,
  osm_oneway STRING,
  osm_maxspeed INT64,
  osm_layer INT64,
  osm_bridge BOOL,
  osm_tunnel BOOL,
  no2_points INT64,
  no2_drives INT64,
  no2_ppb FLOAT64,
  no_points INT64,
  no_drives INT64,
  no_ppb FLOAT64,
  co2_points INT64,
  co2_drives INT64,
  co2_ppm FLOAT64,
  co_points INT64,
  co_drives INT64,
  co_ppm FLOAT64,
  o3_points INT64,
  o3_drives INT64,
  o3_ppb FLOAT64,
  pm25_points INT64,
  pm25_drives INT64,
  pm25_ugm3 FLOAT64
);

insert into road_config.road_config_geo select road_id ,
  ST_GEOGFROM(geom) as geom,
  osm_id ,
  osm_code ,
  osm_fclass ,
  osm_name ,
  osm_ref ,
  osm_oneway ,
  osm_maxspeed ,
  osm_layer ,
  osm_bridge ,
  osm_tunnel ,
  no2_points ,
  no2_drives ,
  no2_ppb ,
  no_points ,
  no_drives ,
  no_ppb ,
  co2_points ,
  co2_drives ,
  co2_ppm ,
  co_points ,
  co_drives ,
  co_ppm ,
  o3_points ,
  o3_drives ,
  o3_ppb ,
  pm25_points ,
  pm25_drives ,
  pm25_ugm3 

from `road_config.road_config`;

CREATE TABLE road_config.sensor_target
(
  timestamp TIMESTAMP,
  lat_lon GEOGRAPHY,
  no_ppb FLOAT64,
  no2_ppb FLOAT64,
  o3_ppb FLOAT64,
  co_ppm FLOAT64,
  co2_ppm FLOAT64,
  pmch1_perl INT64,
  pmch2_perl INT64,
  pmch3_perl INT64,
  pmch4_perl INT64,
  pmch5_perl INT64,
  pmch6_perl INT64,
  pm25_ugm3 FLOAT64
);

insert into road_config.sensor_target 
  select timestamp ,
  ST_GEOGPOINT(longitude,latitude 
  ) ,
  no_ppb ,
  no2_ppb ,
  o3_ppb ,
  co_ppm ,
  co2_ppm ,
  pmch1_perl ,
  pmch2_perl ,
  pmch3_perl ,
  pmch4_perl ,
  pmch5_perl ,
  pmch6_perl ,
  pm25_ugm3  from raw__road_data.raw_road_data_import
;