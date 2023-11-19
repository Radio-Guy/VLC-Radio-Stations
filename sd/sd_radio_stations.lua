--[[
 VLC Radio Stations ++ Add-on (v0.66)
 Various Radio Stations (and their various substations) as VLC Service Discovery addon (lua script):

 SomaFM - https://somafm.com/
 FluxFM - https://www.fluxfm.de/
 FluxFM (beyond) - https://streams.fluxfm.de/
 Rad(io) Cap(rice) - http://www.radcap.ru/
 FIP (France Inter Paris) - https://www.radiofrance.fr/fip

--- BUGS & REQUESTS: ---
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.

Send me a message or open a ticket on github: https://github.com/Radio-Guy/VLC-Radio-Stations


--- INSTALLATION ---:

Put the sd_xxx.lua file into the according Service Discovery subfolder of the VLC lua directory—by default:
* Windows (all users): %ProgramFiles%\VideoLAN\VLC\lua\sd\
* Windows (current user): %APPDATA%\VLC\lua\sd\
* Linux (all users): /usr/lib/x86_64-linux-gnu/vlc/lua/sd/
* Linux (current user): ~/.local/share/vlc/lua/sd/

Put the pl_xxx.lua files into the according Playlist subfolder of the VLC lua directory—by default:
* Windows (all users): %ProgramFiles%\VideoLAN\VLC\lua\playlist\
* Windows (current user): %APPDATA%\VLC\lua\playlist\
* Linux (all users): /usr/lib/x86_64-linux-gnu/vlc/lua/playlist/
* Linux (current user): ~/.local/share/vlc/lua/playlist/

You will need to place both the sd_xxx.lua as well as the pl_xxx.lua files for this addon to work.

Create the directories if they don't exist.

Restart VLC.


--- EXPLANATION & USAGE ---:

* This Service Discovery is available on the left panel of VLC under "Internet" >> ""Radio Stations ++"
* Each radio station offers several substations, various formats and sometimes several streaming servers.
* Activate the *Album* and *Description* columns in VLC—they will hold some valuable information, e.g. a popularity to sort on for SomaFM. 
* If you are in thumbnail view, you will receive some nice and convenient station icons. They will however only appear once you entered into the main station. Also, substation thumbnails for SomaFM are buggy and not displayed anymore—if anyone can resolve this bug, please contact me on Github.

--]]

function descriptor()
	return { title="Radio Stations ++",
		description = "Radio Stations (Service Discovery)",
		version = "0.66",
		capabilities = {}
	}
end

function main()
	vlc.sd.add_item( {title = "SomaFM", path = "https://somafm.com/listen/listeners.html", arturl = "https://raw.githubusercontent.com/Radio-Guy/VLC-Radio-Stations/main/gfx/SomaFM_Logo.png"} )
	vlc.sd.add_item( {title = "FluxFM", path = "https://archiv.fluxfm.de/radio-livestream/", arturl = "https://raw.githubusercontent.com/Radio-Guy/VLC-Radio-Stations/main/gfx/fluxfm.jpg"} )
	vlc.sd.add_item( {title = "FluxFM (beyond)", path = "https://streams.fluxfm.de/", arturl = "https://raw.githubusercontent.com/Radio-Guy/VLC-Radio-Stations/main/gfx/fluxfm_beyond.jpg"} )
	vlc.sd.add_item( {title = "RAD(io) CAP(rice)", path = "http://radcap.ru/index-d.html", arturl = "https://raw.githubusercontent.com/Radio-Guy/VLC-Radio-Stations/main/gfx/radcap_Logo.png"} )
	vlc.sd.add_item( {title = "FIP (France Inter Paris)", path = "https://www.radiofrance.fr/fip/api/live/webradios", arturl = "https://raw.githubusercontent.com/Radio-Guy/VLC-Radio-Stations/main/gfx/FIP_Logo.png"} )
end
--#
