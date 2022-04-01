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

CREATE OR REPLACE FUNCTION modify_georefs(id_georefs int DEFAULT -1, user_georef char DEFAULT '', date char DEFAULT '', georef_principal bool DEFAULT null, 
										  footprint char DEFAULT '', epsg int DEFAULT 0, near char DEFAULT '', far char DEFAULT '', id_transfo2d int DEFAULT -1,
										 id_interne int DEFAULT -1, id_externe int DEFAULT -1, id_images int DEFAULT -1)
  RETURNS char
AS $$

	id_georefs_tot = plpy.execute('SELECT id_georefs FROM georefs')
	count_id = plpy.execute('SELECT COUNT(id_georefs) AS tot FROM georefs')
	
	plpy.notice(id_georefs_tot.__str__())
	plpy.notice(count_id.__str__())
	
	tab = []
	for i in range(0, count_id[0]['tot'], 1):
		tab.append(str(id_georefs_tot[i]['id_georefs']))
	
	if id_georefs > -1 and str(id_georefs) in tab:
		return 'pouet'
		if user_georef != '':
			plpy.execute('UPDATE georefs SET user_georef = ' + user_georef)
		if date != '':
			plpy.execute('UPDATE georefs SET date = ' + date)
		if georef_principal is not None:
			plpy.execute('UPDATE georefs SET georef_principal = ' + str(georef_principal))
		if footprint != '' and epsg != 0:
			plpy.execute('UPDATE georefs SET footprint = ST_GeomFromText(' + footprint + ', ' + str(epsg) + ')')
		if near != '' and epsg != 0:
			plpy.execute('UPDATE georefs SET near = ST_GeomFromText(' + footprint + ', ' + str(epsg) + ')')	
		if far != '' and epsg != 0:
			plpy.execute('UPDATE georefs SET far = ST_GeomFromText(' + footprint + ', ' + str(epsg) + ')')
			
		return 'All changes done'
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
