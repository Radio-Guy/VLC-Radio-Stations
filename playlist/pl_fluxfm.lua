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

function clean_text(strg)
	if nil == strg then
		return ''
	else
		return strg:gsub( '^ -<br/-> -', '' ):gsub( ' -<br/-> -$', '' ):gsub( ' -<br/-> -', ' / ' ):gsub("<[^>]->", ""):gsub("[%c%s ]+", " "):gsub("&amp;", "&"):gsub("&#8211;", "-"):gsub("&#8217;", "'"):gsub("&#8222;", '"'):gsub("&#8220;", '"'):gsub("&#8230;", "..."):gsub("&#%d-;", "|")
	end
end

function probe()
	return (( vlc.access == "http" or vlc.access == "https" )
	and ( string.match(vlc.path, "fluxfm%.de/radio%-livestream")
	or string.match(vlc.path, "streams%.fluxfm%.de/") )
	)
end

function parse()
	local tracks = {}

	if string.match(vlc.path, "fluxfm%.de/radio%-livestream") then
		while ( nil == string.find( vlc.readline(), '<h2>Channels</h2>' ) ) do
		end
		local html = vlc.read(1000000)

		for hfive in html:gmatch '[^>]+</h5>.-streams.fluxfm.de.-<h5>' do
			local strg = hfive:match( '<p><strong>.-href="(%a+://.-fluxfm%.de/)[^"]+"' )
			for link in hfive:gmatch '<p><strong>.-href="%a+://.-fluxfm%.de/([^"]+)"' do
				strg = strg .. "?" .. link
			end
			local img = hfive:match( '<img[^>]-(https://[^" ]+250x250%.%a+)' )
			if nil == img then
				img = hfive:match( '<img[^>]-(https://[^" ]+150x150%.%a+)' )
			end
			if nil == img then
				img = hfive:match( '<img[^>]-(https://[^" ]+%.%a+)' )
			end

			table.insert( tracks, {
					title = clean_text( hfive:match( '^(.+)</h5>' ) ),
					description = clean_text( hfive:match( '<p>.-</p>' ) ),
					path = strg,
					arturl = img
				} )
		end
	elseif string.match(vlc.path, "streams%.fluxfm%.de/%?") then
		local front = vlc.path:match( '^.-fluxfm%.de/' )
		for link in vlc.path:gmatch '%?([^%?]+)' do
			local tmp = string.upper( (link:match( '/(.-%d.-)/' ) or "??? "):gsub('[^%w%? ]+', ' ') )
			table.insert( tracks, {
					title = tmp .. "kbps",
					album = tmp .. "kbps",
					path = vlc.access .. "://" .. front .. link
				} )
		end
	elseif string.match(vlc.path, "streams%.fluxfm%.de/") then
		local html = vlc.read(1000000)
		for div in html:gmatch '<div class="wrapper">.-<div class="section">.-</div>' do
			local strg = div:match( 'href="(%a+://.-fluxfm%.de/)[^"]+"' )
			for link in div:gmatch 'href="%a+://.-fluxfm%.de/([^"]+)"' do
				if (nil == string.match( link, '.pls$' )) and (nil == string.match( link, '.m3u$' )) then
					strg = strg .. "?" .. link
				end
			end
			
			table.insert( tracks, {
					title = clean_text( div:match( '<h1>(.-)</h1>' ) ),
					description = clean_text( div:match( '<div class="channel%-subtext">(.-)</div>' ) ),
					path = strg
				} )
		end
	end
	
	return tracks
end