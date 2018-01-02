io.stdout:setvbuf('no')
if arg[#arg] == "-debug" then require("mobdebug").start() end

love.graphics.setDefaultFilter("nearest")


local oldMan = {}
oldMan.image = love.graphics.newImage("oldman.png")
oldMan.nbOldManWidth = 3
oldMan.nbOldManHeight = 4
oldMan.widthOldMan = oldMan.image:getWidth() / oldMan.nbOldManWidth
oldMan.heightOldMan = oldMan.image:getHeight() / oldMan.nbOldManHeight
oldMan.quad = {}
oldMan.x = 500
oldMan.y = 100

local perso = {}
perso.image = love.graphics.newImage("perso.png")
perso.nbPersoWidth = 4
perso.nbPersoHeight = 4
perso.widthPerso = perso.image:getWidth() / perso.nbPersoWidth
perso.heightPerso = perso.image:getHeight() / perso.nbPersoHeight
perso.x = love.graphics.getWidth() / 2
perso.y = love.graphics.getHeight() / 2
perso.speed = 150
perso.currentQuad = 1
perso.animation = {}
perso.animation["up"] = {13,14,15,16}
perso.animation["right"] = {9,10,11,12}
perso.animation["down"] = {1,2,3,4}
perso.animation["left"] = {5,6,7,8}
perso.animation.framerate = 5
perso.quad = {}
perso.animation.cmp = 1
perso.animation.cmpFrame = 1
perso.currentMap = "garden"
perso.move = false
perso.dir = "up"
perso.dial = false
perso.birth = false


--chargement des images du perso

for c=1,perso.nbPersoHeight do
	for l=1,perso.nbPersoWidth do

		perso.quad[#perso.quad + 1] = love.graphics.newQuad(perso.widthPerso * (l - 1)  , perso.heightPerso * (c - 1), perso.widthPerso, perso.heightPerso, perso.image:getDimensions())

	end
end


for c=1,oldMan.nbOldManHeight do
	for l=1,oldMan.nbOldManWidth do

		oldMan.quad[#oldMan.quad + 1] = love.graphics.newQuad(oldMan.widthOldMan * (l - 1)  , oldMan.heightOldMan * (c - 1), oldMan.widthOldMan, oldMan.heightOldMan, oldMan.image:getDimensions())

	end
end



local map = {}

map.tileHeight = 16
map.tileWidth = 16

local screen = {}
screen.width = love.graphics.getWidth()
screen.height = love.graphics.getHeight()

screen.nbTileWidth = math.floor(screen.width / map.tileWidth)
screen.nbTileHeight = math.floor(screen.height / map.tileHeight)

map.image = love.graphics.newImage("pad.png")
map.imageHouse = love.graphics.newImage("house.png")


map.quad = {}
map.quadHouse = {}


map.nbTileWidth = math.floor(map.image:getWidth() / map.tileWidth)
map.nbTileHeight = math.floor(map.image:getHeight() / map.tileHeight)
map.nbTileWidthHouse = math.floor(map.imageHouse:getWidth() / map.tileWidth)
map.nbTileHeightHouse = math.floor(map.imageHouse:getHeight() / map.tileHeight)

--chargement de tile

for c=1,map.nbTileHeight do
	for l=1,map.nbTileWidth do

		map.quad[#map.quad + 1] = love.graphics.newQuad(map.tileWidth * (l - 1)  , map.tileHeight * (c - 1), map.tileWidth, map.tileHeight, map.image:getDimensions())

	end
end


for c=1,map.nbTileHeightHouse do
	for l=1,map.nbTileWidthHouse do

		map.quadHouse[#map.quadHouse + 1] = love.graphics.newQuad(map.tileWidth * (l - 1)  , map.tileHeight * (c - 1), map.tileWidth, map.tileHeight, map.imageHouse:getDimensions())
		
	end
end


--charge map

map.levels = {}
map.levels.pad = require('pad').layers[1].data
map.levels.pad2 = require('pad').layers[2].data

map.levels.house = require('house').layers[1].data
map.levels.house2 = require('house').layers[2].data

map.levels.game = require('game').layers[1].data
map.levels.game2 = require('game').layers[2].data

function love.load()

music = love.audio.newSource("hill.mp3")
bruit = love.audio.newSource("bruit.mp3")
music:setLooping(true)
music:play()

end


function love.update(dt)
	
	updatePerso(dt)
	
	
end


function love.draw()
	
	if perso.currentMap == "garden" then
		
		drawGarden()
		
		
		elseif perso.currentMap == "home" then
			
			drawHouse()
			
			love.graphics.draw(oldMan.image, oldMan.quad[1], oldMan.x , oldMan.y)
			
			
			elseif perso.currentMap == "game" then
				
				drawGame()
				if perso.birth == false then
					
					drawFog()
					
				end
				
			end
			
			if perso.birth == false then
				
				drawPerso()			
				
			end
			
		end


		function love.keypressed(key)

		end

		function drawGarden()

			local cmp = 1

			for c=1,screen.nbTileHeight do
				for l=1,screen.nbTileWidth do

					local tile = map.levels.pad[cmp]
					if tile ~= 0 then
						love.graphics.draw(map.image, map.quad[tile], map.tileWidth * (l - 1) , map.tileHeight * (c - 1))
					end
					cmp = cmp + 1
				end
			end
			
			cmp = 1
			
			for c=1,screen.nbTileHeight do
				for l=1,screen.nbTileWidth do

					local tile = map.levels.pad2[cmp]
					if tile ~= 0 then
						love.graphics.draw(map.image, map.quad[tile], map.tileWidth * (l - 1) , map.tileHeight * (c - 1))
					end
					cmp = cmp + 1
				end
			end


		end

		function drawHouse()

			local cmp = 1

			for c=1,screen.nbTileHeight do
				for l=1,screen.nbTileWidth do

					local tile = map.levels.house[cmp]
					if tile ~= 0 then
						love.graphics.draw(map.image, map.quad[tile], map.tileWidth * (l - 1) , map.tileHeight * (c - 1))
					end
					cmp = cmp + 1
				end
			end
			
			cmp = 1
			
			for c=1,screen.nbTileHeight do
				for l=1,screen.nbTileWidth do

					local tile = map.levels.house2[cmp]
					
					if tile ~= 0 then
						
						love.graphics.draw(map.imageHouse, map.quadHouse[tile - #map.quad], map.tileWidth * (l - 1) , map.tileHeight * (c - 1))
						
					end
					cmp = cmp + 1
				end
			end
			
			if perso.dial == true then

				drawDial()

			end			

		end


		function drawGame()

			local cmp = 1

			for c=1,screen.nbTileHeight do
				for l=1,screen.nbTileWidth do

					local tile = map.levels.game[cmp]
					if tile ~= 0 then
						love.graphics.draw(map.image, map.quad[tile], map.tileWidth * (l - 1) , map.tileHeight * (c - 1))
					end
					cmp = cmp + 1
				end
			end
			
			cmp = 1
			
			for c=1,screen.nbTileHeight do
				for l=1,screen.nbTileWidth do

					local tile = map.levels.game2[cmp]
					if tile ~= 0 then
						love.graphics.draw(map.image, map.quad[tile], map.tileWidth * (l - 1) , map.tileHeight * (c - 1))
					end
					cmp = cmp + 1
				end
			end

			
			if perso.birth == true then
				
				drawBirth()
				
			end
			
			
		end


		function drawPerso()
			
			love.graphics.draw(perso.image, perso.quad[perso.currentQuad], perso.x , perso.y)
			
		end


		function updatePerso(dt)
			
			local oldX = perso.x
			local oldY = perso.y
			
			perso.move = false
			
			if love.keyboard.isDown("up") and perso.y > 0 then
				
				perso.move = true	
				
				perso.y = perso.y - perso.speed * dt
				
				playAnimation("up")
				perso.dir = "up"				
				
				
				
				elseif love.keyboard.isDown("right") and perso.x < screen.width - perso.widthPerso then
					
					perso.dial = false
					
					perso.move = true	
					
					perso.x = perso.x + perso.speed * dt
					
					playAnimation("right")
					
					perso.dir = "right"				
					
					
					
					
					elseif love.keyboard.isDown("down") and perso.y < screen.height - perso.heightPerso then
						
						perso.dial = false
						
						perso.move = true	
						
						perso.y = perso.y + perso.speed * dt
						
						playAnimation("down")
						
						perso.dir = "down"				
						
						
						
						
						elseif love.keyboard.isDown("left") and perso.x > 0 then
							
							perso.dial = false
							
							perso.move = true	
							
							perso.x = perso.x - perso.speed * dt
							
							playAnimation("left")
							
							perso.dir = "left"				
							
							
						end
						
						if perso.move == false then
							
							initAnimation(perso.dir)
							
						end
						
						
						
						if perso.currentMap == "garden" then 
							if detectTile(map.levels.pad2, perso.x + perso.widthPerso / 2, perso.y) == 944 or
								detectTile(map.levels.pad2, perso.x + perso.widthPerso / 2, perso.y) == 891 or
								detectTile(map.levels.pad2, perso.x + perso.widthPerso / 2, perso.y) == 892 or
								detectTile(map.levels.pad2, perso.x + perso.widthPerso / 2, perso.y) == 890 or
								detectTile(map.levels.pad2, perso.x + perso.widthPerso / 2, perso.y) == 889 
								
								then
								
								perso.currentMap = "home" 
								perso.y = screen.height - perso.heightPerso - 100
							end
							
							if detectTile(map.levels.pad2, perso.x + perso.widthPerso / 2, perso.y +  perso.heightPerso / 2) ~= 0 and 
								detectTile(map.levels.pad2, perso.x + perso.widthPerso / 2, perso.y  + perso.heightPerso / 2) ~= 185 
								
								then
								perso.x = oldX
								perso.y = oldY
							end
							
							
						end
						
						if perso.currentMap == "home" then 
							if detectTile(map.levels.house2, perso.x + perso.widthPerso / 2, perso.y + perso.heightPerso / 2) == 2709 or
								detectTile(map.levels.house2, perso.x + perso.widthPerso / 2, perso.y + perso.heightPerso / 2) == 2710 or
								detectTile(map.levels.house2, perso.x + perso.widthPerso / 2, perso.y + perso.heightPerso / 2) == 2741 or
								detectTile(map.levels.house2, perso.x + perso.widthPerso / 2, perso.y + perso.heightPerso / 2) == 2742 
								then
								
								perso.currentMap = "garden" 
								perso.y = perso.heightPerso + 100 
							end
							
							if detectTile(map.levels.house2, perso.x + perso.widthPerso / 2, perso.y + perso.heightPerso / 2) ==  3354 or
								detectTile(map.levels.house2, perso.x + perso.widthPerso / 2, perso.y + perso.heightPerso / 2) == 3355 or
								detectTile(map.levels.house2, perso.x + perso.widthPerso / 2, perso.y + perso.heightPerso / 2) == 3386 or
								detectTile(map.levels.house2, perso.x + perso.widthPerso / 2, perso.y + perso.heightPerso / 2) == 3387 
								then
								
								perso.currentMap = "game" 
								perso.x = 118  
								perso.y = 683  
								
							end
							
							
							
							if detectTile(map.levels.house2, perso.x + perso.widthPerso / 2, perso.y +  perso.heightPerso / 2) ~= 0 then

								perso.x = oldX
								perso.y = oldY
								
							end
							
							
							if CheckCollision(perso.x,perso.y,perso.widthPerso,perso.heightPerso, oldMan.x,oldMan.y,oldMan.widthOldMan,oldMan.heightOldMan) then
								
								perso.x = oldX 
								perso.y = oldY
								
								perso.dial = true
								
							end
							
						end
						
						
						if perso.currentMap == "game" then 
							
							if detectTile(map.levels.game2, perso.x + perso.widthPerso / 2, perso.y +  perso.heightPerso) == 1501 
								or detectTile(map.levels.game2, perso.x + perso.widthPerso / 2, perso.y +  perso.heightPerso) == 1555
								or detectTile(map.levels.game2, perso.x + perso.widthPerso / 2, perso.y +  perso.heightPerso) == 1609 then
								
								perso.birth = true
								bruit:play()

								
							end
							
							if detectTile(map.levels.game2, perso.x + perso.widthPerso / 2, perso.y +  perso.heightPerso) ~= 0 then
								
								perso.x = oldX
								perso.y = oldY
								
							end
							
						end
						
					end
					
					function drawDial()
						
						love.graphics.setNewFont("emulogic.ttf", 10)
						love.graphics.setColor(44, 62, 80)
						love.graphics.rectangle("fill", 0, (screen.height / 3) * 2 , screen.width, screen.height / 3 )
						love.graphics.setColor(255, 255, 255)
						love.graphics.print("Hey salut david ! Ho je vois que aujourd hui tu n as pas mis ton costume rose :p",0 + 10,(screen.height / 3) * 2 + 10)
						love.graphics.print("Bref, je ne suis pas la pour te parler de ta soiree village people !",0 + 10,(screen.height / 3) * 2 + 30)
						love.graphics.print("Ton frere t as laisse un message dans la grotte a ta droite, aller big bisou :p",0 + 10,(screen.height / 3) * 2 + 50)
						
					end
					
					
					
					function drawBirth()
						
						love.graphics.setNewFont("emulogic.ttf", 30)
						love.graphics.setColor(46, 204, 113)
						love.graphics.rectangle("fill", 0, 0 , screen.width, screen.height)
						love.graphics.setColor(255, 255, 255)
						love.graphics.print("Bon anniversaire !",0 + 100, (screen.height / 2) - 40)
						love.graphics.print("Je t aime frero !",0 + 250,(screen.height / 2) + 30)
						
						
					end
					
					
					
					function drawFog()
						
						local myFog = {}
						
						local coord = {}
						
						for i=1,46 do
							
							myFog[i] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
							
						end
						
						
						coord = detectCoord(perso.x, perso.y)
						
						myFog[coord.colonne][coord.ligne - 1] = 1
						myFog[coord.colonne][coord.ligne] = 1
						myFog[coord.colonne][coord.ligne + 1] = 1
						myFog[coord.colonne][coord.ligne + 2] = 1
						myFog[coord.colonne][coord.ligne + 3] = 1

						myFog[coord.colonne + 1][coord.ligne - 1] = 1
						myFog[coord.colonne + 1][coord.ligne] = 1
						myFog[coord.colonne + 1][coord.ligne + 1] = 1
						myFog[coord.colonne + 1][coord.ligne + 2] = 1
						myFog[coord.colonne + 1][coord.ligne + 3] = 1

						myFog[coord.colonne + 2][coord.ligne - 1] = 1
						myFog[coord.colonne + 2][coord.ligne] = 1
						myFog[coord.colonne + 2][coord.ligne + 1] = 1
						myFog[coord.colonne + 2][coord.ligne + 2] = 1
						myFog[coord.colonne + 2][coord.ligne + 3] = 1

						myFog[coord.colonne + 3][coord.ligne - 1] = 1
						myFog[coord.colonne + 3][coord.ligne] = 1
						myFog[coord.colonne + 3][coord.ligne + 1] = 1
						myFog[coord.colonne + 3][coord.ligne + 2] = 1
						myFog[coord.colonne + 3][coord.ligne + 3] = 1
						
						if coord.colonne + 4 <= #myFog then
							
							myFog[coord.colonne + 4][coord.ligne - 1] = 1
							myFog[coord.colonne + 4][coord.ligne] = 1
							myFog[coord.colonne + 4][coord.ligne + 1] = 1
							myFog[coord.colonne + 4][coord.ligne + 2] = 1
							myFog[coord.colonne + 4][coord.ligne + 3] = 1
							
						end
						
						
						for l=1,#myFog do
							for c=1,#myFog[1] do
								
								if myFog[l][c] == 0 then
									
									love.graphics.setColor(0, 0, 0)
									love.graphics.rectangle("fill", (c - 1) * 16, (l - 1) * 16 , 16, 16)
									love.graphics.setColor(255, 255, 255)
									
								end
								
							end	
						end
						
						
					end
					
					
					function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
						
						if x1 < x2+w2 and
							x2 < x1+w1 and
							y1 < y2+h2 and
							y2 < y1+h1 then
							
							return true
							
						end
					end
					
					

					
					function initAnimation(animation)
						
						
						perso.currentQuad = perso.animation[animation][1]
						
					end
					
					function playAnimation(animation)

						perso.animation.cmp = perso.animation.cmp + 1 
						
						if perso.animation.cmp >= perso.animation.framerate then
							
							
							perso.currentQuad = perso.animation[animation][perso.animation.cmpFrame]
							
							
							if perso.animation.cmpFrame >= 4 then
								
								perso.animation.cmpFrame = 1				    	
								
							end
							
							perso.animation.cmpFrame = perso.animation.cmpFrame + 1	
							
							
							perso.animation.cmp = 1
							
						end				
					end



					function detectTile(myMap, x, y)

						
						local ligne = math.ceil(x / map.tileWidth)
						local colonne = math.ceil(y / map.tileHeight)
						local id = ((colonne - 1)  * screen.nbTileWidth ) + ligne
						return myMap[id]

					end
					
					function detectCoord(x, y)

						local coord = {}
						coord.ligne = math.ceil(x / map.tileWidth)
						coord.colonne = math.ceil(y / map.tileHeight)
						
						return coord

					end