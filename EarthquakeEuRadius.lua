-- This script was created by mojso
-- https://github.com/mojso/Domoticz_scripts
--this scripts gets earthquake info from www.seismicportal.eu for a defined area and then updates a text sensor with Magnitude and location

--it takes the first entry (= the most recent one) and therefore runs every 5 minutes



return {

	on = {

		timer = { 'every 2 minutes'},

		httpResponses = { 'kwakeV4' } -- matches callback string below

	},

	

	execute = function(domoticz, triggerItem)



-----Adjust these variables to get information about the place you want

local yourLatitude =  domoticz.settings.location.latitude --42.0069

local yourLongitude = domoticz.settings.location.longitude --20.9715

local radiusq = 300  --radius for how far you want to receive information

local radiusq2 = 700 -- second radius

local minmagq = 1 --min magnitude for first radius

local minmagq2 = 4.2 -- min magnitude for second radius

local yourlocaltime = 7200  -- your local time 3600 equal +1 UTC time

local minmagworld = 6.5 --minimum earthquake magnitude for the whole world



function titleCase( first, rest )

   return first:upper()..rest:lower()

end

local sensor = domoticz.devices('Earthquake EU radius')

local currInfo = tostring(sensor.text)



		if (triggerItem.isTimer) then

			domoticz.openURL({

				url = 'www.seismicportal.eu/fdsnws/event/1/query?limit=10&lat='..yourLatitude..'&lon='..yourLongitude..'&minradius=0&maxradius=180&format=json&minmag='..minmagq..'',

				method = 'GET',

				callback = 'kwakeV4'

			})

			

		elseif (triggerItem.isHTTPResponse) then



	local response = triggerItem

		if (response.ok and response.isJSON) then



				local mgt = tonumber(response.json.features[1].properties.mag)

				local lugar = tostring(response.json.features[1].properties.flynn_region)

				local timestampString = tostring(response.json.features[1].properties.time)

				local latq = tonumber(response.json.features[1].properties.lat)

				local lonq = tonumber(response.json.features[1].properties.lon)

				local depthq = tonumber(response.json.features[1].properties.depth)

				local qid = tonumber(response.json.features[1].properties.source_id)

				--local t = string.sub(cuando, 1,10)

				local t = os.time{year=tonumber(timestampString:sub(1,4)), 

                                   month=tonumber(timestampString:sub(6,7)), 

                                   day=tonumber(timestampString:sub(9,10)), 

                                   hour=tonumber(timestampString:sub(12,13)), 

                                   min=tonumber(timestampString:sub(15,16)), 

                                   sec=tonumber(timestampString:sub(18,19))}

		                local reString = os.date('%H:%M %a %d %B %Y', t + yourlocaltime) 

				        local reStringUTC = os.date('%H:%M %a %d %B %Y', t)

				lugar = string.gsub(lugar, "(%a)([%w_']*)", titleCase)

				

							-- Calculate distance using Haversine formula

        local function calculateDistance(lat1, lon1, lat2, lon2)

            local R = 6371 -- Earth radius in kilometers

            local dLat = math.rad(lat2 - lat1)

            local dLon = math.rad(lon2 - lon1)

            local a = math.sin(dLat / 2) * math.sin(dLat / 2) + math.cos(math.rad(lat1)) * math.cos(math.rad(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2)

            local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

            local distance = R * c

            return distance

        end



        local distance = calculateDistance(yourLatitude, yourLongitude, latq, lonq)

-- Round the distance to the nearest kilometer

        local roundedDistance = math.floor(distance + 0.5)

        local mapurl = '<a href="https://maps.google.com/?q='..latq..','..lonq..'"><font color="green">Location</font></a>'

        local moreinfo = '<a href="https://m.emsc.eu/?id='..qid..'"><font color="green">More info</font></a>'

              local qInfo = tostring('Magnitude of '.. mgt.. '<br> in '..lugar.. '<br> at '..reString.. '<br>'  .. roundedDistance ..'km Away from you <br>'.. mapurl .. ' | ' .. moreinfo)

						local message = tostring(" ‼ Earthquake detected ‼ \n" ..

						            "🎯 Distance: " .. roundedDistance .. "km Away from you\n" ..

						            "UTC Time: " ..reStringUTC.. "\n" ..

						            "Your Time: " ..reString.. "\n" ..

                                    "Magnitude: " .. mgt .. "\n" ..

                                    "Depth: " .. depthq .. "km \n" ..

                                    "Location: " .. lugar .. "\n" ..

                                    "Coordinates: " .. latq .. ", ".. lonq .. "\n" ..

                                    "Map address: https://maps.google.com/?q="..latq..","..lonq.. "\n" ..

                                     "More Info: https://m.emsc.eu/?id="..qid)

         -- Message to Kodi

            local mesageKodi = tostring('Magnitude of '.. mgt.. ' in '..lugar.. ' at '..reString.. ' , '  .. roundedDistance ..'km Away from you ')

        -- --------        

                                    if qInfo ~= currInfo and  roundedDistance < radiusq or qInfo ~= currInfo and mgt >= minmagworld or qInfo ~= currInfo and  roundedDistance > radiusq  and roundedDistance < radiusq2 and mgt > minmagq2 then

    						sensor.updateText(qInfo)

    						-- if you don't want to receive notifications, put -- at the beginning of the row below 

    						domoticz.notify('qInfo', message , domoticz.PRIORITY_NORMAL,nil,nil,domoticz.NSS_TELEGRAM)

                            domoticz.notify('qInfo', mesageKodi , domoticz.PRIORITY_NORMAL,nil,nil,domoticz.NSS_KODI)

                    

    						end

    					



		end



			else

				print('**kwake failed to fetch info')

			end

		

	end

}

