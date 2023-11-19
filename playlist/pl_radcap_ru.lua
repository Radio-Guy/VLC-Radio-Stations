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

function proper_name(name)
	return string.lower(name):gsub("<[^>]->", ""):gsub("/", " / "):gsub("[%c%s ]+", " "):gsub("&amp;", "&"):gsub("[^%l]%l", string.upper):gsub("^%l", string.upper)
end

function probe()
	return (( vlc.access == "http" or vlc.access == "https" )
	and string.match(vlc.path, "radcap%.ru/[^/]+html")
	)
end

function parse()
	local tracks = {}
	local site = vlc.access .. "://" .. vlc.path:match( '^[^/]+' .. "/")

	local html = nil
	while ( nil == html ) do
		html = vlc.read(1000000)
	end

	if html:match( '<a href="[^"]+" class="genres.-</span></a>' ) then
		for genre in html:gmatch '<a href="[^"]+" class="genres.-</span></a>' do
			table.insert( tracks, {
				path = site .. genre:match( 'href="(.-)"' ), 
				title = proper_name(genre:match( '<a href[^>]->(.-)<span' )),
				arturl = site .. genre:match( 'src="(.-)"' )
			} )
		end
	else
		if html:match( '[%d]+%.[%d]+%.[%d]+%.[%d]+:%d-/[^"]+"' ) then
			local pic = site .. html:match( 'stylegraf/[%w%-%.]+' )
			local name = "RAD(io) CAP(rice): " .. proper_name( html:match( '<h1 class="station station%-signal">(.-)</h1>' ) )
			local i = 0
			for server in html:gmatch '([%d]+%.[%d]+%.[%d]+%.[%d]+:%d-/[^"]+)"' do
				i = i + 1
				if 1 == i then
					table.insert( tracks, {
						path = "http://" .. server,
						title = "AAC+ / 48 kbps / 22,050 Hz",
						album = name,
						arturl = pic
					} )
				elseif 2 == i then
					table.insert( tracks, {
						path = "http://" .. server,
						title = "AAC-LC / 256 kbps / 44,100 Hz",
						album = name,
						arturl = pic
					} )
				end
			end
		end
	end

	return tracks
end