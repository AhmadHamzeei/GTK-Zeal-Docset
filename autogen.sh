#!/bin/sh

sysdocpath="/usr/share/gtk-doc/html"
docpath="/Contents/Resources/Documents"

echo "Generating gtk3 docset..."
mkdir -p GTK3.docset${docpath}
cp -r ${sysdocpath}/gtk3/* GTK3.docset${docpath}
sed -i 's_/usr/share/gtk-doc/html/glib_../../../../GLib.docset/Contents/Resources/Documents_g' GTK3.docset${docpath}/*.html
sed -i 's_/usr/share/gtk-doc/html/gio_../../../../GIO.docset/Contents/Resources/Documents_g' GTK3.docset${docpath}/*.html
sed -i 's_/usr/share/gtk-doc/html/gobject_../../../../GObject.docset/Contents/Resources/Documents_g' GTK3.docset${docpath}/*.html
sed -i 's_/usr/share/gtk-doc/html/atk_../../../../ATK.docset/Contents/Resources/Documents_g' GTK3.docset${docpath}/*.html
sed -i 's_/usr/share/gtk-doc/html/pango_../../../../Pango.docset/Contents/Resources/Documents_g' GTK3.docset${docpath}/*.html
sed -i 's_/usr/share/gtk-doc/html/cairo_../../../../Cairo.docset/Contents/Resources/Documents_g' GTK3.docset${docpath}/*.html

echo "Generating gtk2 docset..."
mkdir -p GTK2.docset${docpath}
cp -r ${sysdocpath}/gtk2/* GTK2.docset${docpath}
sed -i 's_http://library.gnome.org/devel/glib/unstable_../../../../GLib.docset/Contents/Resources/Documents_g' GTK2.docset${docpath}/*.html
sed -i 's_http://library.gnome.org/devel/gio/unstable_../../../../GIO.docset/Contents/Resources/Documents_g' GTK2.docset${docpath}/*.html
sed -i 's_http://library.gnome.org/devel/gobject/unstable_../../../../GObject.docset/Contents/Resources/Documents_g' GTK2.docset${docpath}/*.html

echo "Generating glib docset..."
mkdir -p GLib.docset${docpath}
cp -r ${sysdocpath}/glib/* GLib.docset${docpath}

echo "Generating gio docset..."
mkdir -p GIO.docset${docpath}
cp -r ${sysdocpath}/gio/* GIO.docset${docpath}

echo "Generating gobject docset..."
mkdir -p GObject.docset${docpath}
cp -r ${sysdocpath}/gobject/* GObject.docset${docpath}

echo "Generating atk docset..."
mkdir -p ATK.docset${docpath}
cp -r ${sysdocpath}/atk/* ATK.docset${docpath}
sed -i 's_/usr/share/gtk-doc/html/glib_../../../../GLib.docset/Contents/Resources/Documents_g' ATK.docset${docpath}/*.html
sed -i 's_/usr/share/gtk-doc/html/gobject_../../../../GObject.docset/Contents/Resources/Documents_g' ATK.docset${docpath}/*.html

echo "Generating pango docset..."
mkdir -p Pango.docset${docpath}
cp -r ${sysdocpath}/pango/* Pango.docset${docpath}

echo "Generating cairo docset..."
mkdir -p Cairo.docset${docpath}
cp -r ${sysdocpath}/cairo/* Cairo.docset${docpath}

echo "Generating docset databases..."
python3 docsetgen.py
