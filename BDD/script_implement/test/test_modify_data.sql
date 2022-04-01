--INSERT INTO masks(id_masks, url) VALUES (4, 'pouet4');

--INSERT INTO sources(id_sources, credit, home, url, viewer, thumbnail, lowres, highres, iip, footprint) VALUES (4, 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', 'mi4', ST_GeomFromText('MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2,2 3,3 3,3 2,2 2)),((6 3,9 2,9 4,6 3)))', 2154));

--INSERT INTO images(id_images, t0, t1, image, size_image, id_sources, id_masks) VALUES (4, '2016-06-22 19:10:25-07', '2016-06-22 19:10:25-07', 'pouet4', ST_GeomFromText('POINT(0 0)', 2154), 4, 4);
--INSERT INTO points_appuis(id_points_appuis, point_2d, point_3d, id_images) VALUES (4, ST_GeomFromText('POINT(0 0)', 2154), ST_GeomFromText('POINTZ(0 0 0)', 2154), 4);

SELECT modify_points_appuis(-1, 'POINT(0 0)', 'POINTZ(0 0 0)', 2154);
SELECT modify_points_appuis(1, 'POINT(1 1)', 'POINTZ(1 1 1)', 2154);