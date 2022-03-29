-- Database: postgres

-- DROP DATABASE IF EXISTS postgres;

--INSERT INTO masks(id_masks, url) VALUES (0, 'pouet');
--INSERT INTO sources(id_sources, credit, home, url, viewer, thumbnail, lowres, highres, iip, footprint) VALUES (0, 'mi', 'mi', 'mi', 'mi', 'mi', 'mi', 'mi', 'mi', ST_GeomFromText('MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3)))', 2154));
--INSERT INTO interne(id_interne, pp, focal, skew, near_frustum_camera, distorsion) VALUES (0, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 0, ST_GeomFromText('POINTZ(0 0 0)', 2154), '{0, 0}');
--INSERT INTO externe(id_externe, point, quaternion, srid) VALUES (0, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 2154);
--INSERT INTO transfo2d(id_transfo2d, image_matrix) VALUES (0, '{0, 0}');
--INSERT INTO transfo3d(id_transfo3d, image_matrix) VALUES (0, '{0, 0}');
--INSERT INTO images(id_images, t0, t1, image, origine, qualite, resolution_min, resolution_moy, resolution_max, footprint, size_image, id_sources, id_masks) VALUES (0, '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', 'pouet', 'test', 0, 0, 0, 0, ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POINT(0 0)', 2154), 0, 0);
--INSERT INTO points_appuis(id_points_appuis, point_2d, point_3d, id_images) VALUES (0, ST_GeomFromText('POINT(0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 0);
INSERT INTO georefs(id_georefs, user_georef, date, georef_principal, id_transfo2d, id_transfo3d, id_interne, id_externe, id_images) VALUES (0, 'ama', '2016-06-22 19:10:25-07', TRUE,0, 0, 0, 0, 0);

SELECT test('interne', 0);