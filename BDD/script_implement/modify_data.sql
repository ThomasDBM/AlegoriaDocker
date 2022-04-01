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

CREATE OR REPLACE FUNCTION modify_points_appuis(id_points_appuis int DEFAULT -1, point2d char DEFAULT '', point3d char DEFAULT '', epsg int DEFAULT 0)
  RETURNS char
AS $$
	if id_points_appuis > -1:
		if point2d != '' and epsg != 0:
			plpy.execute('UPDATE points_appuis SET point_2d = ST_GeomFromText(' + point2d + ', ' + str(epsg) + ')')
			return 'Changement des points appuis 2D'
		if point3d != '' and epsg != 0:
			plpy.execute('UPDATE points_appuis SET point_3d = ST_GeomFromText(' + point3d + ', ' + str(epsg) + ')')
			return 'Changement des points appuis 3D'
		return 'id of the data to change'
	else :
		return 'no id specify'
	return 'Nothing to change'
$$ LANGUAGE plpython3u;
