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
	if tablename == 'sources':
	
		id_images = plpy.execute('SELECT id_images FROM images WHERE id_'+ tablename + ' = ' + str(id))
		count_id = plpy.execute('SELECT COUNT(id_images) AS tot FROM images WHERE id_'+ tablename + ' = ' + str(id))
		
		plpy.notice(id_images.__str__())
		plpy.notice(count_id.__str__())

		for i in range(0, count_id[0]['tot'], 1):
			plpy.execute('DELETE FROM points_appuis WHERE id_images = ' + str(id_images[i]['id_images']))
			plpy.execute('DELETE FROM georefs WHERE id_images = ' + str(id_images[i]['id_images']))
			plpy.execute('DELETE FROM images WHERE id_images = ' + str(id_images[i]['id_images']))
		
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return 'The source table has been deleted, along with the associated data set'
		
	if tablename == ('masks' or 'transfo2d' or 'externe' or 'interne' or 'points_appuis' or 'images' or 'georefs'):
		return 'The function only work with the sources table'
	return 'You must use the sources table with this function'
$$ LANGUAGE plpython3u;
