/* Application.vala
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

public class Keygrid.Application : Gtk.Application {
    private MainWindow window;

    private const ActionEntry[] ACTION_ENTRIES = {
        { "quit", quit },
        { "display_about", action_display_about },
        { "display_help", action_display_help }
    };

    public Application() {
        Object(
            application_id: "xyz.roxwize.keygrid",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    construct {
        add_action_entries(ACTION_ENTRIES, this);
        set_accels_for_action("app.quit", { "<primary>q" });
        set_accels_for_action("win.save_card", { "<primary>s" });
    }

    public override void activate() {
        if (window == null) window = new MainWindow(this);
        window.present();
        window.action_generate_card();
    }

    public static int main(string[] args) {
        return new Keygrid.Application().run(args);
    }

    public void action_display_about() {
        var about = new Gtk.AboutDialog() {
            program_name = "Keygrid",
            authors = { "roxwize", "GitHub and Sourcehut contributors" },
            comments = _("The \"Keyboard\" layout is adapted from https://qwertycards.com/. If you like the concept, consider buying a card from there."),
            version = "1.0.0",
            website = "https://roxwize.xyz/site/keygrid.html",
            website_label = _("Keygrid Website"),
            license_type = Gtk.License.GPL_3_0,
            transient_for = window
        };
        about.present();
    }

    public void action_display_help() {

    }
}
