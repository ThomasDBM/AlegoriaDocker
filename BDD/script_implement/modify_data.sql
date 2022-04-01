-- If the extension does not exist, we create it
CREATE EXTENSION IF NOT EXISTS plpython3u;

/*
    Parameters for the 
    ...

    Attributes
    ----------
    tablename : char
        name of the table to remove
    id : int
        id of the data to remove

    Methods
    -------
    A data is modify
*/

CREATE OR REPLACE FUNCTION modify_georefs(id_georefs int DEFAULT -1, user_georef char DEFAULT '', date char DEFAULT '', georef_principal bool DEFAULT False, 
										  footprint char DEFAULT '', near char DEFAULT '', far char DEFAULT '', id_transfo2d int DEFAULT -1,
										 id_interne int DEFAULT -1, id_externe int DEFAULT -1, id_images int DEFAULT -1)
  RETURNS char
AS $$
	if id_georefs > -1:
		if user_georef != '':
			plpy.execute('UPDATE georefs SET user_georef = ' + user_georef)
	return 'Nothing to change or wrong id'
$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION modify_points_appuis(id_points_appuis int DEFAULT -1, point2d char DEFAULT '', point3d char DEFAULT '', epsg int DEFAULT 0)
  RETURNS char
AS $$
	if id_points_appuis > -1:
		if (point2d and point3d) != '':
			plpy.execute('UPDATE points_appuis SET point_2d = ST_GeomFromText(' + point2d + ', ' + str(epsg) + '), point_3d = ST_GeomFromText(' + point3d + ', ' + str(epsg) + ')')
			return 'All points change'
		if point2d != '' and epsg == (2154 or 4978):
			plpy.execute('UPDATE points_appuis SET point_2d = ST_GeomFromText(' + point2d + ', ' + str(epsg) + ')')
			return 'Change of 2d support points'
		if point3d != '' and epsg == (2154 or 4978):
			plpy.execute('UPDATE points_appuis SET point_3d = ST_GeomFromText(' + point3d + ', ' + str(epsg) + ')')
			return 'Change of 2d support points'
		return 'This SRID is not supported. The accepted SRIDs are 2154 and 4978'
	else :
		return 'No id specify'
	return 'Nothing to change or wrong id'
$$ LANGUAGE plpython3u;
