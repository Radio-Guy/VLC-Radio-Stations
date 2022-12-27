--[[

 Various radio stations (SomaFM.com, RadCap.ru, ...) lua script (VLC Playlist parse)

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.


--- BUGS & REQUESTS: ---

Send me a message or open a ticket on github: https://github.com/Radio-Guy


--- INSTALLATION ---:

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


--- EXPLANATION & USAGE ---:

* This Service Discovery is available on the left panel of VLC under "Internet" >> ""Radio Stations ++"
* Each radio station offers several substations, various formats and sometimes several streaming servers.
* If you are in thumbnail view, you will receive nice and convenient station icons.

--]]

function probe()
	return (( vlc.access == "http" or vlc.access == "https" )
	and string.match(vlc.path, "^www%.radiofrance%.fr/.+")
	)
end

function parse()
	local tracks = {}
	local site = vlc.access .. "://" .. vlc.path:match( '^[^/]+')

	if "www.radiofrance.fr/fip/titres-diffuses" == vlc.path then
		local html = vlc.read(1000000):match( '<section class="WebradiosPage%-carousel%-container.-</section>' )

		for a in html:gmatch '<a href="/fip/.-</div>' do
			table.insert( tracks, {
					path = ("https://www.radiofrance.fr/api/v2.0/stations/fip/webradios/fip_" .. a:match( '<a href="/fip/(.-)"' ):gsub("radio%-", ""):gsub("%-", "")):gsub("_titresdiffuses", ""):gsub("monde", "world"), 
					title = a:match( '>([^>]+)</div>' ),
					arturl = "https://raw.githubusercontent.com/Radio-Guy/VLC-Radio-Stations/main/gfx/" .. a:match( '<a href="/fip/(.-)"' ) .. ".jpg"
			} )
		end
	elseif string.match(vlc.path, "www.radiofrance.fr/api/v2.0/stations/fip/webradios/") then
		local js = vlc.read(1000000)

		for url in js:gmatch '{"url".-}' do
			table.insert( tracks, {
					path = url:match( '{"url":"(.-)"' ), 
					title = url:match( '"broadcastType":"(.-)"' ):gsub("^%l", string.upper) .. " / " .. url:match( '"format":"(.-)"' ) .. " / "  .. url:match( '"bitrate":(%d+)' ):gsub("^0", "192(?)") .. " kbps",
					description = js:match( '"legend":"(.-)"' ),
					nowplaying = js:match( '"firstLine":"(.-)"' ) .. " - " .. js:match( '"secondLine":"(.-)"' )
			} )
		end
	end

	return tracks
end