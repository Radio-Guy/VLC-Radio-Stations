--[[

 Various radio stations (SomaFM.com, RadCap.ru, ...) lua script (VLC Service Discovery)

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

Put the pl_xxx.lua file into the according Playlist subfolder of the VLC lua directory, by default:
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

function descriptor()
	return { title="Radio Stations ++",
		description = "Radio Stations (Service Discovery)",
		version = "0.6",
		capabilities = {}
	}
end

function main()
	vlc.sd.add_item( {title = "SomaFM.com", path = "https://somafm.com/listen/listeners.html", arturl = "https://raw.githubusercontent.com/Radio-Guy/VLC-Radio-Stations/main/gfx/SomaFM_Logo.png"} )
	vlc.sd.add_item( {title = "RAD(io) CAP(rice)", path = "http://radcap.ru/index-d.html", arturl = "https://raw.githubusercontent.com/Radio-Guy/VLC-Radio-Stations/main/gfx/radcap_Logo.png"} )
	vlc.sd.add_item( {title = "FIP (France Inter Paris)", path = "https://www.radiofrance.fr/fip/titres-diffuses", arturl = "https://raw.githubusercontent.com/Radio-Guy/VLC-Radio-Stations/main/gfx/FIP_Logo.png"} )
	
	
	--[[ The old ... load-it-all approach. ... 
	local html = nil
	while ( nil == html ) do
		html = vlc.stream( "https://somafm.com/listen/listeners.html" )
	end

	while ( nil == string.find( html:readline(), '<div id="stations">' ) ) do
	end
	local ul = html:read(1000000):match( '<ul.+</ul>' )
	
	for li in ul:gmatch '<li.-</li>' do
		local strg = li:match( '<dt>Listeners:.-(%d+)</dd>' )
		local stgg = "    " .. strg
		local strlen = string.len(stgg)
		local subnode = node:add_subnode( {title = li:match( '<h3>(.-)</h3>' ) .. " ... (" .. strg .. " gens)", description = stgg:sub(strlen-4, strlen), arturl = "https://somafm.com" .. li:match( '<img src="([^"]+)"' )} )
		
		for codecs in li:gmatch '<nobr>[^<].-</a>.-br' do
			for plss in codecs:gmatch '<a.-</a>' do
				subnode:add_subitem( {title = codecs:match( '<nobr>([^:]+)' ) .. ": " .. plss:match( '([^>]+)</a>' ) .. " / " .. plss:match( 'href="[^%.]+.([^"]+)"' ), path = "https://somafm.com" .. plss:match( 'href="([^"]+)"' ), description = li:match( '<p class="descr">(.-)</p>' ) } )
			end
		end
	end


	
	local site = "http://radcap.ru/"

	local tmp = nil
	while ( nil == tmp ) do
		tmp = vlc.stream( "http://radcap.ru/folkrockru.html" )
	end
	local servers = tmp:read( "1000000" ):gmatch '"(http.-//[%d\\.]+:%d+)/%a+"'
	print(servers)
	
	tmp = nil
	while ( nil == tmp ) do
		tmp = vlc.stream( site .. "index-d.html" )
	end
	local pics_html = tmp:read( "1000000" ):match 'class="genres.-</table>'

	local db = nil
	while ( nil == db ) do
		db = vlc.stream( site .. "index-db.html" )
	end

	local node = vlc.sd.add_node( {title = "RAD(io) CAP(rice)", arturl = site .. "graf2/radcaplogo-hor.png"} )
	for genre in db:read( "1000000" ):gmatch '<td><h2.-<table.-</table>' do
		local subnode = node:add_subnode( {title = string.lower(genre:match( '<h2.->([^>]+)</a>' )):gsub("[^%l]%l", string.upper):gsub("^%l", string.upper), arturl = site .. pics_html:match( 'href="' .. genre:match( '<h2.-href="(%a+)' ) .. '.-src="(.-)"' ) } )
		for subgenre in genre:gmatch '<a href.-</span></a>' do
			local subsubnode = subnode:add_subnode( {title = string.lower(subgenre:match( '([^>]+)</span>' )):gsub("[^%l]%l", string.upper):gsub("^%l", string.upper), arturl = site .. subgenre:match( 'src="(.-)"' ) } )
				for server in servers do
					subsubnode:add_item( {  } )
				end
		end
	end
	]]--
	
end