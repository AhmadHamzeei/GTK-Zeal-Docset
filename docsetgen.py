import sqlite3
import gzip
import xml.etree.ElementTree as etree

docsets = [{'folder':'GTK3',    'devhelp':'gtk3'},
		   {'folder':'GTK2',    'devhelp':'gtk2'},
           {'folder':'GLib',    'devhelp':'glib'},
           {'folder':'GIO',     'devhelp':'gio'},
           {'folder':'GObject', 'devhelp':'gobject'},
           {'folder':'ATK',     'devhelp':'atk'},
           {'folder':'Pango',   'devhelp':'pango'},
           {'folder':'Cairo',   'devhelp':'cairo'},]

types = {'enum':'Enum', 'function':'Function', 'macro':'Macro', 'property':'Property', 'constant':'Constant',
         'signal':'Event', 'struct':'Struct', 'typedef':'Define', 'union':'Union', 'variable': 'Variable', 'method': 'Method',
         'member': 'Field'}

dbpath = '{0}.docset/Contents/Resources/docSet.dsidx'
gzpath = '{0}.docset/Contents/Resources/Documents/{1}.devhelp2.gz'
dvpath = '{0}.docset/Contents/Resources/Documents/{1}.devhelp2'
insertsql = 'INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES (?,?,?)'

for docset in docsets:
	db = sqlite3.connect(dbpath.format(docset['folder']))
	cur = db.cursor()

	try: cur.execute('DROP TABLE searchIndex;')
	except: pass
	
	cur.execute('CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);')
	cur.execute('CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);')
	
	try:
		xmlfile = gzip.open(gzpath.format(docset['folder'], docset['devhelp']))
	except FileNotFoundError:
		xmlfile = open(dvpath.format(docset['folder'], docset['devhelp']))

	tree = etree.parse(xmlfile)
	book = tree.getroot()
	
	subs = book.findall('.//{http://www.devhelp.net/book}sub')
	for sub in subs:
		cur.execute(insertsql, (sub.get('name'), 'Section', sub.get('link')))
		
	keywords = book.findall('.//{http://www.devhelp.net/book}keyword')
	for keyword in keywords:
		entry_name = keyword.get('name')
		if keyword.get('type'):
			try:
				entry_type = types[keyword.get('type')]
			except KeyError as e:
				print('Warning: ' + str(e) + ' is not a known type, defaulting to \'Section\'')
				print('         to fix, add ' + str(e) + ' to the types dict with a value from https://kapeli.com/docsets#supportedentrytypes')
				entry_type = 'Section'
		entry_link = keyword.get('link')
		cur.execute(insertsql, (entry_name, entry_type, entry_link))
		
	db.commit()
	db.close()
	xmlfile.close()
