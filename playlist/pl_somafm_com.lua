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
	and (string.match(vlc.path, "somafm%.com/listen/listeners%.html")
	or string.match(vlc.path, "^somafm%.com/[%w_%-/]+$"))
	)
end

function parse()
	local tracks = {}
	local site = vlc.access .. "://" .. vlc.path:match( '^[^/]+')

	if string.match(vlc.path, "somafm%.com/listen/listeners%.html") then
		while ( nil == string.find( vlc.readline(), '<div id="stations">' ) ) do
		end
		local ul = vlc.read(1000000):match( '<ul.+</ul>' )

		for li in ul:gmatch '<li.-</li>' do
			local strg = li:match( '<dt>Listeners:.-(%d+)</dd>' )
			local stgg = "    " .. strg
			local strlen = string.len(stgg)
			table.insert( tracks, {
					path = site .. li:match( 'class="playing"><a href="(/[^/]+)' ), 
					title = li:match( '<h3>(.-)</h3>' ) .. " ... (" .. strg .. " gens)",
					description = stgg:sub(strlen-4, strlen),
					arturl = site .. li:match( '<img src="([^"]+)"' )
				} )
		end
	else
		local li = vlc.read(1000000):match( '<li.+</li>' )
		
		for codecs in li:gmatch '<nobr>[^<].-</a>.-br' do
			for plss in codecs:gmatch '<a.-</a>' do
				table.insert( tracks, {
						path = site .. plss:match( 'href="([^"]+)"' ), 
						title = codecs:match( '<nobr>([^:]+)' ) .. ": " .. plss:match( '([^>]+)</a>' ) .. " / " .. plss:match( 'href="[^%.]+.([^"]+)"' ),
						description = li:match( '<p class="descr">(.-)</p>' )
--[[						arturl = site .. "/img/" .. vlc.path:match( 'somafm%.com/(%a+)' ) .. "120.jpg"--]]
					} )
			end
		end
	end

	return tracks
end