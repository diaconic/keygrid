/* MainWindow.vala
 *
 * Copyright 2023 roxwize
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

[GtkTemplate(ui="/xyz/roxwize/keygrid/ui/main.ui")]
public class Keygrid.MainWindow : Gtk.ApplicationWindow {
    private Rand random;
    private Settings settings;
    private LayoutRenderer layout_renderer = LayoutRenderer.get_default();

    public Gee.HashMap<int, LayoutRenderer.LayoutDrawFunc> drawing_functions;

    [GtkChild]
    public unowned Gtk.HeaderBar header;
    [GtkChild]
    public unowned Gtk.Overlay container;
    [GtkChild]
    public unowned Gtk.SpinButton seed_entry;
    [GtkChild]
    public unowned Gtk.DropDown type_dropdown;
    [GtkChild]
    public unowned Gtk.Picture card;
    public Granite.Toast toast;

    private uint32 seed;

    public SimpleActionGroup actions;
    private const ActionEntry[] ACTION_ENTRIES = {
        { "save_card", action_save_card },
        { "generate_card", action_generate_card },
        { "refresh_seed", action_refresh_seed }
    };

    public MainWindow(Application app) {
        Object(
            application: app,
            resizable: false,
            title: "Keygrid"
        );
    }

    construct {
        drawing_functions = new Gee.HashMap<int, LayoutRenderer.LayoutDrawFunc>();
        drawing_functions[CardLayout.KEYBOARD] = layout_renderer.draw_keyboard;
        drawing_functions[CardLayout.GRID] = layout_renderer.draw_grid;

        actions = new SimpleActionGroup();
        actions.add_action_entries(ACTION_ENTRIES, this);
        insert_action_group("win", actions);

        action_refresh_seed();

        settings = new Settings("xyz.roxwize.keygrid");
        type_dropdown.set_selected(settings.get_enum("card-type"));
        type_dropdown.notify["selected-item"].connect(() => {
            settings.set_enum("card-type", (int) type_dropdown.get_selected());
        });

        header.add_css_class(Granite.STYLE_CLASS_FLAT);

        toast = new Granite.Toast("");
        container.add_overlay(toast);
    }

    public void action_save_card() {
        debug("Save card action called\n");
        var dialog = new Gtk.FileChooserNative(
            "Save card...", this, Gtk.FileChooserAction.SAVE,
            "Save", "Cancel"
        );
        dialog.show();
        dialog.response.connect(() => {
            var path = dialog.get_file().get_path();
            ((Gdk.Texture) card.get_paintable()).save_to_png(path);
            show_toast(_("Saved to %s!".printf(path)));
        });
    }

    public void action_generate_card() {
        var in_seed = seed_entry.get_value_as_int();
        random = new Rand.with_seed(in_seed);
        seed = in_seed;
        card.set_paintable(null);
        
        Gdk.Pixbuf texture;
        var sel = (int) type_dropdown.get_selected();
        var func = drawing_functions[sel];
        if (func != null) {
            texture = func(random);
            if (texture == null) {
                warning("Failed to render the card! Check the output log for details.");
                show_toast(_("Rendering the card failed. If you are running this through a terminal, check the output logs."));
                return;
            }
            card.set_paintable(Gdk.Texture.for_pixbuf(texture));
            this.queue_draw();
        }
        else {
            warning("%i is not a valid function index", sel);
            show_toast(_("Some sort of error occurred, the card type can't be found. Make sure your configuration is correct, or file an issue in the GitHub repository."));
        };
    }

    public void action_refresh_seed() {
        seed = Gdk.CURRENT_TIME + ((new Rand().next_int()) - (uint32.MAX / 2));
        random = new Rand.with_seed(seed);
        seed_entry.set_value((double) seed);
    }

    public void show_toast(string contents) {
        toast.title = contents;
        toast.send_notification();
    }
}