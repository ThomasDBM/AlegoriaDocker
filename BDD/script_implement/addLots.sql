CREATE OR REPLACE FUNCTION public.addlots(files char[], attributessources char[])
	RETURNS char
AS $$
	import xml.etree.ElementTree as ET
	import time
	import datetime
	attributesSourceValue = '('
	balisesname = []
	for i in range(len(attributessources)-1):
		attributesSourceValue = attributesSourceValue + "'" +str(attributessources[i])+ "'"  +','
	attributesSourceValue = attributesSourceValue +"'" +str(attributessources[-1])+ "'"  + ')'
	request = 'INSERT into sources(credit, home, url, viewer, thumbnail, lowres, highres, iip) VALUES {}'.format(attributesSourceValue)
	sourcesAdd = plpy.execute(request)
	elementDate = []
	elementImage = []
	for file in files :
		tree = ET.parse(file)
		root = tree.getroot()
		
		elementDate = elem.text for elem in root.iter('mission')
		elementTimestamp = time.mktime(time.strptime('2015-10-20 22:24:46', '%Y-%m-%d %H:%M:%S'))
		elementImage += [elem.text for elem in root.iter('image')]
			
	
	return elementDate
$$ LANGUAGE plpython3u;
