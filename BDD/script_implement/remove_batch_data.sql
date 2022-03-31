CREATE EXTENSION IF NOT EXISTS plpython3u;

CREATE OR REPLACE FUNCTION remove__batch_data(tablename char, id int)
  RETURNS char
AS $$
	if tablename == 'sources':
		return 'The sources table has a dedicated batch delete function'
	return 'The function only work with the sources table'
$$ LANGUAGE plpython3u;
