-- If the extension does not exist, we create it
CREATE EXTENSION IF NOT EXISTS plpython3u;

/*
    Parameters for the modify_georefs function
    ...

    Attributes
    ----------
    id_georefs: int
        id of the table to modify
    user_georefs: char
        name of the user who created this georeferencing
	date : timestamp
		date of georefencing creation
	georef_principal: bool
		this is the principal georeferencing of an image or not
	footprint: char (WKT Polygon)
		footprint of the image referenced by the georeferencing
	epsg: int
		SRID of the geometry
	near: char (WKT Polygon)
		nearest polygon to the camera
	far: char (WKT Polygon)
		fathest polygon to the camera
	id_transfo2d: int
		id of the associated transfo_2d table
	id_interne: int
		id of the associated interne table
	id_externe: int
		id of the associated externe table
	id_images: int
		id of the associated images table
	
    Methods
    -------
    Replace data in the georefs table
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

/*
    Parameters for the modify_points_appuis function
    ...

    Attributes
    ----------
    id_points_appuis: int
        id of the table to modify
    point2d: char (WKT Point)
        2D support points of an image
	point3d: char (WKT PointZ)
		3D support points of an image
	epsg: int
		SRID of the geometry
	
    Methods
    -------
    Replace data in the points_appuis table
*/

CREATE OR REPLACE FUNCTION modify_points_appuis(id_points_appuis int DEFAULT -1, point2d char DEFAULT '', point3d char DEFAULT '', epsg int DEFAULT 0)
  RETURNS char
AS $$

	id_points_tot = plpy.execute('SELECT id_points_appuis FROM points_appuis')
	count_id = plpy.execute('SELECT COUNT(id_points_appuis) AS tot FROM points_appuis')
	
	plpy.notice(id_points_tot.__str__())
	plpy.notice(count_id.__str__())
	
	tab = []
	for i in range(0, count_id[0]['tot'], 1):
		tab.append(str(id_points_tot[i]['id_points_appuis']))
		
	if id_points_appuis > -1  and str(id_points_appuis) in tab:
		if (point2d and point3d) != '' and epsg == (2154 or 4978):
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
		return 'Id is not in the table'
	return 'Nothing to change'
$$ LANGUAGE plpython3u;

/*
    Parameters for the modify_images function
    ...

    Attributes
    ----------
    id_images: int
        id of the table to modify
    t0: timestamp
        start date of the image
	t1: timestamp
		end date of the image
	image: char
		unique id of an image
	size_image: char (WKT Point)
		size of the image
	id_sources:
		id of the associated sources table
	id_masks:
		id of the associated masks table
    Methods
    -------
    Replace data in the images table
*/

CREATE OR REPLACE FUNCTION modify_images(id_images int DEFAULT -1, t0 char DEFAULT '', t1 char DEFAULT '', image char DEFAULT '',
										 size_image char DEFAULT '', id_sources int DEFAULT -1, id_masks int DEFAULT -1)
  RETURNS char
AS $$

	id_images_tot = plpy.execute('SELECT id_images FROM images')
	count_id = plpy.execute('SELECT COUNT(id_images) AS tot FROM images')
	
	plpy.notice(id_images_tot.__str__())
	plpy.notice(count_id.__str__())
	
	tab = []
	for i in range(0, count_id[0]['tot'], 1):
		tab.append(str(id_images_tot[i]['id_images']))
		
	if id_images > -1  and str(id_images) in tab:
		if t0 != '':
			plpy.execute('UPDATE images SET t0 = ' + t0)
		if t1 != '':
			plpy.execute('UPDATE images SET t1 = ' + t1)
		if image != '':
			plpy.execute('UPDATE images SET image = ' + image)
		if size_image != '':
			plpy.execute('UPDATE images SET size_image = ST_GeomFromText(' + size_image + ', 2154')
		if id_sources > -1:
			plpy.execute('UPDATE images SET id_sources = ' + str(id_sources))
		if id_masks > -1:
			plpy.execute('UPDATE images SET id_masks = ' + str(id_masks))
		return 'All changes are done'
	else :
		return 'Id is not in the table'
	return 'Nothing to change'
$$ LANGUAGE plpython3u;

/*
    Parameters for the modify_transfo2d function
    ...

    Attributes
    ----------
    id_transfo2d: int
        id of the table to modify
    image_matrix: char (array of integer)
        image transformation matrix
	
    Methods
    -------
    Replace data in the transfo2d table
*/

CREATE OR REPLACE FUNCTION modify_transfo2d(id_transfo2d int DEFAULT -1, image_matrix char DEFAULT '{}')
  RETURNS char
AS $$

	id_transfo2d_tot = plpy.execute('SELECT id_transfo2d FROM transfo2d')
	count_id = plpy.execute('SELECT COUNT(id_transfo2d) AS tot FROM transfo2d')
	
	plpy.notice(id_transfo2d_tot.__str__())
	plpy.notice(count_id.__str__())
	
	tab = []
	for i in range(0, count_id[0]['tot'], 1):
		tab.append(str(id_transfo2d_tot[i]['id_transfo2d']))
		
	if id_transfo2d > -1  and str(id_transfo2d) in tab:
		if image_matrix != '{}':
			plpy.execute('UPDATE transfo2d SET image_matrix = ' + image_matrix)
		return 'All changes are done'
	else :
		return 'Id is not in the table'
	return 'Nothing to change'
$$ LANGUAGE plpython3u;

/*
    Parameters for the externe function
    ...

    Attributes
    ----------
    id_externe: int
        id of the table to modify
    point: char 
        center of the camera
	quaternion: char
		point use to create image_matrix
	srid:
		SRID of the geometry
	
    Methods
    -------
    Replace data in the externe table
*/

CREATE OR REPLACE FUNCTION modify_externe(id_externe int DEFAULT -1, point char DEFAULT '', quaternion char DEFAULT '', srid int DEFAULT 0)
  RETURNS char
AS $$

	id_externe_tot = plpy.execute('SELECT id_externe FROM externe')
	count_id = plpy.execute('SELECT COUNT(id_externe) AS tot FROM externe')
	
	plpy.notice(id_externe_tot.__str__())
	plpy.notice(count_id.__str__())
	
	tab = []
	for i in range(0, count_id[0]['tot'], 1):
		tab.append(str(id_externe_tot[i]['id_externe']))
		
	if id_externe > -1  and str(id_externe) in tab:
		if point != '' and srid != 0:
			plpy.execute('UPDATE externe SET point = ST_GeomFromText(' + point + ', ' + str(srid) + ')')
		if quaternion != '' and srid != 0:
			plpy.execute('UPDATE externe SET quaternion = ST_GeomFromText(' + quaternion + ', ' + str(srid) + ')')
		if srid != 0:
			plpy.execute('UPDATE externe SET srid = ' + str(srid))
		return 'All changes are done'
	else :
		return 'Id is not in the table'
	return 'Nothing to change'
$$ LANGUAGE plpython3u;

/*
    Parameters for the interne function
    ...

    Attributes
    ----------
    id_interne: int
        id of the table to modify
    pp: char 
        center of the camera
	focal: char
		point use to create image_matrix
	epsg:
		SRID of the geometry
	skew: float
		skew of the image
	
    Methods
    -------
    Replace data in the externe table
*/
CREATE OR REPLACE FUNCTION modify_interne(id_interne int DEFAULT -1, pp char DEFAULT '', focal char DEFAULT '', epsg int DEFAULT 0, skew float DEFAULT -1,
										 distorsion char DEFAULT '{}')
  RETURNS char
AS $$

	id_interne_tot = plpy.execute('SELECT id_interne FROM interne')
	count_id = plpy.execute('SELECT COUNT(id_interne) AS tot FROM interne')
	
	plpy.notice(id_interne_tot.__str__())
	plpy.notice(count_id.__str__())
	
	tab = []
	for i in range(0, count_id[0]['tot'], 1):
		tab.append(str(id_interne_tot[i]['id_interne']))
		
	if id_interne > -1  and str(id_interne) in tab:
		if pp != '' and epsg != 0:
			plpy.execute('UPDATE interne SET pp = ST_GeomFromText(' + pp + ', ' + str(epsg) + ')')
		if focal != '' and epsg != 0:
			plpy.execute('UPDATE interne SET focal = ST_GeomFromText(' + focal + ', ' + str(epsg) + ')')
		if skew != -1:
			plpy.execute('UPDATE interne SET skew = ' + str(skew))
		if distorsion != '{}':
			plpy.execute('UPDATE interne SET distorsion = ' + distorsion)
		return 'All changes are done'
	else :
		return 'Id is not in the table'
	return 'Nothing to change'
$$ LANGUAGE plpython3u;