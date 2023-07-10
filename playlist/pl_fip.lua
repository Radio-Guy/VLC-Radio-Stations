--[[
 VLC Radio Stations ++ Add-on (v0.65)
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
* Linux (all users): /usr/share/vlc/lua/sd/
* Linux (current user): ~/.local/share/vlc/lua/sd/

Put the pl_xxx.lua files into the according Playlist subfolder of the VLC lua directory—by default:
* Windows (all users): %ProgramFiles%\VideoLAN\VLC\lua\playlist\
* Windows (current user): %APPDATA%\VLC\lua\playlist\
* Linux (all users): /usr/share/vlc/lua/playlist/
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

function probe()
	return (( vlc.access == "http" or vlc.access == "https" )
	and string.match(vlc.path, "^www%.radiofrance%.fr/api/v2%.0/stations/fip/webradios.-") 
	)
end

function parse()
	local tracks = {}

	if "www.radiofrance.fr/api/v2.0/stations/fip/webradios" == vlc.path then
		local html = vlc.read(100000)

		for js in html:gmatch '{"now":{"firstLine":.-}}' do
			table.insert( tracks, {
					path = vlc.access .. "://" .. vlc.path .. "/" .. js:match('"slug":"([^"]+)"'),
					title = js:match('"legend":"([^"]+)"'):gsub(" logo", " (live)"):gsub(" Webradio", ""):gsub(" FR", ""),
					arturl = "https://raw.githubusercontent.com/Radio-Guy/VLC-Radio-Stations/main/gfx/" .. js:match('"slug":"([^"]+)"') .. ".jpg"
			} )
		end
	elseif string.match(vlc.path, "www.radiofrance.fr/api/v2.0/stations/fip/webradios/fip") then
		local js = vlc.read(10000)

		for url in js:gmatch '{"url".-}' do
			table.insert( tracks, {
					path = url:match( '{"url":"(.-)"' ), 
					title = url:match( '"format":"(.-)"' ):upper() .. " / "  .. url:match( '"bitrate":(%d+)' ):gsub("^0", "192(?)") .. " kbps",
					album = js:match('"legend":"([^"]+)"'):gsub(" logo", " (live)"):gsub(" Webradio", ""):gsub(" FR", ""),
					nowplaying = js:match( '"firstLine":"(.-)"' ) .. " - " .. js:match( '"secondLine":"(.-)"' )
			} )
		end
	end

	return tracks
end