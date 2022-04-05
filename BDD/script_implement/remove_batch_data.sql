-- If the extension does not exist, we create it
CREATE EXTENSION IF NOT EXISTS plpython3u;

/*
    Parameters for the remove_batch_data function
    ...

    Attributes
    ----------
    tablename : char
        name of the table to remove
    id : int
        id of the batch of data to remove

    Methods
    -------
    A batch of data is removed from the database, as well as its dependencies 
	The type of treatment will depend on the table to be deleted
*/
CREATE OR REPLACE FUNCTION remove_batch_data(tablename char, id int)
  RETURNS char
AS $$

	id_tot = plpy.execute('SELECT id_'+tablename+' FROM ' + tablename)
	count_id = plpy.execute('SELECT COUNT('+tablename+') AS tot FROM '+tablename)
	
	plpy.notice(id_tot.__str__())
	plpy.notice(count_id.__str__())
	
	tab = []
	for i in range(0, count_id[0]['tot'], 1):
		tab.append(str(id_tot[i]['id_'+tablename]))
	
	if str(id) in tab:
		if tablename == 'sources':

			id_images = plpy.execute('SELECT id_images FROM images WHERE id_'+ tablename + ' = ' + str(id))
			count_id = plpy.execute('SELECT COUNT(id_images) AS tot FROM images WHERE id_'+ tablename + ' = ' + str(id))

			plpy.notice(id_images.__str__())
			plpy.notice(count_id.__str__())

			for i in range(0, count_id[0]['tot'], 1):
				plpy.execute('DELETE FROM points_appuis WHERE id_images = ' + str(id_images[i]['id_images']))

				id_georefs = plpy.execute('SELECT id_georefs FROM georefs WHERE id_images = ' + str(id_images[i]['id_images']))
				count_id_georefs = plpy.execute('SELECT COUNT(id_georefs) AS tot FROM georefs WHERE id_images = ' + str(id_images[i]['id_images']))

				plpy.notice(id_georefs.__str__())
				plpy.notice(count_id_georefs.__str__())
				
				supp_int = []
				supp_ext = []
				supp_transfo2d = []
				for i in range(0, count_id_georefs[0]['tot'], 1):
					id_interne = plpy.execute('SELECT id_interne FROM georefs WHERE id_georefs = ' + str(id_georefs[i]['id_georefs']))
					id_externe = plpy.execute('SELECT id_externe FROM georefs WHERE id_georefs = ' + str(id_georefs[i]['id_georefs']))
					id_transfo2d = plpy.execute('SELECT id_transfo2d FROM georefs WHERE id_georefs = ' + str(id_georefs[i]['id_georefs']))
					return id_interne
					if id_interne[0]['id_interne'] not in supp_int:
						supp_int.append(id_interne[0]['id_interne'])
					if id_externe[0]['id_externe'] not in supp_ext:
						supp_ext.append(id_externe[0]['id_externe'])
					if id_transfo2d[0]['id_transfo2d'] not in supp_transfo2d:
						supp_ext.append(id_transfo2d[0]['id_transfo2d'])	
				--plpy.execute('DELETE FROM interne WHERE id_interne = ' + str(id_interne[0]['id_interne']))
				--plpy.execute('DELETE FROM externe WHERE id_externe = ' + str(id_externe[0]['id_externe']))
				--plpy.execute('DELETE FROM transfo2d WHERE id_transfo2d = ' + str(id_transfo2d[0]['id_transfo2d']))
				plpy.execute('DELETE FROM georefs WHERE id_images = ' + str(id_images[i]['id_images']))
				plpy.execute('DELETE FROM images WHERE id_images = ' + str(id_images[i]['id_images']))
				
			plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
			return 'The source table has been deleted, along with the associated data set'

		if tablename == ('masks' or 'transfo2d' or 'externe' or 'interne' or 'points_appuis' or 'images' or 'georefs'):
			return 'The function only work with the sources table'
	else :
		return 'Wrond id or wrong table'
$$ LANGUAGE plpython3u;
