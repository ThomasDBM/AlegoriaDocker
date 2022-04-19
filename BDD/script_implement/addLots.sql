CREATE OR REPLACE FUNCTION public.addlots(files char[], attributessources char[])
	RETURNS char
AS $$
	import xml.etree.ElementTree as ET
	import time
	from datetime import datetime
	attributesSourceValue = '('
	balisesname = []
	for i in range(len(attributessources)-1):
		attributesSourceValue = attributesSourceValue + "'" +str(attributessources[i])+ "'"  +','
	attributesSourceValue = attributesSourceValue +"'" +str(attributessources[-1])+ "'"  + ')'
	request = 'INSERT into sources(credit, home, url, viewer, thumbnail, lowres, highres, iip) VALUES {}'.format(attributesSourceValue)
	sourcesAdd = plpy.execute(request)
	
	elementImage = []
	for file in files :
	
		tree = ET.parse(file)
		root = tree.getroot()
		
		elementDate = [elem.text for elem in root.iter('date')]
		elementImage += [elem.text for elem in root.iter('image')]
		
		elementTimestamp = time.mktime(time.strptime(elementDate[0], " %d/%m/%Y %Hh:%Mm:%Ss:%f "))
			
	
	return elementTimestamp
$$ LANGUAGE plpython3u;
