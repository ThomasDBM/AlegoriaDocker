/*
    Test for the remove_data function
*/

-- Test with the suppression of a data

INSERT INTO masks(id_masks, url) VALUES (0, 'pouet');
INSERT INTO sources(id_sources, credit, home, url, viewer, thumbnail, lowres, highres, iip, footprint) VALUES (0, 'mi', 'mi', 'mi', 'mi', 'mi', 'mi', 'mi', 'mi', ST_GeomFromText('MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3)))', 2154));
INSERT INTO interne(id_interne, pp, focal, skew, distorsion) VALUES (0, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 0, '{0, 0}');
INSERT INTO externe(id_externe, point, quaternion, srid) VALUES (0, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 2154);
INSERT INTO transfo2d(id_transfo2d, image_matrix) VALUES (0, '{0, 0}');
INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES (0, '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', 'pouet', ST_GeomFromText('POINT(0 0)', 2154), 0, 0);
INSERT INTO points_appuis(id_points_appuis, point_2d, point_3d, id_images) VALUES (0, ST_GeomFromText('POINT(0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 0);
INSERT INTO georefs(id_georefs, user_georef, date, georef_principal, footprint, near, far, id_transfo2d, id_interne, id_externe, id_images) VALUES (0, 'ama', '2016-06-22 19:10:25-07', TRUE, ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), 0, 0, 0, 0);

SELECT remove_data('interne', 0), remove_data('externe', 0), remove_data('transfo2d',0); 
SELECT remove_data('pouet', 1);
SELECT remove_data('images', 0);
SELECT remove_data('masks', 0), remove_data('sources', 0);
SELECT remove_data('georefs', 0);
SELECT remove_data('images', 340);

-- Test the remove_function data with the images table first

INSERT INTO masks(id_masks, url) VALUES (1, 'pouet2');
INSERT INTO sources(id_sources, credit, home, url, viewer, thumbnail, lowres, highres, iip, footprint) VALUES (1, 'mi2', 'mi2', 'mi2', 'mi2', 'mi2', 'mi2', 'mi2', 'mi2', ST_GeomFromText('MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3)))', 2154));
INSERT INTO interne(id_interne, pp, focal, skew, distorsion) VALUES (1, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 0, '{0, 0}');
INSERT INTO externe(id_externe, point, quaternion, srid) VALUES (1, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 2154);
INSERT INTO transfo2d(id_transfo2d, image_matrix) VALUES (1, '{0, 0}');
INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES (1, '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', 'pouet2', ST_GeomFromText('POINT(0 0)', 2154), 1, 1);
INSERT INTO points_appuis(id_points_appuis, point_2d, point_3d, id_images) VALUES (1, ST_GeomFromText('POINT(0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 1);
INSERT INTO georefs(id_georefs, user_georef, date, georef_principal, footprint, near, far, id_transfo2d, id_interne, id_externe, id_images) VALUES (1, 'ama2', '2016-06-22 19:10:25-07', TRUE, ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), 1, 1, 1, 1);

SELECT remove_data('masks', 1);
SELECT remove_data('images', 1);