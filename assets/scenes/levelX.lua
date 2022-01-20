LevelX = Core.class(Sprite)

function LevelX:init()
	-- bgm
	self.ambientsound, self.ambientsound2, self.ambientsound3 = nil, nil, nil
	self.ambientsound4, self.ambientsound5, self.ambientsound6 = nil, nil, nil
	if g_currentlevel == 1 then
		self.ambientsound = Sound.new("audio/DM-CGS-16.ogg")
	elseif g_currentlevel == 2 then
		self.ambientsound = Sound.new("audio/Loose_7.wav")
	elseif g_currentlevel == 3 then
		self.ambientsound = Sound.new("audio/DM-CGS-16.ogg")
	end
	self.volume = g_sfxvolume * 0.01 * 0.7
	self.channelA = self.ambientsound:play(0, 0, 1)
	-- b2d world
	if g_currentlevel == 1 then self.world = b2.World.new(0, 20, true) -- XXX
	elseif g_currentlevel == 2 then self.world = b2.World.new(0, 20, true) -- XXX
	else self.world = b2.World.new(0, 20, true) -- XXX
	end
	-- lists
	self.world.grounds = {}
	self.world.groundnmes = {}
	self.world.airnmes = {}
	self.world.groundfriendlies = {}
	self.world.airfriendlies = {}
	self.world.collectibles = {}
	self.world.doors = {}
	-- the tiled level
	self.tiled_level = Tiled_Levels.new(self.world, tiled_levels[g_currentlevel])

--[[
	-- debug draw
	self.world.isdebug = true
	local debugDraw = b2.DebugDraw.new()
	debugDraw:setFlags(
		b2.DebugDraw.SHAPE_BIT
		+ b2.DebugDraw.JOINT_BIT
--		+ b2.DebugDraw.AABB_BIT
		+ b2.DebugDraw.PAIR_BIT
		+ b2.DebugDraw.CENTER_OF_MASS_BIT
	)
	self.world:setDebugDraw(debugDraw)
	self.tiled_level.camera:addChild(debugDraw)
]]

	-- ui lives
	self.ui = Sprite.new()
	self.world.lives = {}
	for i = 1, self.world.player1.body.currentlives do
		local life = Bitmap.new(Texture.new("gfx/ui/item3.png"))
		self.world.lives[#self.world.lives + 1] = life
		life:setPosition((i-1) * 52, 8 + myapptop)
		self.ui:addChild(life)
	end
	-- ui nrg
	self.world.nrgbar = Pixel.new(0x00ff00, 1, self.world.player1.body.currentnrg * 40, 32)
	self.world.nrgbar:setPosition(16, 64 + myapptop)
	-- ui score
	self.world.score = 0
	self.world.scoretf = TextField.new(nil, "SCORE: "..self.world.score)
	self.world.scoretf:setScale(4)
	self.world.scoretf:setPosition(256, 50 + myapptop)
	self.world.scoretf:setTextColor(0x00ffff)
	-- gcam
	self.gcam = GCam.new(self.tiled_level.camera)
--	self.gcam:setDebug(true)
	self.gcam:setFollow(self.world.player1.body)
	self.gcam:setAutoSize(true)
	-- local color function
	local function hex2rgb(hex)
		local rgbtable = {}
		rgbtable.r, rgbtable.g, rgbtable.b =
			(hex >> 16 & 0xff) / 255, (hex >> 8 & 0xff) / 255, (hex & 0xff) / 255
		return rgbtable
	end
	-- levels setup
	if g_currentlevel == 1 then
		-- fixed bg image
--		self.bgimg = Pixel.new(Texture.new("tiled/levels/parallax_bgs/forestXX.png"))
--		self.bgimg:setDimensions(myappwidth, myappheight)
--		self.bgimg:setAnchorPoint(0.5, 0.5)
--		self.bgimg:setAlpha(0.12)
--		self.bgimg:setScale(2)
--		self.bgimg:setPosition(myappwidth/2, myappheight/2-64*0)
--		self:addChild(self.bgimg)
		-- gcam
		self.gcam:setAnchor(0.4, 0.53)
		self.gcam:setZoom(2.2) -- 2.5, 3
		self.gcamleft = myappwidth/2/self.gcam:getZoom()*self.gcam:getAnchorX()
		self.gcamtop = 0
		self.gcamright = (self.tiled_level.mapwidth - self.gcamleft)
		self.gcambottom = (self.tiled_level.mapheight - myappheight/2/self.gcam:getZoom()) / self.gcam:getAnchorY()
	elseif g_currentlevel == 2 then
		-- fixed bg image
		self.bgimg = Pixel.new(Texture.new("tiled/levels/parallax_bgs/mountain_village2.png"))
		local rgb = hex2rgb(0xa3ddf2)
		self.bgimg:setColorTransform(rgb.r, rgb.g, rgb.b, 2)
		self.bgimg:setAnchorPoint(0.5, 0.5)
		self.bgimg:setScale(2)
		self.bgimg:setPosition(myappwidth/2, myappheight/2+64*2)
		self:addChild(self.bgimg)
		-- gcam
		self.gcam:setAnchor(0.4, 0.53)
		self.gcam:setZoom(2) -- 2
		self.gcamleft = myappwidth/2/self.gcam:getZoom()*self.gcam:getAnchorX()
		self.gcamtop = 0
		self.gcamright = (self.tiled_level.mapwidth - self.gcamleft)
		self.gcambottom = (self.tiled_level.mapheight - myappheight/2/self.gcam:getZoom()) / self.gcam:getAnchorY()
	elseif g_currentlevel == 3 then
		-- fixed bg image
--		self.bgimg = Pixel.new(Texture.new("tiled/levels/parallax_bgs/mountain_village2.png"))
--		local rgb = hex2rgb(0xa3ddf2)
--		self.bgimg:setColorTransform(rgb.r, rgb.g, rgb.b, 2)
--		self.bgimg:setAnchorPoint(0.5, 0.5)
--		self.bgimg:setScale(2)
--		self.bgimg:setPosition(myappwidth/2, myappheight/2+64*2)
--		self:addChild(self.bgimg)
		-- gcam
		self.gcam:setAnchor(0.4, 0.53)
		self.gcam:setZoom(2) -- 2
		self.gcamleft = myappwidth/2/self.gcam:getZoom()*self.gcam:getAnchorX()
		self.gcamtop = 0
		self.gcamright = (self.tiled_level.mapwidth - self.gcamleft)
		self.gcambottom = (self.tiled_level.mapheight - myappheight/2/self.gcam:getZoom()) / self.gcam:getAnchorY()
	else
		print("error!!!", "level: "..g_currentlevel.." does not exist!")
	end
	self.gcam:setBounds(self.gcamleft, self.gcamtop, self.gcamright, self.gcambottom)
	-- nmes lists
	for k, v in pairs(self.world.groundnmes) do
		self.tiled_level.mg:addChild(k)
	end
	for k, v in pairs(self.world.airnmes) do
		self.tiled_level.mg:addChild(k)
	end
	-- gameplay elements lists
	for k, v in pairs(self.world.doors) do -- body, object
		v.img:setColorTransform(255/4/255,255/4/255,255/4/255)
	end
	-- order
	self:addChild(self.gcam)
	self:addChild(self.world.nrgbar)
	self:addChild(self.world.scoretf)
	-- mobile controls
	if application:getDeviceInfo() == "Android" or g_show_mobile then
--		local mobile = MobileXv1.new(self.world.player1)
--		self:addChild(mobile)
	end
	self:addChild(self.ui)
	-- BOX2D LISTENERS
	self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	self.world:addEventListener(Event.END_CONTACT, self.onEndContact, self)
	self.world:addEventListener(Event.PRE_SOLVE, self.onPreSolveContact, self)
	self.world:addEventListener(Event.POST_SOLVE, self.onPostSolveContact, self)
	-- LISTENERS
	self.ispaused = false
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

-- loop
local zdist = math.distance -- optim
local timer = 0
local player1x, player1y
local camposx, camposy
GroundVisibDist = myappwidth -- /1.5
function LevelX:onEnterFrame(e)
	-- timer
	timer += 1
	-- player position
	player1x, player1y = self.world.player1.body:getPosition()
	camposx, camposy = self.gcam.x, self.gcam.y
	-- gcam
	self.gcam:update(e.deltaTime) -- e.deltaTime 1/60
	if self.ispaused then return end
	if self.world.player1.body.isdead and self.world.player1.body.timer <= 0 then self:reload() end
	-- liquidfun
	self.world:step(e.deltaTime, 8, 3) -- e.deltaTime 1/60, 8, 3
	-- perfs?
	for i = 1, #self.world.grounds do -- sprite
		local x1, y1 = self.world.grounds[i].img:getPosition()
		local dist = zdist(x1, y1, player1x, player1y)
		if dist > GroundVisibDist then -- magik XXX
			self.world.grounds[i]:setVisible(false)
--			print(#self.world.grounds, zdist(x1, y1, player1x, player1y))
		else
			self.world.grounds[i]:setVisible(true)
		end
	end
	-- fixed bg img
--	self.bgimg:setRotation(timer)
--	self.bgimg:setTexturePosition(-player1x*self.bgvx, -self.bgy-player1y*self.bgvy)
--	self.bgimg:setTexturePosition(myappwidth/2, myappheight/2)
	-- parallax
	if self.tiled_level.parallaxB3 then self.tiled_level.parallaxB1:setTexturePosition(camposx*0.1, 0) end
	if self.tiled_level.parallaxB2 then self.tiled_level.parallaxB2:setTexturePosition(camposx*0.2, 0) end
--	if self.tiled_level.parallaxB1 then self.tiled_level.parallaxB3:setTexturePosition(-camposx*0.25, 0) end
	if self.tiled_level.parallaxF1 then self.tiled_level.parallaxF1:setTexturePosition(-camposx*0.5, 0) end
	-- audio
--	if timer % (5 * 64) == 0 then if self.ambientsound then self:audio(self.ambientsound) end
	if timer % (8 * 64) == 0 then if self.ambientsound2 then self:audio(self.ambientsound2) end
--	elseif timer % (8 * 64) == 0 then if self.ambientsound2 then self:audio(self.ambientsound2) end
	elseif timer % (11 * 64) == 0 then if self.ambientsound3 then self:audio(self.ambientsound3) end
	elseif timer % (14 * 64) == 0 then if self.ambientsound4 then self:audio(self.ambientsound4) end
	elseif timer % (18 * 64) == 0 then if self.ambientsound5 then self:audio(self.ambientsound5) end
	end
	-- playable AI
	self:AI()
	-- player1
	if self.world.player1.body.isdirty then self.gcam:shake(3, 24) end
end

-- BOX2D
function LevelX:onBeginContact(e)
	local fixtureA, fixtureB = e.fixtureA, e.fixtureB
	local bodyA, bodyB = fixtureA:getBody(), fixtureB:getBody()
	-- PLAYER1
	if (bodyA.role == G_PLAYER and bodyB.role == G_GROUND) or (bodyA.role == G_GROUND and bodyB.role == G_PLAYER) then
		local vx, vy
		if bodyA.role == G_PLAYER then
			_, vy = bodyA:getLinearVelocity()
			bodyA.numfloorcontacts += 1
			if vy > 0 then bodyA.numjumpcount = bodyA.maxnumjump end -- going down
		else bodyB.numfloorcontacts += 1
			_, vy = bodyB:getLinearVelocity()
			if vy > 0 then bodyB.numjumpcount = bodyB.maxnumjump end -- going down
		end
	end

	if (bodyA.role == G_PLAYER and bodyB.role == G_COLLECTIBLE) or (bodyA.role == G_COLLECTIBLE and bodyB.role == G_PLAYER) then
		if bodyA.role == G_COLLECTIBLE then
			bodyA.isdirty = true -- coins
			if bodyA.data then -- keys
				self.world.doors[bodyA.data].img:setColorTransform(355/255,355/255,355/255)
				self.world.doors[bodyA.data].isactive = true
			end
		else
			bodyB.isdirty = true -- coins
			if bodyB.data then -- keys
				self.world.doors[bodyB.data].img:setColorTransform(355/255,355/255,355/255)
				self.world.doors[bodyB.data].isactive = true
			end
		end
	end
	if (bodyA.role == G_PLAYER and bodyB.role == G_DOOR) or (bodyA.role == G_DOOR and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then
			if bodyB.isactive then bodyB.isdirty = true end
		else
			if bodyA.isactive then bodyA.isdirty = true end
		end
	end
	if (bodyA.role == G_PLAYER and bodyB.role == G_WALL) or (bodyA.role == G_WALL and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then bodyA.numwallcontacts += 1 -- bodyA.numjumpcount = bodyA.maxnumjump
		else bodyB.numwallcontacts += 1 -- bodyB.numjumpcount = bodyB.maxnumjump
		end
	end
	if (bodyA.role == G_PLAYER and bodyB.role == G_LADDER) or (bodyA.role == G_LADDER and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then bodyA.numladdercontacts += 1 bodyA.numjumpcount = bodyA.maxnumjump
		else bodyB.numladdercontacts += 1 bodyB.numjumpcount = bodyB.maxnumjump
		end
	end
	if (bodyA.role == G_PLAYER and bodyB.role == G_DANGER) or (bodyA.role == G_DANGER and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then bodyA.isdirty = true
		else bodyB.isdirty = true
		end
	end
	if (bodyA.role == G_PLAYER and bodyB.role == G_PTPLATFORM) or (bodyA.role == G_PTPLATFORM and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then
			local _, vy = bodyA:getLinearVelocity()
			bodyA.numptpfcontacts += 1
			if vy > 0 then bodyA.numjumpcount = bodyA.maxnumjump end -- going down
--			bodyB.img:setColorTransform(355/255,355/255,355/255)
--			bodyB.colored = 1
		else
			local _, vy = bodyB:getLinearVelocity()
			bodyB.numptpfcontacts += 1
			if vy > 0 then bodyB.numjumpcount = bodyB.maxnumjump end -- going down
--			bodyA.img:setColorTransform(355/255,355/255,355/255)
--			bodyA.colored = 1
		end
	end
	if (bodyA.role == G_PLAYER and bodyB.role == G_MVPLATFORM) or (bodyA.role == G_MVPLATFORM and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then
			local _, vy = bodyA:getLinearVelocity()
			bodyA.nummvpfcontacts += 1
			if vy > 0 then bodyA.numjumpcount = bodyA.maxnumjump end -- going down
		else
			local _, vy = bodyB:getLinearVelocity()
			bodyB.nummvpfcontacts += 1
			if vy > 0 then bodyB.numjumpcount = bodyB.maxnumjump end -- going down
		end
	end
	if (bodyA.role == G_PLAYER and bodyB.role == G_EXIT) or (bodyA.role == G_EXIT and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then bodyB.isdirty = true
		else bodyA.isdirty = true
		end
	end
	-- NME
	if (bodyA.role == G_ENEMY and bodyB.role == G_PLAYER) or (bodyA.role == G_PLAYER and bodyB.role == G_ENEMY) then
		if bodyA.role == G_ENEMY then
			if not fixtureA:isSensor() and not fixtureB:isSensor() then
--				print("isonme")
				local _, vy = bodyB:getLinearVelocity()
				if vy > 1 then bodyA.isdirty = true bodyB.isonme = true -- magik XXX
				else if not bodyB.needrecover then bodyB.isdirty = true end
				end
			end
		else
			if not fixtureB:isSensor() and not fixtureA:isSensor() then
--				print("isonme")
				local _, vy = bodyA:getLinearVelocity()
				if vy > 1 then bodyB.isdirty = true bodyA.isonme = true -- magik XXX
				else if not bodyA.needrecover then bodyA.isdirty = true end
				end
			end
		end
	end
	if (bodyA.role == G_ENEMY and bodyB.role == G_GROUND) or (bodyA.role == G_GROUND and bodyB.role == G_ENEMY) then
		if bodyA.role == G_ENEMY then bodyA.numfloorcontacts += 1  bodyA.numjumpcount = bodyA.maxnumjump --bodyA.canjump = true
		else bodyB.numfloorcontacts += 1 bodyB.numjumpcount = bodyB.maxnumjump --bodyB.canjump = true
		end
	end
	if (bodyA.role == G_ENEMY and bodyB.role == G_LADDER) or (bodyA.role == G_LADDER and bodyB.role == G_ENEMY) then
		if bodyA.role == G_ENEMY then bodyA.numladdercontacts += 1 bodyA.numjumpcount = bodyA.maxnumjump
		else bodyB.numladdercontacts += 1 bodyB.numjumpcount = bodyB.maxnumjump
		end
	end
	if (bodyA.role == G_ENEMY and bodyB.role == G_PTPLATFORM) or (bodyA.role == G_PTPLATFORM and bodyB.role == G_ENEMY) then
		if bodyA.role == G_ENEMY then
			bodyA.numptpfcontacts += 1
			if bodyA.isdown then bodyA.isgoingdownplatform = true
			else bodyA.isgoingdownplatform = false
			end
		else
			bodyB.numptpfcontacts += 1
			if bodyB.isdown then bodyB.isgoingdownplatform = true
			else bodyB.isgoingdownplatform = false
			end
		end
	end
	if (bodyA.role == G_ENEMY and bodyB.role == G_MVPLATFORM) or (bodyA.role == G_MVPLATFORM and bodyB.role == G_ENEMY) then
		if bodyA.role == G_ENEMY then bodyA.nummvpfcontacts += 1 bodyA.numjumpcount = bodyA.maxnumjump
		else bodyB.nummvpfcontacts += 1 bodyB.numjumpcount = bodyB.maxnumjump
		end
	end
	if (bodyA.role == G_ENEMY and bodyB.role == G_BLOCK) or (bodyA.role == G_BLOCK and bodyB.role == G_ENEMY) then
		if bodyA.role == G_ENEMY then bodyA.isleft = not bodyA.isleft bodyA.isright = not bodyA.isright
		else bodyB.isleft = not bodyB.isleft bodyB.isright = not bodyB.isright
		end
	end
	-- BULLETS
	if bodyA.role == G_PLAYER_BULLET or bodyB.role == G_PLAYER_BULLET then
		if bodyA.role == G_DOOR then
			bodyB.isdirty = true
			if bodyA.isactive then bodyA.isdirty = true end
		elseif bodyB.role == G_DOOR then
			bodyA.isdirty = true
			if bodyB.isactive then bodyB.isdirty = true end
		else
			bodyA.isdirty = true bodyB.isdirty = true
		end
	end
	if bodyA.role == G_ENEMY_BULLET or bodyB.role == G_ENEMY_BULLET then
		if bodyA.role == G_PLAYER then
			if not bodyA.needrecover then bodyA.isdirty = true bodyB.isdirty = true end
		elseif bodyB.role == G_PLAYER then
			if not bodyB.needrecover then bodyB.isdirty = true bodyA.isdirty = true end
		else
			bodyA.isdirty = true bodyB.isdirty = true
		end
	end
end

function LevelX:onEndContact(e)
	local fixtureA, fixtureB = e.fixtureA, e.fixtureB
	local bodyA, bodyB = fixtureA:getBody(), fixtureB:getBody()
	-- PLAYER1
	if (bodyA.role == G_PLAYER and bodyB.role == G_GROUND) or (bodyA.role == G_GROUND and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then bodyA.numfloorcontacts -= 1
		else bodyB.numfloorcontacts -= 1
		end
	end
	if (bodyA.role == G_PLAYER and bodyB.role == G_WALL) or (bodyA.role == G_WALL and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then bodyA.numwallcontacts -= 1
		else bodyB.numwallcontacts -= 1
		end
	end
	if (bodyA.role == G_PLAYER and bodyB.role == G_LADDER) or (bodyA.role == G_LADDER and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then bodyA.numladdercontacts -= 1
		else bodyB.numladdercontacts -= 1
		end
	end
	if (bodyA.role == G_PLAYER and bodyB.role == G_PTPLATFORM) or (bodyA.role == G_PTPLATFORM and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then bodyA.numptpfcontacts -= 1
		else bodyB.numptpfcontacts -= 1
		end
	end
	if (bodyA.role == G_PLAYER and bodyB.role == G_MVPLATFORM) or (bodyA.role == G_MVPLATFORM and bodyB.role == G_PLAYER) then
		if bodyA.role == G_PLAYER then bodyA.nummvpfcontacts -= 1
		else bodyB.nummvpfcontacts -= 1
		end
	end
	-- NME
	if (bodyA.role == G_ENEMY and bodyB.role == G_PLAYER) or (bodyA.role == G_PLAYER and bodyB.role == G_ENEMY) then
		if bodyA.role == G_ENEMY then bodyB.isonme = false
		else bodyA.isonme = false
		end
	end
	if (bodyA.role == G_ENEMY and bodyB.role == G_GROUND) or (bodyA.role == G_GROUND and bodyB.role == G_ENEMY) then
		if bodyA.role == G_ENEMY then bodyA.numfloorcontacts -= 1
		else bodyB.numfloorcontacts -= 1
		end
	end
	if (bodyA.role == G_ENEMY and bodyB.role == G_LADDER) or (bodyA.role == G_LADDER and bodyB.role == G_ENEMY) then
		if bodyA.role == G_ENEMY then bodyA.numladdercontacts -= 1
		else bodyB.numladdercontacts -= 1
		end
	end
	if (bodyA.role == G_ENEMY and bodyB.role == G_PTPLATFORM) or (bodyA.role == G_PTPLATFORM and bodyB.role == G_ENEMY) then
		if bodyA.role == G_ENEMY then bodyA.numptpfcontacts -= 1
		else bodyB.numptpfcontacts -= 1
		end
	end
	if (bodyA.role == G_ENEMY and bodyB.role == G_MVPLATFORM) or (bodyA.role == G_MVPLATFORM and bodyB.role == G_ENEMY) then
		if bodyA.role == G_ENEMY then bodyA.nummvpfcontacts -= 1
		else bodyB.nummvpfcontacts -= 1
		end
	end
end

function LevelX:onPreSolveContact(e)
	local bodyA = e.fixtureA:getBody()
	local bodyB = e.fixtureB:getBody()
	local platform, playable
	if bodyA.role == G_PTPLATFORM then platform = bodyA playable = bodyB
	elseif bodyB.role == G_PTPLATFORM then platform = bodyB playable = bodyA
	end
	if not platform then return end
	-- playable
	if playable.isgoingdownplatform then e.contact:setEnabled(false) return end
	-- pass through platform
	local _, vy = playable:getLinearVelocity()
	-- going up = no collision, -1 otherwise slides XXX
	if vy < -2 then e.contact:setEnabled(false) end -- vy < -1
end

function LevelX:onPostSolveContact(e)
end

-- functions
PlayableVisibDist = myappwidth/2
PlayerDistance = myappwidth/3
function LevelX:AI()
	-- GROUND NMES
	-- ***********
	for k, v in pairs(self.world.groundnmes) do -- self, body
		local x1, y1 = v:getPosition()
		-- performances
		if zdist(x1, y1, player1x, player1y) > PlayableVisibDist then k:setVisible(false) v:setActive(false)
		else k:setVisible(true) v:setActive(true)
		end
		-- ai
		if v.isdirty then
--			v.isright = not v.isright v.isleft = not v.isleft
		elseif zdist(x1, y1, player1x, player1y) < PlayerDistance then
			-- follow
			if x1 > player1x + PlayerDistance / 2 then v.isleft = true v.isright = false
			elseif x1 < player1x - PlayerDistance / 2 then v.isright = true v.isleft = false
			else
				if timer % (2.5 * 64) == 0 then v.isright = true v.isleft = false end
				if timer % (4.5 * 64) == 0 then v.isright = false v.isleft = true end
			end
			if y1 > player1y then -- jump
				if timer % (4 * 64) == 0 then v.isup = true v.isdown = false
				else v.isup = false v.isdown = false
				end
			end
			-- attack
			if timer % (3 * 64) == 0 then v.isspace = true end
--			if timer % (2 * 64) == 0 then v.isup = true end
		else
			-- roaming
			if timer % (2 * 64) == 0 then v.isright = true v.isleft = false end
			if timer % (4 * 64) == 0 then v.isright = false v.isleft = true end
		end
	end
	-- AIR NMES
	-- ********
	for k, v in pairs(self.world.airnmes) do -- self, body
		local x1, y1 = v:getPosition()
		-- performances
		if zdist(x1, y1, player1x, player1y) > PlayableVisibDist then k:setVisible(false) v:setActive(false)
		else k:setVisible(true) v:setActive(true)
		end
		-- ai
		if v.isdirty then
--			v.isright = not v.isright v.isleft = not v.isleft
		elseif zdist(x1, y1, player1x, player1y) < 256 then
			-- follow
			if x1 > player1x + PlayerDistance / 2.5 then v.isleft = true v.isright = false
			elseif x1 < player1x - PlayerDistance / 2.5 then v.isright = true v.isleft = false
			else
				if timer % (1.5 * 64) == 0 then v.isright = true v.isleft = false end
				if timer % (2.5 * 64) == 0 then v.isright = false v.isleft = true end
			end
			if y1 > player1y then -- jump
--				v:applyLinearImpulse(0, -v:getMass()/2, v:getWorldCenter())
				if timer % (0.5 * 64) == 0 then v.isup = true v.isdown = false
				else v.isup = false v.isdown = false
				end
			end
			-- attack
			if timer % (1 * 128) == 0 then if not v.isdirty then v.isspace = true end end -- 96
		else
			-- roaming
			if timer % (2 * 64) == 0 then v.isright = true v.isleft = false end
			if timer % (4 * 64) == 0 then v.isright = false v.isleft = true end
		end
	end
end

function LevelX:audio(xsound)
	if not self.channelA:isPlaying() then self.channelA = xsound:play() end
	self.channelA:setVolume(self.volume)
end

-- EVENT LISTENERS
function LevelX:onTransitionInBegin() self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self) end
function LevelX:onTransitionInEnd()
	self:myKeysPressed()
	-- PLAYER1 LISTENERS
	self:addEventListener(Event.KEY_DOWN, self.world.player1.onKeyDown, self.world.player1)
	self:addEventListener(Event.KEY_UP, self.world.player1.onKeyUp, self.world.player1)
end
function LevelX:onTransitionOutBegin() self.channelA:stop() self:removeAllListeners() end
function LevelX:onTransitionOutEnd() end

-- KEYS HANDLER
function LevelX:myKeysPressed()
	self:addEventListener(Event.KEY_DOWN, function(e)
		-- for mobiles and desktops
		if e.keyCode == KeyCode.BACK or e.keyCode == KeyCode.ESC then self:back()
		elseif e.keyCode == KeyCode.P then self.ispaused = not self.ispaused
		elseif e.keyCode == KeyCode.R then self.ispaused = not self:reload()
		end
		-- modifier
		local modifier = application:getKeyboardModifiers()
		local alt = (modifier & KeyCode.MODIFIER_ALT) > 0
		-- switch full screen
		if alt and e.keyCode == KeyCode.ENTER then isfullscreen = not isfullscreen setFullScreen(isfullscreen) end
	end)
end

function LevelX:reload() scenemanager:changeScene("levelX", 2, transitions[19], easings[1]) end

function LevelX:back()
	--scenemanager:changeScene("level_select", 1, transitions[17], easings[29])
end
