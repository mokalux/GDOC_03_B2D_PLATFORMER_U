Player = Core.class(Character_Base)

function Player:init()
	-- anims
	Character_Base.createAnim(self, "idle", 1, 99) -- 100
	Character_Base.createAnim(self, "run", 100 + 1, 100 + 8) -- 8
	Character_Base.createAnim(self, "jumpup", 100 + 8 + 1, 100 + 8 + 1) -- 2
	Character_Base.createAnim(self, "jumpdown", 100 + 8 + 1 + 1, 100 + 8 + 1 + 1) -- 0
	Character_Base.createAnim(self, "hurt", 19, 20) -- 0
	Character_Base.createAnim(self, "death", 1, 99) -- 0
	Character_Base.createAnim(self, "climbup", 100 + 8 + 1 + 1 + 1, 100 + 8 + 1 + 1 + 10) -- 10
	Character_Base.createAnim(self, "climbidle", 100 + 8 + 1 + 1 + 1, 100 + 8 + 1 + 1 + 1) -- 0
	Character_Base.createAnim(self, "climbdown", 100 + 8 + 1 + 1 + 10 + 1, 100 + 8 + 1 + 1 + 10 + 10) -- 10
	-- new abilities
	-- recover time
	self.body.needrecover = false
	-- add a second shape to the body to make its collision bigger
	local shape2 = b2.CircleShape.new(0, -self.h/self.body.shapescale, self.w*0.2) -- (centerx, centery, radius) magik XXX
	local fixture2 = self.body:createFixture{
		shape = shape2, density = 1, restitution = 0, friction = 0,
	}
--	local filterData2 = { categoryBits = G_BITPLAYER, maskBits = G_BITENEMY + G_BITENEMYBULLET + G_BITSENSOR, groupIndex = 0 }
	local filterData2 = { categoryBits = G_BITPLAYER, maskBits = G_BITENEMY + G_BITENEMYBULLET, groupIndex = 0 }
	fixture2:setFilterData(filterData2)
	-- clean
	filterData2 = nil
	fixture2 = nil
	shape2 = nil
--[[
	-- new abilities: add a shape to detect ptpf collisions
	local shape3 = b2.CircleShape.new(0, self.h/self.body.shapescale+0.5, 1) -- (centerx, centery, radius)
	local fixture3 = self.body:createFixture{
		shape = shape3, density = 0, restitution = 0, friction = 0.1, -- >= 0.1 otherwise slides
	}
	local filterData3 = { categoryBits = G_BITPLAYER, maskBits = playercollisions, groupIndex = 0 }
	fixture3:setFilterData(filterData3)
]]
--[[
	-- new abilities: add a shape to feet
	local shape3 = b2.CircleShape.new(0, self.h/self.body.shapescale+0.5, 2) -- (centerx, centery, radius)
	local fixture3 = self.body:createFixture{
		shape = shape3, density = 0, restitution = 0, friction = 0.1, issensor = true, -- >= 0.1 otherwise slides
	}
	local filterData3 = { categoryBits = G_BITPLAYER, maskBits = playercollisions, groupIndex = 0 }
	fixture3:setFilterData(filterData3)
	-- clean
	filterData3 = nil
	fixture3 = nil
	shape3 = nil
]]
	-- audio
	self.sndshoot = Sound.new("audio/shoot.wav")
	self.sndhurt = Sound.new("audio/hit-1.wav")
	self.volume = g_sfxvolume * 0.01
	-- a bullet
	self.body.weapon = 1 -- different weapons
	-- listeners
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	self:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	self:addEventListener(Event.KEY_UP, self.onKeyUp, self)
end

-- loop
local flip
local posx, posy
function Player:onEnterFrame(e)
	if self.body.isdirty then
		local sfx = self.sndhurt:play() if sfx then sfx:setVolume(self.volume) end
		self.world.nrgbar:setWidth(self.body.currentnrg * 40) -- magik XXX
		self.body.timer = 48
		self:setColorTransform(0/255, 255/255, 0/255, 4) -- set color to green (recover)
		self.body.needrecover = true
		self.body.isdirty = false
	end
	if self.body.currentnrg <= 0 then
		self.world.lives[self.body.currentlives + 1]:setVisible(false)
		self.body.currentnrg = self.body.nrg
		self.world.nrgbar:setWidth(self.body.currentnrg * 40) -- magik XXX
	end
	-- SHOOT
	-- *****************
	if self.body.isspace then
		if self.body.isdead then return end
--		print("player1 num children", self:getNumChildren())
		-- local vars
		local bullettex
		local bulletscale
		local bulletalpha
		local bulletoffsetx, bulletoffsety
		local fixedrotation
		local gravityscale
		local bulletvel
		local bulletttl
		local bulletdamage
		local isfx
		local fxscale, fxspeedgrowth, fxdecaygrowth
		local fxcolor
		local fxalpha, fxdecayalpha
		local fxnbparticles
		local fxvel
		local fxttl
		if self.body.weapon == 1 then
			bullettex = Texture.new("gfx/fx/ember.png", true)
			bulletscale = 1.5
			bulletalpha = 4
			bulletoffsetx, bulletoffsety = 16, -6
			fixedrotation = false
			gravityscale = 0
			bulletvel = 4
			bulletttl = 8
			bulletdamage = 1
			isfx = true
			fxscale = 3.5 fxspeedgrowth = 1.5 fxdecaygrowth = 0.2
			fxcolor = 0x00ffff
			fxalpha = 1 fxdecayalpha = 0.95
			fxnbparticles = 16
			fxvel = 0.45
			fxttl = 64*1.2
		end
		-- common
		flip = self.body.flip
		posx, posy = self.body:getPosition()
		local tempbulletvx, tempbulletvy
		local tempbulletvel = bulletvel
		local angle
--		if self.world.stones > 0 then
			local sfx = self.sndshoot:play() if sfx then sfx:setVolume(self.volume * 8) end
			if self.body.isup and not (self.body.isleft or self.body.isright) then angle = -45
			elseif self.body.isdown and not (self.body.isleft or self.body.isright) then angle = 45
			elseif self.body.isup and (self.body.isleft or self.body.isright) then
				tempbulletvel *= 2
				angle = -45
			elseif self.body.isdown and (self.body.isleft or self.body.isright) then
				tempbulletvel *= 2
				angle = 45
			elseif self.body.isleft or self.body.isright then
				tempbulletvel *= 2
				angle = 0
			else angle = 0
			end
			tempbulletvx, tempbulletvy = tempbulletvel * math.cos(angle), tempbulletvel * math.sin(angle)
			-- the bullet
			self.bullet = LF_Dynamic_Bullet.new(self.world, {
					tex=bullettex, scale=bulletscale, alpha=bulletalpha,
					fixedrotation=fixedrotation, gravityscale=gravityscale,
					ttl=bulletttl,
					BIT=G_BITPLAYERBULLET, COLBIT=playerbulletcollisions, ROLE=G_PLAYER_BULLET, -- common
					bulletdamage=bulletdamage,
				}
			)
			self.bullet:shoot(posx+bulletoffsetx*flip, posy+bulletoffsety, flip, tempbulletvx*flip, tempbulletvy)
			self:getParent():addChild(self.bullet)
--			self.world.stones -= 1
--			self.world.stonetf:setText(self.world.stones)
			-- the fx?
			if isfx then
				Core.asyncCall(effectTrail, self,
					bullettex, posx+bulletoffsetx*flip, posy+bulletoffsety,
					fxscale, fxspeedgrowth, fxdecaygrowth,
					fxcolor, fxalpha, fxdecayalpha,
					angle*flip, fxnbparticles, fxvel*flip, fxttl)
			end
			-- end
			self.body.isspace = false -- android fix here?
--		end
	end
	-- DEAD?
	-- *****************
	if self.body.isdead then
		flip = self.body.flip
--		self:setColorTransform(128/255, 0/255, 0/255, 2)
		self.body.ishurt = false
		self.body.timer = 60*8 -- magik XXX
		self.world.nrgbar:setWidth(0 * 40) -- magik XXX
		local vx, vy = 0.5 * -flip, -4 -- magik XXX
		local posx, posy = self.body:getPosition()
		-- MOVE IT ALL
		self.body:setLinearVelocity(vx, vy) -- not the best but will do
		self:setPosition(posx, posy)
		if self:getScale() < 5 then self:setScale(1.01 * self:getScale()) end -- magik XXX
		self:playAnim(e.deltaTime)
	end

--[[
	-- DEBUG
	if self.body.isup or self.body.isdown then
	print(
			"floor", self.body.numfloorcontacts,
			"ladder", self.body.numladdercontacts,
			"ptpf", self.body.numptpfcontacts,
			"mvpf", self.body.nummvpfcontacts,
			"***", self.vy, e.deltaTime
		)
	end
]]

end

-- CONTROLS (keyboard, gamepad)
function Player:onKeyDown(e)
	if e.keyCode == KeyCode.LEFT or e.keyCode == g_keyleft then self.body.isleft = true end
	if e.keyCode == KeyCode.RIGHT or e.keyCode == g_keyright then self.body.isright = true end
	if e.keyCode == KeyCode.UP or e.keyCode == g_keyup then self.body.isup = true end
	if e.keyCode == KeyCode.DOWN or e.keyCode == g_keydown then self.body.isdown = true end
	if e.keyCode == KeyCode.SPACE or e.keyCode == g_keyaction1 then self.body.isspace = true end
end

function Player:onKeyUp(e)
	if e.keyCode == KeyCode.LEFT or e.keyCode == g_keyleft then self.body.isleft = false end
	if e.keyCode == KeyCode.RIGHT or e.keyCode == g_keyright then self.body.isright = false end
	if e.keyCode == KeyCode.UP or e.keyCode == g_keyup then self.body.isup = false self.body.canjump = true end
	if e.keyCode == KeyCode.DOWN or e.keyCode == g_keydown then self.body.isdown = false self.body.cangodown = true end
	if e.keyCode == KeyCode.SPACE or e.keyCode == g_keyaction1 then self.body.isspace = false end
end
