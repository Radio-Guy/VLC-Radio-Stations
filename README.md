# VLC Radio Stations

Various Radio Stations (and their various substations) as VLC Service Disovery addon (lua script):
* SomaFM - https://somafm.com/
* Rad(io) Cap(rice) - http://www.radcap.ru/
* FIP (France Inter Paris) - https://www.radiofrance.fr/fip

Icon view:

<img src="gfx/screen01.png">
<img src="gfx/screen02.png">

List view:

<img src="gfx/screen03.png">

---
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

---
**BUGS & REQUESTS**:

Send me a message or open a ticket on github: https://github.com/Radio-Guy

---
**INSTALLATION**:

Put the sd_xxx.lua file into the according Service Discovery subfolder of the VLC lua directory, by default:
* Windows (all users): %ProgramFiles%\VideoLAN\VLC\lua\sd\
* Windows (current user): %APPDATA%\VLC\lua\sd\
* Linux (all users): /usr/lib/vlc/lua/sd/
* Linux (current user): ~/.local/share/vlc/lua/sd/

Put the pl_xxx.lua file(s) into the according Playlist subfolder of the VLC lua directory, by default:
* Windows (all users): %ProgramFiles%\VideoLAN\VLC\lua\pl\
* Windows (current user): %APPDATA%\VLC\lua\pl\
* Linux (all users): /usr/lib/vlc/lua/pl/
* Linux (current user): ~/.local/share/vlc/lua/pl/

You will need to place both the sd_xxx.lua as well as the pl_xxx.lua files for this addon to work.

Create the directories if they don't exist.

Restart VLC.

---
**EXPLANATION & USAGE**:

* This Service Discovery is available on the left panel of VLC under "Internet" >> ""Radio Stations ++"
* Each radio station offers several substations, various formats and sometimes several streaming servers.
* If you are in thumbnail view, you will receive some nice and convenient station icons.
