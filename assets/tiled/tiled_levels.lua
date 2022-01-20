Tiled_Levels = Core.class(Sprite)

-- colors functions
function Tiled_Levels:hex2rgb(hex)
	local rgbtable = {}
	rgbtable.r, rgbtable.g, rgbtable.b =
		(hex >> 16 & 0xff) / 255, (hex >> 8 & 0xff) / 255, (hex & 0xff) / 255
	return rgbtable
end

function Tiled_Levels:rgb2hex(xr, xg, xb)
	local rgb = (xr * 0x10000) + (xg * 0x100) + xb
	return string.format("0x%06x", rgb)
end

function Tiled_Levels:init(xworld, xtiledlevel)
	self.world = xworld
	-- camera
	self.camera = Sprite.new()
	-- game layers
	self.bg2_backB = Sprite.new() -- game bg: nmes, deco, ...
	self.bg2_backA = Sprite.new() -- game bg: nmes, deco, ...
	self.bg2_base = Sprite.new() -- game bg: nmes, deco, ...
	self.bg2_frontA = Sprite.new() -- game bg: nmes, deco, ...
	self.bg2_frontB = Sprite.new() -- game bg: nmes, deco, ...
	self.bg1_backB = Sprite.new() -- game bg: nmes, deco, ...
	self.bg1_backA = Sprite.new() -- game bg: nmes, deco, ...
	self.bg1_base = Sprite.new() -- game bg: nmes, deco, ...
	self.bg1_frontA = Sprite.new() -- game bg: nmes, deco, ...
	self.bg1_frontB = Sprite.new() -- game bg: nmes, deco, ...
	self.mg = Sprite.new() -- game mg: grounds, player1, nmes, ...
	self.fg1_backB = Sprite.new() -- game fg: nmes, deco, ...
	self.fg1_backA = Sprite.new() -- game fg: nmes, deco, ...
	self.fg1_base = Sprite.new() -- game fg: nmes, deco, ...
	self.fg1_frontA = Sprite.new() -- game fg: nmes, deco, ...
	self.fg1_frontB = Sprite.new() -- game fg: nmes, deco, ...
	self.fg2_backB = Sprite.new() -- game fg: nmes, deco, ...
	self.fg2_backA = Sprite.new() -- game fg: nmes, deco, ...
	self.fg2_base = Sprite.new() -- game fg: nmes, deco, ...
	self.fg2_frontA = Sprite.new() -- game fg: nmes, deco, ...
	self.fg2_frontB = Sprite.new() -- game fg: nmes, deco, ...
	-- gideros particles
	local particleGFX = Texture.new("gfx/fx/smoke.png")
	if g_currentlevel == 1 then -- no particles fx here!
	elseif g_currentlevel == 2 then
		particleGFX = Texture.new("gfx/fx/smoke.png")
		self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	end
	self.particlesbg = Particles.new()
	self.particlesbg:setTexture(particleGFX)
	self.bg1_frontB:addChild(self.particlesbg)
	self.particlesfg = Particles.new()
	self.particlesfg:setTexture(particleGFX)
	self.fg1_backB:addChild(self.particlesfg)
	-- themes (color palettes)
	self.themergbbgB = {}
	self.themergbbgA = {}
	self.themergbbase = {}
	self.themergbfgA = {}
	self.themergbfgB = {}
	if g_currentlevel == 1 then
		application:setBackgroundColor(0x210601) -- 0x3f0c01
--		local themehexbg2 = {0x590001, 0xa60c03, 0xd93903, 0xf26d06, 0xf2a426}
--		local themehexbg1 = {0x590801, 0xa61d03, 0xd95003, 0xf28606, 0xf2ba26}
--		local themehexbase = {0x591202, 0xa62f03, 0xd96704, 0xf2a007, 0xf2d027}
--		local themehexfg1 = {0x591b01, 0xa64003, 0xd97d03, 0xf2b906, 0xf2e526}
--		local themehexfg2 = {0x592401, 0xa65103, 0xd99403, 0xf2d206, 0xe8f226}

		local themehexbg2 = {0x070100, 0x300901, 0x591202, 0x811a02, 0xaa2203}
		local themehexbg1 = {0x541701, 0x7d2302, 0xa62f03, 0xce3a03, 0xf74604}
		local themehexbase = {0x874002, 0xb05303, 0xd96704, 0xff7904, 0xff7904}
		local themehexfg1 = {0xa06a04, 0xc98505, 0xf2a007, 0xffa807, 0xffa807}
		local themehexfg2 = {0xa08919, 0xc9ac20, 0xf2d027, 0xffdb29, 0xffdb29}
		for i = 1, #themehexbase do
			self.themergbbgB[i] = self:hex2rgb(themehexbg2[i])
			self.themergbbgA[i] = self:hex2rgb(themehexbg1[i])
			self.themergbbase[i] = self:hex2rgb(themehexbase[i])
			self.themergbfgA[i] = self:hex2rgb(themehexfg1[i])
			self.themergbfgB[i] = self:hex2rgb(themehexfg2[i])
		end
	elseif g_currentlevel == 2 then
		application:setBackgroundColor(0x091924) -- 0x43c3f3
		-- artem brightness
		local themehexbg2 = {0x0c2230, 0x113144, 0x174059, 0x1c4e6d, 0x215d81}
		local themehexbg1 = {0x297896, 0x2f88aa, 0x3599bf, 0x3aa9d3, 0x40b9e7}
		local themehexbase = {0x5a676c, 0x6b7b80, 0x7d8f95, 0x8ea2a9, 0x9fb6bd}
		local themehexfg1 = {0x6c92a1, 0x7aa5b5, 0x88b8ca, 0x95cade, 0xa3ddf2}
		local themehexfg2 = {0xaeb7bb, 0xc1cbcf, 0xd5e0e4, 0xe8f4f8, 0xeefaff}
		for i = 1, #themehexbase do
			self.themergbbgB[i] = self:hex2rgb(themehexbg2[i])
			self.themergbbgA[i] = self:hex2rgb(themehexbg1[i])
			self.themergbbase[i] = self:hex2rgb(themehexbase[i])
			self.themergbfgA[i] = self:hex2rgb(themehexfg1[i])
			self.themergbfgB[i] = self:hex2rgb(themehexfg2[i])
		end
	elseif g_currentlevel == 3 then
		application:setBackgroundColor(0xa8882a)
		-- artem brightness
		local themehexbg2 = {0x2a91a8, 0x33b1cd, 0x3dd1f2, 0x40dcff, 0x40dcff}
		local themehexbg1 = {0x334201, 0x506702, 0x6e8c03, 0x8bb003, 0xa8d504}
		local themehexbase = {0xa8882a, 0xcda633, 0xf2c53d, 0xffcf40, 0xffcf40}
		local themehexfg1 = {0xa85d1b, 0xcd7121, 0xf28627, 0xff8d29, 0xff8d29}
		local themehexfg2 = {0x290f00, 0x4e1d01, 0x732c02, 0x973a02, 0xbc4803}
		for i = 1, #themehexbase do
			self.themergbbgB[i] = self:hex2rgb(themehexbg2[i])
			self.themergbbgA[i] = self:hex2rgb(themehexbg1[i])
			self.themergbbase[i] = self:hex2rgb(themehexbase[i])
			self.themergbfgA[i] = self:hex2rgb(themehexfg1[i])
			self.themergbfgB[i] = self:hex2rgb(themehexfg2[i])
		end
	else print("error!!!", "level: "..g_currentlevel.." does not exist!")
	end
	-- the Tiled map size, I need the Tiled map dimensions for the parallax
	self.mapwidth, self.mapheight = xtiledlevel.width * xtiledlevel.tilewidth,
		xtiledlevel.height * xtiledlevel.tileheight
	print("map size "..self.mapwidth..", "..self.mapheight,
		"app size "..myappwidth..", "..myappheight, "all in pixels.")
	-- parallax
	if g_currentlevel == 1 then
		local texpath="tiled/levels/parallax_bgs/forest01.png"
		self.parallaxB2 = self:parallax(
			{
				posoffsetx=0, posoffsety=-128,
				texpath=texpath,
				scalex=1, scaley=4,
				extraw=8*12, extrah=0,
				texoffsetx=-64, texoffsety=0,
				hexcolortransform=0x3f0c01, hexcolortransformalpha=1,
			}
		)
	elseif g_currentlevel == 2 then
		local texpath="tiled/levels/parallax_bgs/mountain_village2.png"
		self.parallaxB2 = self:parallax(
			{
				posoffsetx=64, posoffsety=64*1.3,
				texpath=texpath,
				scalex=1.7, scaley=1.7,
				extraw=8*12, extrah=0,
				texoffsetx=0, texoffsety=0,
				hexcolortransform=0x46CCFF, hexcolortransformalpha=2,
				parallaxalpha=1,
			}
		)
		self.parallaxB1 = self:parallax(
			{
				posoffsetx=64*1.5, posoffsety=64*1,
				texpath=texpath,
				scalex=1.5, scaley=1.5,
				extraw=8*12, extrah=0,
				texoffsetx=0, texoffsety=0,
				hexcolortransform=0x46CCFF, hexcolortransformalpha=1,
				parallaxalpha=1,
			}
		)
	else print("error!!!", "level: "..g_currentlevel.." does not exist!")
	end
	-- order
	if self.parallaxB3 then self.camera:addChild(self.parallaxB3) end
	if self.parallaxB2 then self.camera:addChild(self.parallaxB2) end
	if self.parallaxB1 then self.camera:addChild(self.parallaxB1) end
	self.camera:addChild(self.bg2_backB)
	self.camera:addChild(self.bg2_backA)
	self.camera:addChild(self.bg2_base)
	self.camera:addChild(self.bg2_frontA)
	self.camera:addChild(self.bg2_frontB)
	self.camera:addChild(self.bg1_backB)
	self.camera:addChild(self.bg1_backA)
	self.camera:addChild(self.bg1_base)
	self.camera:addChild(self.bg1_frontA)
	self.camera:addChild(self.bg1_frontB)
	self.camera:addChild(self.mg)
	self.camera:addChild(self.fg1_backB)
	self.camera:addChild(self.fg1_backA)
	self.camera:addChild(self.fg1_base)
	self.camera:addChild(self.fg1_frontA)
	self.camera:addChild(self.fg1_frontB)
	self.camera:addChild(self.fg2_backB)
	self.camera:addChild(self.fg2_backA)
	self.camera:addChild(self.fg2_base)
	self.camera:addChild(self.fg2_frontA)
	self.camera:addChild(self.fg2_frontB)
	if self.parallaxF1 then self.camera:addChild(self.parallaxF1) end
	-- final
	self:addChild(self.camera)

	-- put all the Tiled Tileset images in a table (this is the tileset not the tilemap!)
	local tilesetimages = {}
	local tilesets = xtiledlevel.tilesets
	for i = 1, #tilesets do
		local tileset = tilesets[i]
		-- TILESETS
		-- ********
		if tileset.name == "images" then -- your Tiled Tileset! name here
			local tiles = tileset.tiles
			for i = 1, #tiles do
				tilesetimages[tiles[i].id+1] = {
					path=tiles[i].image,
					width=tiles[i].width,
					height=tiles[i].height,
				}
			end
		end
	end

	-- parse the Tiled level
	local layers = xtiledlevel.layers
	local myshape -- shapes from Tiled
	local mytable -- intermediate table for shapes params
	for i = 1, #layers do
		local layer = layers[i]

		-- GROUPED IMAGES
		-- **************
		local path = "tiled/levels/"
		if layer.name == "IMAGES" then -- group
			local layers2 = layer.layers
			for i = 1, #layers2 do
				local layer2 = layers2[i]
				if layer2.name == "bg_images_deco" then
					local objects = layer2.objects
					for i = 1, #objects do
						local object = objects[i]
						local objectName = object.name
						local tex = Texture.new(path..tilesetimages[object.gid].path, false)
						local bitmap = Bitmap.new(tex)
						bitmap:setAnchorPoint(0, 1) -- because I always forget to set Tiled object alignment
						local scalex, scaley = object.width / tex:getWidth(), object.height / tex:getHeight()
						bitmap:setScale(scalex, scaley)
						bitmap:setPosition(object.x, object.y)
						bitmap:setRotation(object.rotation)
						self.bg2_base:addChild(bitmap)
					end
				elseif layer2.name == "fg_images_deco" then
					local objects = layer2.objects
					for i = 1, #objects do
						local object = objects[i]
						local objectName = object.name
						local tex = Texture.new(path..tilesetimages[object.gid].path, false)
						local bitmap = Bitmap.new(tex)
						bitmap:setAnchorPoint(0, 1) -- because I always forget to set Tiled object alignment
						local scalex, scaley = object.width / tex:getWidth(), object.height / tex:getHeight()
						bitmap:setScale(scalex, scaley)
						bitmap:setPosition(object.x, object.y)
						bitmap:setRotation(object.rotation)
						self.fg2_base:addChild(bitmap)
					end
				elseif layer2.name == "static_images" then
					local objects = layer2.objects
					for i = 1, #objects do
						local object = objects[i]
						local objectName = object.name
						-- CONTOUR STATIC
						-- **************
						local tex = Texture.new(path..tilesetimages[object.gid].path)
						local texpath = path..tilesetimages[object.gid].path
						local scalex, scaley = object.width / tex:getWidth(), object.height / tex:getHeight()
						local contour_static = Tiled_Contour_Static.new(xworld, {
							texpath=texpath,
							scalex=scalex, scaley=scaley, rotation=object.rotation,
							density=1, restitution=0, friction=1,
							BIT=G_BITSOLID, COLBIT=solidcollisions, ROLE=G_GROUND,
						})
						contour_static:setPosition(object.x, object.y)
						self.mg:addChild(contour_static)
					end
				end
			end
		end

		-- TILED LEVELS SHAPES
		-- *******************
		if g_currentlevel == 1 then
			local xtexs = {}
			local alphabg, alphafg = 1, 1
			xtexs.bg2backB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=1}
			xtexs.bg2backA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=2}
			xtexs.bg2base = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=3}
			xtexs.bg2frontA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=4}
			xtexs.bg2frontB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=5}
			xtexs.bg1backB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=1}
			xtexs.bg1backA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=2}
			xtexs.bg1base = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=3}
			xtexs.bg1frontA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=4}
			xtexs.bg1frontB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=5}

			xtexs.ground = {tex="tiled/levels/grounds/brown_qussair_granite.jpg", scale=1, alpha=1, colorindex=1}

			xtexs.fg1backB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=1}
			xtexs.fg1backA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=2}
			xtexs.fg1base = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=3}
			xtexs.fg1frontA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=4}
			xtexs.fg1frontB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=5}
			xtexs.fg2backB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=1}
			xtexs.fg2backA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=2}
			xtexs.fg2base = {tex="tiled/levels/grounds/phoenix_feathers.jpg", scale=1, alpha=alphafg, colorindex=3}
			xtexs.fg2frontA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=4}
			xtexs.fg2frontB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=5}

			self:shapesLevels(layer, xtexs)
		elseif g_currentlevel == 2 then
			local xtexs = {}
			local alphabg, alphafg = 1.8, 1.7
			xtexs.bg2backB = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphabg, colorindex=1}
			xtexs.bg2backA = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphabg, colorindex=2}
			xtexs.bg2base = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphabg, colorindex=3}
			xtexs.bg2frontA = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphabg, colorindex=4}
			xtexs.bg2frontB = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphabg, colorindex=5}
			xtexs.bg1backB = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphabg, colorindex=1}
			xtexs.bg1backA = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphabg, colorindex=2}
			xtexs.bg1base = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphabg, colorindex=3}
			xtexs.bg1frontA = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphabg, colorindex=4}
			xtexs.bg1frontB = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphabg, colorindex=5}

			xtexs.ground = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=1.9, colorindex=5}

			xtexs.fg1backB = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphafg, colorindex=1}
			xtexs.fg1backA = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphafg, colorindex=2}
			xtexs.fg1base = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphafg, colorindex=3}
			xtexs.fg1frontA = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphafg, colorindex=4}
			xtexs.fg1frontB = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphafg, colorindex=5}
			xtexs.fg2backB = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphafg, colorindex=1}
			xtexs.fg2backA = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphafg, colorindex=2}
			xtexs.fg2base = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphafg, colorindex=3}
			xtexs.fg2frontA = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphafg, colorindex=4}
			xtexs.fg2frontB = {tex="tiled/levels/grounds/cracked_gray_rock.jpg", scale=1, alpha=alphafg, colorindex=5}

			self:shapesLevels(layer, xtexs)
		elseif g_currentlevel == 3 then
			local xtexs = {}
			local alphabg, alphafg = 1, 1.5
			xtexs.bg2backB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=1}
			xtexs.bg2backA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=2}
			xtexs.bg2base = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=3}
			xtexs.bg2frontA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=4}
			xtexs.bg2frontB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=5}
			xtexs.bg1backB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=1}
			xtexs.bg1backA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=2}
			xtexs.bg1base = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=3}
			xtexs.bg1frontA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=4}
			xtexs.bg1frontB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphabg, colorindex=5}

			xtexs.ground = {tex="tiled/levels/grounds/brown_qussair_granite.jpg", scale=1, alpha=1, colorindex=1}

			xtexs.fg1backB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=1}
			xtexs.fg1backA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=2}
			xtexs.fg1base = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=3}
			xtexs.fg1frontA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=4}
			xtexs.fg1frontB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=5}
			xtexs.fg2backB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=1}
			xtexs.fg2backA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=2}
			xtexs.fg2base = {tex="tiled/levels/grounds/phoenix_feathers.jpg", scale=1, alpha=alphafg, colorindex=3}
			xtexs.fg2frontA = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=4}
			xtexs.fg2frontB = {tex="tiled/levels/grounds/flower_rock.jpg", scale=1, alpha=alphafg, colorindex=5}

			self:shapesLevels(layer, xtexs)
		else print("error!!!", "level: "..g_currentlevel.." does not exist!") return
		end

		-- SLIDERS
		-- *******
		if layer.name == "slides" then -- land sliding
			local levelsetup = {}
			local objects = layer.objects
			for i = 1, #objects do
				local object = objects[i]
				local objectName = object.name
				myshape, mytable = nil, nil
				if objectName == "" then -- WALLS
					mytable = {
						isshape=true,
						density=1, restitution=0, friction=0, -- this friction parameter controls slopes sliding!
						BIT=G_BITSOLID, COLBIT=solidcollisions, ROLE=G_WALL,
					}
				elseif objectName == "groundLF" then -- special case for grounds low friction
					mytable = {
						isshape=true,
						density=1, restitution=0, friction=0.1, -- this friction parameter controls slopes sliding!
						BIT=G_BITSOLID, COLBIT=solidcollisions, ROLE=G_GROUND,
					}
				elseif objectName == "groundA" then -- special case for grounds
					mytable = {
						isshape=true,
						density=1, restitution=0, friction=1.1, -- this friction parameter controls slopes sliding!
						BIT=G_BITSOLID, COLBIT=solidcollisions, ROLE=G_GROUND,
					}
				end
				if mytable then
					levelsetup = {}
					for k, v in pairs(mytable) do levelsetup[k] = v end
					myshape = self:buildShapes(object, levelsetup)
					myshape:setPosition(object.x, object.y)
					self.mg:addChild(myshape)
				end
			end

		-- PASS THROUGH PLATFORMS
		-- ***********************
		elseif layer.name == "ptpfs" then -- your Tiled layer name here!
			local levelsetup = {}
			local objects = layer.objects
			for i = 1, #objects do
				local object = objects[i]
				local objectName = object.name
				myshape, mytable = nil, nil
				if objectName == "" then
					if g_currentlevel == 2 then
						myshape = Tiled_PtPf.new(xworld, {
							x = object.x, y = object.y,
							w = object.width, h = object.height, rotation = object.rotation,
							isshape=true,
							color=0x421C06,
--							texpath="gfx/grounds/Terrazzo016_1K_Color.jpg",
							shapelinewidth=1, shapelinecolor=0x0, shapelinealpha=1,
							density=0, restitution=0, friction=1,
							BIT=G_BITPTPF, COLBIT=solidcollisions, ROLE=G_PTPLATFORM,
						})
					end
				end
				myshape:setPosition(object.x, object.y)
				self.mg:addChild(myshape)
			end

		-- MOVING PLATFORMS
		-- ****************
		elseif layer.name == "mvpfs" then -- your Tiled layer name here!
			local levelsetup = {}
			local objects = layer.objects
			for i = 1, #objects do
				local object = objects[i]
				local objectName = object.name
				myshape, mytable = nil, nil
				if objectName:sub(1, 5) == "mvpf_" then
					local direction = objectName:sub(6, 6)
					local distance = tonumber(string.match(objectName, "%d+"))
					if g_currentlevel == 1 then
						myshape = Tiled_MvPf.new(xworld, {
							x = object.x, y = object.y,
							w = object.width, h = object.height, rotation = object.rotation,
							shapelinewidth=2, shapelinecolor=0xFFC933, shapelinealpha=1,
							isshape=true,
							density=0, restitution=0, friction=1,
							type=b2.KINEMATIC_BODY,
							BIT=G_BITSOLID, COLBIT=solidcollisions, ROLE=G_MVPLATFORM,
						})
					elseif g_currentlevel == 2 then
						myshape = Tiled_MvPf.new(xworld, {
							x = object.x, y = object.y,
							w = object.width, h = object.height, rotation = object.rotation,
							color=0x1C1301, shapelinewidth=2, shapelinecolor=0xF19E05, isshape=true,
							density=1, restitution=0, friction=1,
							type=b2.KINEMATIC_BODY,
							BIT=G_BITSOLID, COLBIT=solidcollisions, ROLE=G_MVPLATFORM,
						})
					end
					local speedx, speedy = 32*3, 32*3
					if direction == "N" then
						myshape.directiony = -1 -- init the movement
						if g_currentlevel == 1 then myshape.vx, myshape.vy = 0, speedy
						elseif g_currentlevel == 2 then myshape.vx, myshape.vy = 0, speedy
						end
						myshape.minx, myshape.maxx = object.x, object.x
						myshape.miny, myshape.maxy = object.y - distance, object.y
					elseif direction == "S" then
						myshape.directiony = 1 -- init the movement
						if g_currentlevel == 1 then myshape.vx, myshape.vy = 0, speedy
						elseif g_currentlevel == 2 then myshape.vx, myshape.vy = 0, speedy
						end
						myshape.minx, myshape.maxx = object.x, object.x
						myshape.miny, myshape.maxy = object.y, object.y + distance
					elseif direction == "E" then
						myshape.directionx = 1 -- init the movement
						if g_currentlevel == 1 then myshape.vx, myshape.vy = speedx, 0
						elseif g_currentlevel == 2 then myshape.vx, myshape.vy = speedx, 0
						end
						myshape.minx, myshape.maxx = object.x, object.x + distance
						myshape.miny, myshape.maxy = object.y, object.y
					elseif direction == "W" then
						myshape.directionx = -1 -- init the movement
						if g_currentlevel == 1 then myshape.vx, myshape.vy = speedx, 0
						elseif g_currentlevel == 2 then myshape.vx, myshape.vy = speedx, 0
						end
						myshape.minx, myshape.maxx = object.x - distance, object.x
						myshape.miny, myshape.maxy = object.y - distance, object.y
					end
					myshape:setPosition(object.x, object.y)
					self.mg:addChild(myshape)
				end
			end

		-- PLAYABLE
		-- ********
		elseif layer.name == "playable" then -- your Tiled layer name here!
			local levelsetup = {}
			local objects = layer.objects
			for i = 1, #objects do
				local object = objects[i]
				-- go to another class to rule all playables :-{
				Tiled_Levels_Playable(xworld, object, self.mg)
			end

		-- SENSORS
		-- *******
		elseif layer.name == "sensors" then -- your Tiled layer name here!
			local levelsetup = {}
			local objects = layer.objects
			for i = 1, #objects do
				local object = objects[i]
				local objectName = object.name
				myshape, mytable = nil, nil
				if objectName == "ladder" then mytable = {BIT=G_BITSENSOR, COLBIT=nil, ROLE=G_LADDER}
				elseif objectName == "danger" then mytable = {BIT=G_BITSENSOR, COLBIT=G_BITPLAYER, ROLE=G_DANGER}
				elseif objectName == "exit" then mytable = {BIT=G_BITSENSOR, COLBIT=G_BITPLAYER, ROLE=G_EXIT}
				end
				if mytable ~= nil then
					levelsetup = {issensor=true}
					for k, v in pairs(mytable) do levelsetup[k] = v end
					myshape = self:buildShapes(object, levelsetup)
					myshape:setPosition(object.x, object.y)
					self.mg:addChild(myshape)
				end
			end

		-- COLLECTIBLES
		-- ************
		elseif layer.name == "collectibles" then -- your Tiled layer name here!
			local levelsetup = {}
			local objects = layer.objects
			for i = 1, #objects do
				local object = objects[i]
				local objectName = object.name
				myshape, mytable = nil, nil
				if objectName == "c01" then -- collectibles are Tiled polygons so I can center them!
					myshape = Collectibles.new(self.world, {
						coords=object.polygon,
						isbmp=true,
						texpath="gfx/collectibles/obj0071.png",
						scalex=0.3,
						density=1, restitution=0, friction=0,
						type=b2.KINEMATIC_BODY,
						BIT=G_BITSENSOR, COLBIT=G_BITPLAYER, ROLE=G_COLLECTIBLE,
						value=10,
					})
					self.world.collectibles[myshape] = myshape.body
					myshape:setPosition(object.x, object.y)
					self.mg:addChild(myshape)
				elseif objectName == "key01" then
					myshape = Collectibles.new(self.world, {
						coords=object.polygon,
						density=1, restitution=0, friction=0,
						type=b2.KINEMATIC_BODY,
						BIT=G_BITSENSOR, COLBIT=G_BITPLAYER, ROLE=G_COLLECTIBLE,
						data=1,
						value=100,
					})
					myshape:prepareAnim("gfx/collectibles/key1_0001.png", 6, 2, 0.1)
					self.world.collectibles[myshape] = myshape.body
					myshape:setPosition(object.x, object.y)
					self.mg:addChild(myshape)
				end
			end

		-- DOORS
		-- *****
		elseif layer.name == "doors" then
			local levelsetup = {}
			local objects = layer.objects
			for i = 1, #objects do
				local object = objects[i]
				local objectName = object.name
				myshape, mytable = nil, nil
				if objectName == "door1" then -- extends polygon
					myshape = Tiled_Door.new(self.world, {
						x=object.x, y=object.y,
						coords=object.polygon,
						rotation=object.rotation,
						isshape=true,
						texpath="tiled/levels/grounds/granite_wall.jpg",
--						scalex=0.5,
						density=0, restitution=0, friction=1,
						type=b2.KINEMATIC_BODY,
						BIT=G_BITSOLID, COLBIT=solidcollisions, ROLE=G_DOOR,
						data=1,
					})
					self.world.doors[myshape.body.data] = myshape.body
					myshape:setPosition(object.x, object.y)
					self.mg:addChild(myshape)
				end
			end

		-- LADDERS
		-- *******
		elseif layer.name == "ladders" then -- your Tiled layer name here!
			local levelsetup = {}
			local objects = layer.objects
			for i = 1, #objects do
				local object = objects[i]
				local objectName = object.name
				myshape, mytable = nil, nil
				if objectName == "" then
					if g_currentlevel == 2 then
						local currthemecolor=5
						mytable = {
							isshape=true,
							texpath="tiled/levels/grounds/light_bumpy_rock.jpg",
							r=self.themergbfgA[currthemecolor].r,
							g=self.themergbfgA[currthemecolor].g,
							b=self.themergbfgA[currthemecolor].b,
							isdeco=true,
						}
					end
				end
				if mytable ~= nil then
					levelsetup = {}
					for k, v in pairs(mytable) do levelsetup[k] = v end
					myshape = self:buildShapes(object, levelsetup)
					myshape:setPosition(object.x, object.y)
					self.mg:addChild(myshape)
				end
			end

		-- DANGER
		-- *******
		elseif layer.name == "danger" then -- your Tiled layer name here!
			local levelsetup = {}
			local objects = layer.objects
			for i = 1, #objects do
				local object = objects[i]
				local objectName = object.name
				myshape, mytable = nil, nil
				if objectName == "" then
					if g_currentlevel == 2 then
						mytable = {
							isshape=true,
--							texpath="tiled/levels/grounds/light_bumpy_rock.jpg",
							color=0xff0000,
							shapelinewidth=2, shapelinecolor=0x493c2b, shapelinealpha=0.8,
							isdeco=true,
						}
					end
				end
				if mytable ~= nil then
					levelsetup = {}
					for k, v in pairs(mytable) do levelsetup[k] = v end
					myshape = self:buildShapes(object, levelsetup)
					myshape:setPosition(object.x, object.y)
					self.mg:addChild(myshape)
				end
			end

		-- MOVEABLE
		-- *******
		elseif layer.name == "moveables" then -- your Tiled layer name here!
			local levelsetup = {}
			local objects = layer.objects
			for i = 1, #objects do
				local object = objects[i]
				local objectName = object.name
				myshape, mytable = nil, nil
				if objectName == "" then
					if g_currentlevel == 2 then
						mytable = {
							isshape=true,
							texpath="tiled/levels/grounds/brown_qussair_granite.jpg",
							shapelinewidth=2, shapelinecolor=0x493c2b, shapelinealpha=0.8,
							type=b2.DYNAMIC_BODY,
							fixedrotation=false,
							density=8, restitution=0.5, friction=0.1,
							BIT=G_BITSOLID, COLBIT=solidcollisions, ROLE=G_MOVEABLE,
							data=5,
						}
					end
				end
				if mytable ~= nil then
					levelsetup = {}
					for k, v in pairs(mytable) do levelsetup[k] = v end
					myshape = self:buildShapes(object, levelsetup)
					myshape:setPosition(object.x, object.y)
					self.mg:addChild(myshape)
				end
			end

		-- WHAT?!
		-- ******
		else print("WHAT?!", layer.name)
		end
	end
end

function Tiled_Levels:parallax(xparams)
	local params = xparams or {}
	params.posoffsetx = xparams.posoffsetx or 0
	params.posoffsety = xparams.posoffsety or 0
	params.texpath = xparams.texpath or nil
	params.scalex = xparams.scalex or 1
	params.scaley = xparams.scaley or params.scalex
	params.extraw = xparams.extraw or 0
	params.extrah = xparams.extrah or 0
	params.texoffsetx = xparams.texoffsetx or 0
	params.texoffsety = xparams.texoffsety or 0
	params.hexcolortransform = xparams.hexcolortransform or 0xffffff
	params.hexcolortransformalpha = xparams.hexcolortransformalpha or 1
	params.parallaxalpha = xparams.parallaxalpha or 1
	local texture = Texture.new(
		params.texpath, false,
		{wrap=Texture.REPEAT, extend=false,}
	)
	local parallax = Pixel.new(texture)
	parallax:setTextureScale(params.scalex, params.scaley)
	parallax:setDimensions(
		self.mapwidth + 2 * params.extraw,
		texture:getHeight() * params.scaley
	)
	parallax:setTexturePosition(params.texoffsetx, params.texoffsety)
	local rgb = self:hex2rgb(params.hexcolortransform)
	parallax:setColorTransform(rgb.r, rgb.g, rgb.b, params.hexcolortransformalpha) -- can alpha fx here!
	parallax:setAlpha(params.parallaxalpha)
	parallax:setPosition(
		myappleft - params.extraw - params.posoffsetx,
		self.mapheight - parallax:getHeight() - params.posoffsety
	)
	return parallax
end

function Tiled_Levels:shapesLevels(xlayer, xtexs) -- xtexs = table of textures and scales
	local myshape, mytable = nil, nil
	-- GROUNDS
	-- ***********
	if xlayer.name == "grounds" then -- land
		local levelsetup = {}
		local objects = xlayer.objects
		for i = 1, #objects do
			local object = objects[i]
			local objectName = object.name
			myshape, mytable = nil, nil
			if objectName == "" then
				mytable = {
					isshape=true,
					texpath=xtexs.ground.tex,
					scalex=xtexs.ground.scale,
					r=self.themergbbase[xtexs.ground.colorindex].r,
					g=self.themergbbase[xtexs.ground.colorindex].g,
					b=self.themergbbase[xtexs.ground.colorindex].b,
					alpha=xtexs.ground.alpha,
					density=1, restitution=0, friction=4, -- this friction parameter controls slopes sliding! XXX
				}
			elseif objectName == "groundB" then -- transparent
				mytable = {}
			end
			if mytable then
				levelsetup = {
--					shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
					BIT=G_BITSOLID, COLBIT=solidcollisions, ROLE=G_GROUND,
				}
				for k, v in pairs(mytable) do levelsetup[k] = v end
				myshape = self:buildShapes(object, levelsetup)
				myshape:setPosition(object.x, object.y)
				self.mg:addChild(myshape)
				-- list
--				if object.name == "" then
--					self.world.grounds[#self.world.grounds + 1] = myshape
--				end
			end
		end

	-- GROUPED BGs
	-- ***********
	elseif xlayer.name == "BGs" then
		local layers2 = xlayer.layers
		for i = 1, #layers2 do
			local layer2 = layers2[i]
			-- BG LAYER 2
			-- ***********
			if layer2.name == "bg2_deco_backB" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.bg2backB.tex,
							scalex=xtexs.bg2backB.scale,
							r=self.themergbbgB[xtexs.bg2backB.colorindex].r,
							g=self.themergbbgB[xtexs.bg2backB.colorindex].g,
							b=self.themergbbgB[xtexs.bg2backB.colorindex].b,
							alpha=xtexs.bg2backB.alpha,
						}
					end
					if mytable then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.bg2_backB:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "bg2_deco_backA" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.bg2backA.tex,
							scalex=xtexs.bg2backA.scale,
							r=self.themergbbgB[xtexs.bg2backA.colorindex].r,
							g=self.themergbbgB[xtexs.bg2backA.colorindex].g,
							b=self.themergbbgB[xtexs.bg2backA.colorindex].b,
							alpha=xtexs.bg2backA.alpha,
						}
					end
					if mytable then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.bg2_backA:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "bg2_deco_base" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.bg2base.tex,
							scalex=xtexs.bg2base.scale,
							r=self.themergbbgB[xtexs.bg2base.colorindex].r,
							g=self.themergbbgB[xtexs.bg2base.colorindex].g,
							b=self.themergbbgB[xtexs.bg2base.colorindex].b,
							alpha=xtexs.bg2base.alpha,
						}
					end
					if mytable then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.bg2_base:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "bg2_deco_frontA" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.bg2frontA.tex,
							scalex=xtexs.bg2frontA.scale,
							r=self.themergbbgB[xtexs.bg2frontA.colorindex].r,
							g=self.themergbbgB[xtexs.bg2frontA.colorindex].g,
							b=self.themergbbgB[xtexs.bg2frontA.colorindex].b,
							alpha=xtexs.bg2frontA.alpha,
						}
					end
					if mytable then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.bg2_frontA:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "bg2_deco_frontB" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.bg2frontB.tex,
							scalex=xtexs.bg2frontB.scale,
							r=self.themergbbgB[xtexs.bg2frontB.colorindex].r,
							g=self.themergbbgB[xtexs.bg2frontB.colorindex].g,
							b=self.themergbbgB[xtexs.bg2frontB.colorindex].b,
							alpha=xtexs.bg2frontB.alpha,
						}
					end
					if mytable then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.bg2_frontB:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end

			-- BG LAYER 1
			-- ***********
			elseif layer2.name == "bg1_deco_backB" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.bg1backB.tex,
							scalex=xtexs.bg1backB.scale,
							r=self.themergbbgA[xtexs.bg1backB.colorindex].r,
							g=self.themergbbgA[xtexs.bg1backB.colorindex].g,
							b=self.themergbbgA[xtexs.bg1backB.colorindex].b,
							alpha=xtexs.bg1backB.alpha,
						}
					end
					if mytable then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.bg1_backB:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "bg1_deco_backA" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.bg1backA.tex,
							scalex=xtexs.bg1backA.scale,
							r=self.themergbbgA[xtexs.bg1backA.colorindex].r,
							g=self.themergbbgA[xtexs.bg1backA.colorindex].g,
							b=self.themergbbgA[xtexs.bg1backA.colorindex].b,
							alpha=xtexs.bg1backA.alpha,
						}
					end
					if mytable then
						levelsetup = {
--							shapelinewidth=2, shapelinecolor=0xffffff, shapelinealpha=0.3,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.bg1_backA:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "bg1_deco_base" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.bg1base.tex,
							scalex=xtexs.bg1base.scale,
							r=self.themergbbgA[xtexs.bg1base.colorindex].r,
							g=self.themergbbgA[xtexs.bg1base.colorindex].g,
							b=self.themergbbgA[xtexs.bg1base.colorindex].b,
							alpha=xtexs.bg1base.alpha,
						}
					end
					if mytable then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.bg1_base:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "bg1_deco_frontA" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.bg1frontA.tex,
							scalex=xtexs.bg1frontA.scale,
							r=self.themergbbgA[xtexs.bg1frontA.colorindex].r,
							g=self.themergbbgA[xtexs.bg1frontA.colorindex].g,
							b=self.themergbbgA[xtexs.bg1frontA.colorindex].b,
							alpha=xtexs.bg1frontA.alpha,
						}
					end
					if mytable then
						levelsetup = {
--							shapelinewidth=2, shapelinecolor=0xffffff, shapelinealpha=0.3,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.bg1_frontA:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "bg1_deco_frontB" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.bg1frontB.tex,
							scalex=xtexs.bg1frontB.scale,
							r=self.themergbbgA[xtexs.bg1frontB.colorindex].r,
							g=self.themergbbgA[xtexs.bg1frontB.colorindex].g,
							b=self.themergbbgA[xtexs.bg1frontB.colorindex].b,
							alpha=xtexs.bg1frontB.alpha,
						}
					end
					if mytable then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.bg1_frontB:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			end
		end

	-- GROUPED FGs
	-- ***********
	elseif xlayer.name == "FGs" then
		local layers2 = xlayer.layers
		for i = 1, #layers2 do
			local layer2 = layers2[i]
			-- FGs DECO
			-- ********
			if layer2.name == "fg1_deco_backB" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.fg1backB.tex,
							scalex=xtexs.fg1backB.scale,
							r=self.themergbfgA[xtexs.fg1backB.colorindex].r,
							g=self.themergbfgA[xtexs.fg1backB.colorindex].g,
							b=self.themergbfgA[xtexs.fg1backB.colorindex].b,
							alpha=xtexs.fg1backB.alpha,
						}
					end
					if mytable ~= nil then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.fg1_backB:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "fg1_deco_backA" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.fg1backA.tex,
							scalex=xtexs.fg1backA.scale,
							r=self.themergbfgA[xtexs.fg1backA.colorindex].r,
							g=self.themergbfgA[xtexs.fg1backA.colorindex].g,
							b=self.themergbfgA[xtexs.fg1backA.colorindex].b,
							alpha=xtexs.fg1backA.alpha,
						}
					end
					if mytable then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.fg1_backA:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "fg1_deco_base" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.fg1base.tex,
							scalex=xtexs.fg1base.scale,
							r=self.themergbfgA[xtexs.fg1base.colorindex].r,
							g=self.themergbfgA[xtexs.fg1base.colorindex].g,
							b=self.themergbfgA[xtexs.fg1base.colorindex].b,
							alpha=xtexs.fg1base.alpha,
						}
					end
					if mytable ~= nil then
						levelsetup = {
--							shapelinewidth=2, shapelinecolor=0x0, shapelinealpha=0.7,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.fg1_base:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "fg1_deco_frontA" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.fg1frontA.tex,
							scalex=xtexs.fg1frontA.scale,
							r=self.themergbfgA[xtexs.fg1frontA.colorindex].r,
							g=self.themergbfgA[xtexs.fg1frontA.colorindex].g,
							b=self.themergbfgA[xtexs.fg1frontA.colorindex].b,
							alpha=xtexs.fg1frontA.alpha,
						}
					end
					if mytable ~= nil then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.fg1_frontA:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "fg1_deco_frontB" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.fg1frontB.tex,
							scalex=xtexs.fg1frontB.scale,
							r=self.themergbfgA[xtexs.fg1frontB.colorindex].r,
							g=self.themergbfgA[xtexs.fg1frontB.colorindex].g,
							b=self.themergbfgA[xtexs.fg1frontB.colorindex].b,
							alpha=xtexs.fg1frontB.alpha,
						}
					end
					if mytable ~= nil then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.fg1_frontB:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			end

			if layer2.name == "fg2_deco_backB" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.fg2backB.tex,
							scalex=xtexs.fg2backB.scale,
							r=self.themergbfgB[xtexs.fg2backB.colorindex].r,
							g=self.themergbfgB[xtexs.fg2backB.colorindex].g,
							b=self.themergbfgB[xtexs.fg2backB.colorindex].b,
							alpha=xtexs.fg2backB.alpha,
						}
					end
					if mytable ~= nil then
						levelsetup = {
--							shapelinewidth=2, shapelinecolor=0x0, shapelinealpha=0.7,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.fg2_backB:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "fg2_deco_backA" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.fg2backA.tex,
							scalex=xtexs.fg2backB.scale,
							r=self.themergbfgB[xtexs.fg2backB.colorindex].r,
							g=self.themergbfgB[xtexs.fg2backB.colorindex].g,
							b=self.themergbfgB[xtexs.fg2backB.colorindex].b,
							alpha=xtexs.fg2backB.alpha,
						}
					end
					if mytable ~= nil then
						levelsetup = {
--							shapelinewidth=2, shapelinecolor=0x0, shapelinealpha=0.7,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.fg2_backA:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "fg2_deco_base" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.fg2base.tex,
							scalex=xtexs.fg2base.scale,
							r=self.themergbfgB[xtexs.fg2base.colorindex].r,
							g=self.themergbfgB[xtexs.fg2base.colorindex].g,
							b=self.themergbfgB[xtexs.fg2base.colorindex].b,
							alpha=xtexs.fg2base.alpha,
						}
					end
					if mytable ~= nil then
						levelsetup = {
--							shapelinewidth=2, shapelinecolor=0x0, shapelinealpha=0.7,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.fg2_base:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "fg2_deco_frontA" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.fg2frontA.tex,
							scalex=xtexs.fg2frontA.scale,
							r=self.themergbfgB[xtexs.fg2frontA.colorindex].r,
							g=self.themergbfgB[xtexs.fg2frontA.colorindex].g,
							b=self.themergbfgB[xtexs.fg2frontA.colorindex].b,
							alpha=xtexs.fg2frontA.alpha,
						}
					end
					if mytable ~= nil then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.fg2_frontA:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			elseif layer2.name == "fg2_deco_frontB" then
				local levelsetup = {}
				local objects = layer2.objects
				for i = 1, #objects do
					local object = objects[i]
					local objectName = object.name
					myshape, mytable = nil, nil
					if objectName == "" then
						mytable = {
							isdeco=true,
							isshape=true,
							texpath=xtexs.fg2frontB.tex,
							scalex=xtexs.fg2frontB.scale,
							r=self.themergbfgB[xtexs.fg2frontB.colorindex].r,
							g=self.themergbfgB[xtexs.fg2frontB.colorindex].g,
							b=self.themergbfgB[xtexs.fg2frontB.colorindex].b,
							alpha=xtexs.fg2frontB.alpha,
						}
					end
					if mytable ~= nil then
						levelsetup = {
--							shapelinewidth=1, shapelinecolor=0x0, -- shapelinealpha=0.5,
						}
						for k, v in pairs(mytable) do levelsetup[k] = v end
						myshape = self:buildShapes(object, levelsetup)
						myshape:setPosition(object.x, object.y)
						self.fg2_frontB:addChild(myshape)
						-- list
						if object.name == "" then
							self.world.grounds[#self.world.grounds + 1] = myshape
						end
					end
				end
			end
		end
	end
end

function Tiled_Levels:buildShapes(xobject, xlevelsetup)
	local myshape = nil
	local tablebase = {}
	if xobject.shape == "ellipse" then
		tablebase = {
			x = xobject.x, y = xobject.y,
			w = xobject.width, h = xobject.height, rotation = xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Ellipse.new(self.world, tablebase)
	elseif xobject.shape == "polygon" then
		tablebase = {
			x = xobject.x, y = xobject.y,
			coords = xobject.polygon, rotation = xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Polygon.new(self.world, tablebase)
	elseif xobject.shape == "polyline" then
		tablebase = {
			x = xobject.x, y = xobject.y,
			coords = xobject.polyline, rotation = xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Polygon.new(self.world, tablebase)
	elseif xobject.shape == "rectangle" then
		tablebase = {
			x = xobject.x, y = xobject.y,
			w = xobject.width, h = xobject.height, rotation = xobject.rotation,
		}
		for k, v in pairs(xlevelsetup) do tablebase[k] = v end
		myshape = Tiled_Shape_Rectangle.new(self.world, tablebase)
	else
		print("*** CANNOT PROCESS THIS SHAPE! ***", xobject.shape, xobject.name)
		return
	end

	return myshape
end

local timer, particlestable, particlestable2 = 0
function Tiled_Levels:onEnterFrame(e)
	-- timer
	timer += 1
	--	tag, decay, decayAngular, decayGrowth, decayAlpha,
	if g_currentlevel == 2 then
		particlestable = {
			x=math.random(self.mapwidth),
			y=math.random(self.mapheight * 0.5, self.mapheight),
			size=128, angle=math.random(360),
			color=0xffffff, alpha=0.6,
			ttl=64*32,
			speedX=0.01, speedY=0.01,
			speedAngular=0.04, speedGrowth=0.07,
--			decayAngular=0.5, decayGrowth=1, decayAlpha=1
		}
		particlestable2 = {
			x=math.random(self.mapwidth),
			y=math.random(self.mapheight * 0.5, self.mapheight),
			size=128, angle=math.random(360/2),
			color=0xffffff, alpha=0.4,
			ttl=64*16,
			speedX=0.01, speedY=0.01,
			speedAngular=0.015, speedGrowth=0.1,
			decayAngular=0.5, --decayGrowth=1, decayAlpha=1,
		}
		if application:getDeviceInfo() == "Windows" then -- windows
			if timer % 16 == 0 then self.particlesbg:addParticles({particlestable, particlestable2}) end
			if timer % 64 == 0 then self.particlesfg:addParticles({particlestable, particlestable2}) end
		else -- mobile, html5
			if timer % 64 == 0 then self.particlesbg:addParticles({particlestable, particlestable2}) end
			if timer % 64 == 0 then self.particlesfg:addParticles({particlestable, particlestable2}) end
		end
	end
end
