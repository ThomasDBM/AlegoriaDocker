--INSERT INTO masks(id_masks, url) VALUES (2, 'pouet3');

INSERT INTO sources(id_sources, credit, home, url, viewer, thumbnail, lowres, highres, iip, footprint) VALUES (2, 'mi3', 'mi3', 'mi3', 'mi3', 'mi3', 'mi3', 'mi3', 'mi3', ST_GeomFromText('MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3)))', 2154));

INSERT INTO interne(id_interne, pp, focal, skew, distorsion) VALUES (2, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 0, '{0, 0}');
INSERT INTO externe(id_externe, point, quaternion, srid) VALUES (2, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 2154);
INSERT INTO transfo2d(id_transfo2d, image_matrix) VALUES (2, '{0, 0}');

INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES (2, '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', 'pouet3', ST_GeomFromText('POINT(0 0)', 2154), 2, 2);
INSERT INTO points_appuis(id_points_appuis, point_2d, point_3d, id_images) VALUES (2, ST_GeomFromText('POINT(0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 2);
INSERT INTO georefs(id_georefs, user_georef, date, georef_principal, footprint, near, far, id_transfo2d, id_interne, id_externe, id_images) VALUES (2, 'ama2', '2016-06-22 19:10:25-07', TRUE, ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), 2, 2, 2, 2);

INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES (3, '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', 'pouet4', ST_GeomFromText('POINT(0 0)', 2154), 2, 2);
INSERT INTO points_appuis(id_points_appuis, point_2d, point_3d, id_images) VALUES (3, ST_GeomFromText('POINT(0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 3);
INSERT INTO georefs(id_georefs, user_georef, date, georef_principal, footprint, near, far, id_transfo2d, id_interne, id_externe, id_images) VALUES (3, 'ama2', '2016-06-22 19:10:25-07', TRUE, ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), 2, 2, 2, 2);

SELECT id_images FROM images;
SELECT remove_batch_data('sources', 2);
SELECT remove_batch_data('masks', 2);
SELECT remove_batch_data('test', 2);