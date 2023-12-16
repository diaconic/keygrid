project(
  'xyz.roxwize.keygrid',
  'vala', 'c',
  version: '0.1'
)

gnome = import('gnome')
i18n = import('i18n')

add_project_arguments(
  '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
  language: 'c'
)

resources = gnome.compile_resources(
  'keygrid-resources',
  'data' / meson.project_name() + '.gresource.xml',
  source_dir: 'data'
)

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true
)

sources = files(
  'src' / 'Views' / 'HelpView.vala',
  'src' / 'Application.vala',
  'src' / 'LayoutRenderer.vala',
  'src' / 'MainWindow.vala'
)

executable(
  meson.project_name(),
  sources + resources,
  dependencies: [
    dependency('librsvg-2.0'),
    dependency('gtk4'),
    dependency('granite-7')
  ],
  install: true
)

subdir('data')
subdir('po')
