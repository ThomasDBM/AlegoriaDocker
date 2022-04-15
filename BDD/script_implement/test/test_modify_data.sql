/*
    Tests for the modify functions
*/

-- Test 1 : tests on the modify_points_appuis function

INSERT INTO masks(id_masks, url) VALUES (4, 'pouet4');
INSERT INTO sources(id_sources, credit, home, url, viewer, thumbnail, lowres, highres, iip, footprint) VALUES (4, 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', ST_GeomFromText('MULTIPOLYGON(((752575.7 6963855.9,752833.3 6963957.4,752956.6 6963993.8,752976 6963992.4,753003.6 6963933.6,753108.1 6963903.4,753125.8 6963906.2,753310.3 6963935.7,754307.9 6963675.1,754374.4 6963630,754437.5 6963553.4,754527.6 6963423.3,754581.4 6963318.6,754621.9 6963397.8,754737.2 6963578.7,754739.2 6963149.8,754743.2 6963015.7,754752.3 6962984.8,755003.1 6962663.2,755220.5 6962492.1,755360.9 6962023.7,755411.2 6961972.4,755484.9 6961830,755745.4 6961975.3,756032.1 6962110.5,756694.6 6961532,756663.3 6961479,756663.3 6961392.9,756630.1 6961314.7,756747.2 6961107.9,756815.2 6961007.3,756925.2 6960803.6,757032.5 6960694.1,757027.9 6960640.4,757033.7 6960620.4,757125.1 6960535.7,757171.1 6960470.9,757115.5 6960355.3,757091 6960260.1,756911.6 6959785,756816.8 6959578,756787.4 6959481.2,756809.2 6959461.3,756907.2 6959432.4,757076.1 6959361.8,757437.4 6959245.5,757517.1 6959186.5,757591.6 6959091.9,757691.9 6958814.2,757835.8 6958557.6,757866.1 6958487.4,757737.6 6958445.8,757726.9 6958433.6,757790.7 6958298.3,757678.1 6958271.8,757523.7 6958264.9,757378.7 6958330.5,757184.2 6958396,756917.3 6958161.7,756712 6957967.3,756704.5 6958128.4,756639 6958063.3,756618.5 6958068.4,756492.3 6957832.6,756409.1 6957848.1,756406.3 6957808.4,756396.7 6957791.4,756352.7 6957742,756328.4 6957727.3,755930.8 6958528.3,755734.7 6958870.6,755700 6958910.9,755643.7 6959017.4,755412.7 6959209.2,754472.2 6959508.8,754297.6 6959597.2,754275.1 6959634.7,754301 6959655.3,753905.5 6961031,753289.7 6961433.8,753185.6 6962200.9,752915.9 6962782.3,752969.9 6962959,752567.5 6962988.1,752594.9 6963091.7,752614.2 6963252.6,752594.4 6963362.5,752545.3 6963464.8,752540.5 6963489.3,752605 6963495.9,752590.6 6963777.3,752575.7 6963855.9)))', 2154));
INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES (4, '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', 'pouet4', ST_GeomFromText('POINT(0 0)', 2154), 4, 4);
INSERT INTO points_appuis(id_points_appuis, point_2d, point_3d, id_images) VALUES (4, ST_GeomFromText('POINT(0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 4);

SELECT modify_points_appuis(-1, '''POINT(0 0)''', '''POINTZ(0 0 0)''', 2154);
SELECT modify_points_appuis(1, '''POINT(0 0)''', '''POINTZ(0 0 0)''', 215);
SELECT modify_points_appuis(1, '''POINT(2 2)''', '''POINTZ(2 2 2)''', 2154);

-- Test 2 : tests on the modify_georefs function

INSERT INTO interne(id_interne, pp, focal, skew, distorsion) VALUES (4, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 0, '{0, 0}');
INSERT INTO externe(id_externe, point, quaternion, srid) VALUES (4, ST_GeomFromText('POINTZ(0 0 0)', 2154), ST_GeomFromText('POINTZM(0 0 0 0)', 2154), 2154);
INSERT INTO transfo2d(id_transfo2d, image_matrix) VALUES (4, '{0, 0}');
INSERT INTO georefs(id_georefs, user_georef, date, georef_principal, footprint, near, far, id_transfo2d, id_interne, id_externe, id_images) VALUES (4, 'ama4', '2016-06-22 19:10:25-07', TRUE, ST_GeomFromText('MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3)))', 2154), 4, 4, 4, 4);

SELECT modify_georefs(id_georefs => 1, user_georef => '''AMAMAA''', georef_principal => True);

SELECT modify_georefs(id_georefs => 4, user_georef => '''AMAAMA''', footprint => '''MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((0 0,0 0,0 0,0 0)))''',
					 epsg => 2154);
					 
-- Test 3 : tests on the modify_images function

SELECT modify_images(id_images => 1);

SELECT modify_images(id_images => 4, image => '''mimimimimi''');

-- Test 4 : tests on the modify_transfo2d function

SELECT modify_transfo2d(id_transfo2d => 0);

SELECT modify_transfo2d(id_transfo2d => 4, image_matrix => '''{1, 1}''');

-- Test 5 : tests on the modify_externe function

SELECT modify_externe(id_externe => 0);

SELECT modify_externe(id_externe => 4);

SELECT modify_externe(id_externe => 4, quaternion => '''POINTZM(0 0 0 0)''', srid => 2154);

-- Test 6 : tests on the modify_interne function

SELECT modify_interne(id_interne => 0), modify_interne(id_interne => 4);
SELECT modify_interne(id_interne => 4, skew => 1.4, distorsion => '''{2, 2}''');

-- Test 7 : tests on the modify_sources function

SELECT modify_sources(id_sources => 0), modify_sources(id_sources => 4);
SELECT modify_sources(id_sources => 4, credit => '''TestByAma''', url => '''UneURL''');

-- Test 8 : tests on the modify_masks function

SELECT modify_masks(id_masks => 0), modify_masks(id_masks => 4, url => '''UneURLAuHasardTESTS''');





