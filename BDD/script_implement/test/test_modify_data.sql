INSERT INTO masks(id_masks, url) VALUES (4, 'pouet4');

INSERT INTO sources(id_sources, credit, home, url, viewer, thumbnail, lowres, highres, iip, footprint) VALUES (4, 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', ST_GeomFromText('MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3)))', 2154));

INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES (4, '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', 'pouet4', ST_GeomFromText('POINT(0 0)', 2154), 4, 4);
INSERT INTO points_appuis(id_points_appuis, point_2d, point_3d, id_images) VALUES (4, ST_GeomFromText('POINT(0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 4);

SELECT modify_points_appuis(-1, '''POINT(0 0)''', '''POINTZ(0 0 0)''', 2154);
SELECT modify_points_appuis(1, '''POINT(0 0)''', '''POINTZ(0 0 0)''', 215);
SELECT modify_points_appuis(1, '''POINT(2 2)''', '''POINTZ(2 2 2)''', 2154);

-- Test 2

INSERT INTO interne(id_interne, pp, focal, skew, distorsion) VALUES (4, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 0, '{0, 0}');
INSERT INTO externe(id_externe, point, quaternion, srid) VALUES (4, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 2154);
INSERT INTO transfo2d(id_transfo2d, image_matrix) VALUES (4, '{0, 0}');

INSERT INTO georefs(id_georefs, user_georef, date, georef_principal, footprint, near, far, id_transfo2d, id_interne, id_externe, id_images) VALUES (4, 'ama4', '2016-06-22 19:10:25-07', TRUE, ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), ST_GeomFromText('POLYGON((50.6373 3.0750,50.6374 3.0750,50.6374 3.0749,50.63 3.07491,50.6373 3.0750))', 2154), 4, 4, 4, 4);

SELECT modify_georefs(id_georefs => 1, user_georef => '''AMAMAA''', georef_principal => True);

SELECT modify_georefs(id_georefs => 4, user_georef => '''AMAAMA''', footprint => '''POLYGON((0 0,0 0,0 0,0 0,0 0))''',
					 epsg => 2154);