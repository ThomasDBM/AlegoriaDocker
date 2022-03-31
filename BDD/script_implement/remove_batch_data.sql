CREATE EXTENSION IF NOT EXISTS plpython3u;

CREATE OR REPLACE FUNCTION remove_batch_data(tablename char, id int)
  RETURNS char
AS $$
	if tablename == 'sources':
	
		id_images = plpy.execute('SELECT id_images FROM images WHERE id_'+ tablename + ' = ' + str(id))
		count_id = plpy.execute('SELECT COUNT(id_images) FROM images WHERE id_'+ tablename + ' = ' + str(id))
		
		plpy.notice(id_images.__str__())
		
		for i in range(0, count_id, 1):
			plpy.execute('DELETE FROM points_appuis WHERE id_images = ' + id_images[i]['id_images'])
			plpy.execute('DELETE FROM georefs WHERE id_images = ' + id_images[i]['id_images'])
			plpy.execute('DELETE FROM images WHERE id_images = ' + id_images[i]['id_images'])
		
		plpy.execute('DELETE FROM ' + tablename + ' WHERE id_'+ tablename + ' = ' + str(id))
		return 'The sources table has a dedicated batch delete function'
	return 'The function only work with the sources table'
$$ LANGUAGE plpython3u;
