
local composer = require( "composer" )
local inspect = require("inspect")
local json = require("json")


local scene = composer.newScene()
local card,heroineName,welcomeText,heroinePic,heroineDesc

local wwImg,heroineImg


local heroines = {}	

function scene:create( event )
	local sceneGroup = self.view

	local function onComplete( event )

		local jsonTable = json.decode(event.response)
		

			for i=1,#jsonTable.results do

				if jsonTable.results[i] ~= nil and jsonTable.results[i].name ~= nil and jsonTable.results[i].image ~= nil and jsonTable.results[i].deck ~= nil then
					heroines[i] = {["name"]=jsonTable.results[i].name,["image"]=jsonTable.results[i].image.thumb_url,["desc"]=jsonTable.results[i].deck};
				end
				
				
			end
	
		--print(inspect(heroines))

    end

    mod:characters("Female",onComplete)
	

	display.setDefault( "background",.10,.42,1)

	local function moveCard(event)

		if event.phase == "ended" and #heroines > 0 then

			
			local len = #heroines

			local r = math.random(len)
			local g = math.random(len)
			local b = math.random(len)

				

			if heroines[r] ~= nil and heroines[r].name ~= nil and heroines[r].image ~= nil and heroines[r].desc ~= nil then
				
				display.remove(wwImg)

				transition.to(heroineImg, {x = -900, time = 600, onComplete})				
				transition.to(heroineDesc, {x = -900, time = 600, onComplete})				
				transition.to(welcomeTxt, {x = -900, time = 600, onComplete})				
				transition.to(heroineName, {x = -900, time = 600, onComplete})
				transition.to(card, {x = -900, time = 400, onComplete = function() card.x = display.contentWidth/2; card:setFillColor(r/255,g/255,b/255) end})
				
				heroineName = display.newText( heroines[r].name, 100, 50, native.systemFontBold, 19 )
				heroineName.x = display.contentWidth/2
				heroineName.y = display.contentHeight/2-150
				heroineName:setFillColor(1)

				local function networkListener( event )
				    if ( event.isError ) then
				        print ( "Network error - download failed" )
				    else
				        event.target.alpha = 0
				        transition.to( event.target, { alpha = 1.0 } )
				  		if event.target then
				    		heroineImg = event.target
				  		end
		
				    end			    
				end
				
				local heroinePic = display.loadRemoteImage( heroines[r].image, "GET", networkListener, "heroine"..r..".jpg", system.TemporaryDirectory, display.contentWidth/2,display.contentHeight/2-50 )
				
				heroineDesc = display.newText( heroines[r].desc, 100, 200, display.contentWidth-50,display.contentHeight/2-50,native.systemFontBold, 12 )
				heroineDesc.x = display.contentWidth/2
				heroineDesc.y = display.contentHeight/2+150
				heroineDesc:setFillColor(1)
				

				
			end	
		end
	end

	card = display.newRoundedRect( display.contentWidth/2,display.contentHeight/2, display.contentWidth-20, display.contentHeight-30, 2 )
	card:setFillColor(1,.02,.01)
	card.strokeWidth=5
	card:setStrokeColor( 1 )

	card:addEventListener("touch",moveCard)
	welcomeTxt = display.newText( "Welcome to SuperHeroine trading cards! Click a card to shuffle.", display.contentWidth/2, 200, display.contentWidth-50, display.contentHeight/2,native.systemFontBold, 14 )
	welcomeTxt:setFillColor(1)	
	sceneGroup:insert( card )

	local function onFound(event)

		local jsonTable = json.decode(event.response)

		function networkListener(event)
	  		if event.target then
	    		wwImg = event.target
	  		end
		end
		
		
		for i=1,#jsonTable.results do

				if jsonTable.results[i] ~= nil then
						
					display.loadRemoteImage(jsonTable.results[i].image.thumb_url, "GET", networkListener, "ww.jpg", system.TemporaryDirectory, display.contentWidth/2,display.contentHeight/2)

				end
				
				
			end
		
	end

	mod:character("2048",onFound)

	
	
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
	elseif phase == "did" then
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
	elseif phase == "did" then
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene