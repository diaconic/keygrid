i18n.merge_file(
        input: 'xyz.roxwize.keygrid.desktop.in',
       output: 'xyz.roxwize.keygrid.desktop',
         type: 'desktop',
       po_dir: '../po',
      install: true,
  install_dir: get_option('datadir') / 'applications'
)

i18n.merge_file(
        input: 'xyz.roxwize.keygrid.metainfo.xml.in',
       output: 'xyz.roxwize.keygrid.metainfo.xml',
       po_dir: '../po',
      install: true,
  install_dir: get_option('datadir') / 'metainfo'
)

install_data('xyz.roxwize.keygrid.gschema.xml',
  install_dir: get_option('datadir') / 'glib-2.0' / 'schemas'
)
