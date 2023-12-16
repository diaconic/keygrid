/* DrawLayout.vala
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

public enum CardLayout {
    KEYBOARD = 0,
    GRID = 1
}

public class LayoutRenderer : Object {
    private static GLib.Once<LayoutRenderer> _instance;
    public static unowned LayoutRenderer get_default() {
        return _instance.once(() => { return new LayoutRenderer(); });
    }

    public static Gee.ArrayList<char> whitelist;
    public const char[] static_whitelist = {
        'a','b','c','d','e','f','g','h','i','j','k','l','m','n','p','q','r','t',
        'A','B','C','D','E','F','G','H','I','J','K','L','M','N','P','Q','R','T',
        '0','1','2','3','4','5','6','7','8','9','!','?','(',')','[',']','$','+',
        '=','_','{','}','%','#','@'
    };

    static construct {
        whitelist = new Gee.ArrayList<char>();
        whitelist.add_all_array(LayoutRenderer.static_whitelist);
    }

    [CCode(has_target = false)]
    public delegate Gdk.Pixbuf? LayoutDrawFunc(Rand rand);

    public LayoutDrawFunc draw_keyboard = (rand) => {
        try {
            var data = (string) resources_lookup_data("/xyz/roxwize/keygrid/ui/ly_keyboard.svg", ResourceLookupFlags.NONE).get_data();
            char[] keyboard_chars = {'q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m'};

            var key = "";
            for (int i = 0; i < 8; i++) {
                key = key.concat(whitelist[rand.int_range(0, whitelist.size)].to_string());
            }
            data = data.replace("@key@", key);
            for (int i = 0; i < keyboard_chars.length; i++) {
                char rand_char = whitelist[rand.int_range(0, whitelist.size)];
                data = data.replace(@"@k$i@", keyboard_chars[i].to_string());
                data = data.replace(@"@$i@", rand_char.to_string());
            }

            var handle = new Rsvg.Handle.from_data((uint8[]) (data.to_utf8()));
            return handle.get_pixbuf();
        } catch (Error e) {
            warning(e.message);
            return null;
        }
    };

    public LayoutDrawFunc draw_grid = (rand) => {
        try {
            var data = (string) resources_lookup_data("/xyz/roxwize/keygrid/ui/ly_grid.svg", ResourceLookupFlags.NONE).get_data();

            Gee.ArrayList<char> header_whitelist;
            if (whitelist.size < 43) header_whitelist = new Gee.ArrayList<char>.wrap(LayoutRenderer.static_whitelist);
            else header_whitelist = whitelist;

            var alreadyAdded = new Gee.HashMap<char, bool>();
            var header = "";
            for (int _ = 0; _ < 43; _++) {
                var idx = rand.int_range(0, header_whitelist.size);
                header += header_whitelist[idx].to_string();
                header_whitelist.remove_at(idx);
            };
            data = data.replace("@h@", header);

            for (int i = 0; i < 8; i++) {
                var res = "";
                for (int _ = 0; _ < 43; _++) res += whitelist[rand.int_range(0, whitelist.size)].to_string();
                data = data.replace(@"@$i@", res);
                print("%i done\n", i);
            }

            var handle = new Rsvg.Handle.from_data((uint8[]) (data.to_utf8()));
            return handle.get_pixbuf();
        } catch (Error e) {
            warning(e.message);
            return null;
        }
    };
}