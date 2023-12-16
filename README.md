# Keygrid

Keygrid is a tool that lets you make and save password cards.

Work in progress; not production-ready yet.

![Screenshot](/data/screenshot1.png)

## Building

Keygrid requires the following dependencies:

- `librsvg-2.0`
- `gtk4`
- `granite-7`

Start by generating the build directory, then navigate into it and build.

```
meson build
cd build
ninja
```

Then run `ninja install` to install the software locally, then run `xyz.roxwize.keygrid` to build.
