--!NEEDS:character_base.lua

Nmes = Core.class(Character_Base)

function Nmes:init()
	-- ANIMS
	-- *****
	if g_currentlevel == 1 then -- ANIMS LEVEL 1
		if self.body.name == "walkerA" then -- ANIMS LEVEL 1
			Character_Base.createAnim(self, "idle", 1, 25)
			Character_Base.createAnim(self, "run", 1, 25)
			Character_Base.createAnim(self, "jumpup", 1, 25)
			Character_Base.createAnim(self, "jumpdown", 1, 25)
			Character_Base.createAnim(self, "hurt", 1, 25)
			Character_Base.createAnim(self, "death", 1, 25)
			Character_Base.createAnim(self, "climbup", 1, 25)
			Character_Base.createAnim(self, "climbidle", 1, 25)
			Character_Base.createAnim(self, "climbdown", 1, 25)
		elseif self.body.name == "walkerBossA" then -- ANIMS LEVEL 1
			Character_Base.createAnim(self, "idle", 9, 9)
			Character_Base.createAnim(self, "run", 1, 16)
			Character_Base.createAnim(self, "jumpup", 1, 16)
			Character_Base.createAnim(self, "jumpdown", 1, 16)
			Character_Base.createAnim(self, "hurt", 17, 24)
			Character_Base.createAnim(self, "death", 25, 51)
			Character_Base.createAnim(self, "climbup", 1, 16)
			Character_Base.createAnim(self, "climbidle", 8, 8)
			Character_Base.createAnim(self, "climbdown", 1, 16)
		elseif self.body.name == "flyerA" then -- ANIMS LEVEL 1
			Character_Base.createAnim(self, "idle", 1, 1)
			Character_Base.createAnim(self, "run", 1, 1)
			Character_Base.createAnim(self, "attack01", 1, 1)
			Character_Base.createAnim(self, "jumpup", 1, 1)
			Character_Base.createAnim(self, "jumpdown", 1, 1)
			Character_Base.createAnim(self, "wall", 1, 1)
			Character_Base.createAnim(self, "wallidle", 1, 1)
			Character_Base.createAnim(self, "climbup", 1, 1)
			Character_Base.createAnim(self, "climbidle", 1, 1)
			Character_Base.createAnim(self, "climbup", 1, 1)
			Character_Base.createAnim(self, "climbdown", 1, 1)
			Character_Base.createAnim(self, "hurt", 1, 1)
			Character_Base.createAnim(self, "death", 1, 1)
		elseif self.body.name == "flyerKeepA" then -- ANIMS LEVEL 1
			Character_Base.createAnim(self, "idle", 1, 1)
			Character_Base.createAnim(self, "run", 1, 1)
			Character_Base.createAnim(self, "attack01", 1, 1)
			Character_Base.createAnim(self, "jumpup", 1, 1)
			Character_Base.createAnim(self, "jumpdown", 1, 1)
			Character_Base.createAnim(self, "wall", 1, 1)
			Character_Base.createAnim(self, "wallidle", 1, 1)
			Character_Base.createAnim(self, "climbup", 1, 1)
			Character_Base.createAnim(self, "climbidle", 1, 1)
			Character_Base.createAnim(self, "climbup", 1, 1)
			Character_Base.createAnim(self, "climbdown", 1, 1)
			Character_Base.createAnim(self, "hurt", 1, 1)
			Character_Base.createAnim(self, "death", 1, 1)
		elseif self.body.name == "friendlyflyerA" then
			-- to do
		end
	end
	if g_currentlevel == 2 then -- ANIMS LEVEL 2
		if self.body.name == "walkerA" then -- ANIMS LEVEL 2
			Character_Base.createAnim(self, "idle", 1, 13)
			Character_Base.createAnim(self, "run", 16, 25)
			Character_Base.createAnim(self, "jumpup", 16, 25)
			Character_Base.createAnim(self, "jumpdown", 16, 25)
			Character_Base.createAnim(self, "hurt", 16, 25)
			Character_Base.createAnim(self, "death", 16, 25)
			Character_Base.createAnim(self, "climbup", 16, 25)
			Character_Base.createAnim(self, "climbidle", 16, 25)
			Character_Base.createAnim(self, "climbdown", 16, 25)
		elseif self.body.name == "walkerBossA" then -- ANIMS LEVEL 2
			Character_Base.createAnim(self, "idle", 1, 14)
			Character_Base.createAnim(self, "run", 16, 16+18)
			Character_Base.createAnim(self, "jumpup", 16, 16+18)
			Character_Base.createAnim(self, "jumpdown", 16, 16+18)
			Character_Base.createAnim(self, "hurt", 16, 16+18)
			Character_Base.createAnim(self, "death", 16, 16+18)
			Character_Base.createAnim(self, "climbup", 16, 16+18)
			Character_Base.createAnim(self, "climbidle", 16, 16+18)
			Character_Base.createAnim(self, "climbdown", 16, 16+18)
		elseif self.body.name == "flyerA" then -- ANIMS LEVEL 2
			Character_Base.createAnim(self, "idle", 1, 12)
			Character_Base.createAnim(self, "run", 1, 12)
			Character_Base.createAnim(self, "attack01", 1, 12)
			Character_Base.createAnim(self, "jumpup", 1, 12)
			Character_Base.createAnim(self, "jumpdown", 1, 12)
			Character_Base.createAnim(self, "wall", 1, 12)
			Character_Base.createAnim(self, "wallidle", 1, 12)
			Character_Base.createAnim(self, "climbup", 1, 12)
			Character_Base.createAnim(self, "climbidle", 1, 12)
			Character_Base.createAnim(self, "climbup", 1, 12)
			Character_Base.createAnim(self, "climbdown", 1, 12)
			Character_Base.createAnim(self, "hurt", 1, 12)
			Character_Base.createAnim(self, "death", 1, 12)
		elseif self.body.name == "flyerKeepA" then -- ANIMS LEVEL 2
			Character_Base.createAnim(self, "idle", 1, 12)
			Character_Base.createAnim(self, "run", 1, 12)
			Character_Base.createAnim(self, "attack01", 1, 12)
			Character_Base.createAnim(self, "jumpup", 1, 12)
			Character_Base.createAnim(self, "jumpdown", 1, 12)
			Character_Base.createAnim(self, "wall", 1, 12)
			Character_Base.createAnim(self, "wallidle", 1, 12)
			Character_Base.createAnim(self, "climbup", 1, 12)
			Character_Base.createAnim(self, "climbidle", 1, 12)
			Character_Base.createAnim(self, "climbup", 1, 12)
			Character_Base.createAnim(self, "climbdown", 1, 12)
			Character_Base.createAnim(self, "hurt", 1, 12)
			Character_Base.createAnim(self, "death", 13, 22)
		elseif self.body.name == "friendlyflyerA" then -- ANIMS LEVEL 2
			-- to do
		end
	end
	-- NEW ABILITIES (additional bodies, joints, ...)
	-- *************
	local shape2
	local shape3
	local fixture2
	local fixture3
	local filterData2
	local filterData3
	if g_currentlevel == 1 then -- NEW ABILITIES LEVEL 1
		if self.body.name == "walkerA" then -- NEW ABILITIES LEVEL 1
			shape2 = b2.CircleShape.new(0, -self.h/3, self.w*0.12) -- x, y, radius
			fixture2 = self.body:createFixture{
				shape = shape2, density = 0, restitution = 0, friction = 0,
			}
		elseif self.body.name == "walkerBossA" then -- NEW ABILITIES LEVEL 1
			shape2 = b2.CircleShape.new(0, -self.h/5, self.w*0.15) -- x, y, radius
			fixture2 = self.body:createFixture{
				shape = shape2, density = 0, restitution = 0, friction = 0,
			}
		elseif self.body.name == "flyerA" then -- NEW ABILITIES LEVEL 1
			self:joint(self.posx, self.posy)
		elseif self.body.name == "flyerKeepA" then -- NEW ABILITIES LEVEL 1
			self:joint(self.posx, self.posy)
		elseif self.body.name == "friendlyflyerA" then -- NEW ABILITIES LEVEL 1
			self:joint(self.posx, self.posy)
		end
	end
	if g_currentlevel == 2 then -- NEW ABILITIES LEVEL 2
		if self.body.name == "walkerA" then -- NEW ABILITIES LEVEL 2
			shape2 = b2.CircleShape.new(28, 0, 15) -- x, y, radius
			fixture2 = self.body:createFixture{
				shape = shape2, density = 0, restitution = 0, friction = 0,
			}
			shape3 = b2.CircleShape.new(-28, 0, 15) -- x, y, radius
			fixture3 = self.body:createFixture{
				shape = shape3, density = 0, restitution = 0, friction = 0,
			}
		elseif self.body.name == "walkerBossA" then -- NEW ABILITIES LEVEL 2
			shape2 = b2.CircleShape.new(0, -self.h/2.5, self.w*0.15) -- x, y, radius
			fixture2 = self.body:createFixture{
				shape = shape2, density = 0, restitution = 0, friction = 0,
			}
		elseif self.body.name == "flyerA" then -- NEW ABILITIES LEVEL 2
			self:joint(self.posx, self.posy)
		elseif self.body.name == "flyerKeepA" then -- NEW ABILITIES LEVEL 2
			self:joint(self.posx, self.posy)
		end
	end
	if shape2 then
		-- filter data
		filterData2 = { 
			categoryBits = G_BITENEMY, maskBits = nmecollisions, groupIndex = 0,
		}
		fixture2:setFilterData(filterData2)
		-- clean
		filterData2 = nil
		fixture2 = nil
		shape2 = nil
	end
	if shape3 then
		-- filter data
		filterData3 = { 
			categoryBits = G_BITENEMY, maskBits = nmecollisions, groupIndex = 0,
		}
		fixture3:setFilterData(filterData3)
		-- clean
		filterData3 = nil
		fixture3 = nil
		shape3 = nil
	end
	-- BULLET & FX
	-- *************
	local tex -- bullet
	local bulletscale
	local bulletalpha
	local bulletoffsetx, bulletoffsety
	local fixedrotation
	local gravityscale
	local bulletvel
	local bulletttl
	local bulletdamage
	local isfx -- fx
	self.fx = {}
	if g_currentlevel == 1 then -- BULLET & FX LEVEL 1
		if self.body.name == "walkerA" then -- BULLET & FX LEVEL 1
			tex = Texture.new("gfx/fx/flash01_small.png", true)
			bulletscale = 0.3 bulletalpha = 1.5 bulletoffsetx, bulletoffsety = 8, -8 fixedrotation=false
			gravityscale = 0 bulletvel = 1 bulletttl = 12 bulletdamage = 1
			isfx = true
			self.fx.tex = tex
			self.fx.scale = 3.5 self.fx.speedgrowth = 1.5 self.fx.decaygrowth = 0.2
			self.fx.color = 0x4DFFA6 self.fx.alpha = 2 self.fx.decayalpha = 0.97
			self.fx.nbparticles = 8 self.fx.vel = 0.35 self.fx.ttl = 64*1.2
		elseif self.body.name == "walkerBossA" then -- BULLET & FX LEVEL 1
			tex = Texture.new("gfx/fx/fire.png", true)
			bulletscale = 0.5 bulletalpha = 0.7 bulletoffsetx, bulletoffsety = 70, -16 fixedrotation=false
			gravityscale = 0 bulletvel = 16 bulletttl = 8 bulletdamage = 1
			isfx = true
			self.fx.tex = tex
			self.fx.scale = 7 self.fx.speedgrowth = 1.5 self.fx.decaygrowth = 0
			self.fx.color = 0x49725A
			self.fx.alpha = 0.8 self.fx.decayalpha = 0.97
			self.fx.nbparticles = 8
			self.fx.vel = 0.2
			self.fx.ttl = 64*1
		elseif self.body.name == "flyerA" then -- BULLET & FX LEVEL 1
			tex = Texture.new("gfx/fx/ember.png", true)
			bulletscale = 0.7 bulletalpha = 2 bulletoffsetx, bulletoffsety = 0, 0 fixedrotation=false
			gravityscale = 0 bulletvel = 0.4 bulletttl = 12 bulletdamage = 1
			isfx = true
			self.fx.tex = tex
			self.fx.scale = 4 self.fx.speedgrowth = 1.5 self.fx.decaygrowth = 0.1
			self.fx.color = 0x006E3F
			self.fx.alpha = 8 self.fx.decayalpha = 0.97
			self.fx.nbparticles = 4
			self.fx.vel = 0.15
			self.fx.ttl = 128
		elseif self.body.name == "flyerKeepA" then -- BULLET & FX LEVEL 1
			tex = Texture.new("gfx/fx/ember.png", true)
			bulletscale = 0.5 bulletalpha = 2 bulletoffsetx, bulletoffsety = 0, 0 fixedrotation=false
			gravityscale = 0
			bulletvel = 0.3 bulletttl = 10 bulletdamage = 1
		end
	end
	if g_currentlevel == 2 then -- BULLET & FX LEVEL 2
		if self.body.name == "walkerA" then -- BULLET & FX LEVEL 2
			tex = Texture.new("gfx/fx/fire.png", true)
			bulletscale = 0.15 bulletalpha = 0.8 bulletoffsetx, bulletoffsety = 80, 0 fixedrotation=false
			gravityscale = 0 bulletvel = 2 bulletttl = 64*0.4 bulletdamage = 1
			isfx = true
			self.fx.tex = tex
			self.fx.scale = 7 self.fx.speedgrowth = 1.5 self.fx.decaygrowth = 0
			self.fx.color = 0x57321B
			self.fx.alpha = 0.3 self.fx.decayalpha = 0.97
			self.fx.nbparticles = 8
			self.fx.vel = 0.2
			self.fx.ttl = 64*1
		elseif self.body.name == "walkerBossA" then -- BULLET & FX LEVEL 2
			tex = Texture.new("gfx/fx/fire.png", true)
			bulletscale = 0.18 bulletalpha = 0.9 bulletoffsetx, bulletoffsety = 32, -16 fixedrotation=false
			gravityscale = 0 bulletvel = 2 bulletttl = 64*0.5 bulletdamage = 2
			isfx = true
			self.fx.tex = tex
			self.fx.scale = 7 self.fx.speedgrowth = 1.5 self.fx.decaygrowth = 0
			self.fx.color = 0x49725A
			self.fx.alpha = 0.8 self.fx.decayalpha = 0.97
			self.fx.nbparticles = 8
			self.fx.vel = 0.2
			self.fx.ttl = 64*1
		elseif self.body.name == "flyerA" then -- BULLET & FX LEVEL 2
			tex = Texture.new("gfx/fx/obj_explosion1 (2).png", true)
			bulletscale = 0.1 bulletalpha = 0.7 bulletoffsetx, bulletoffsety = 30, 0 fixedrotation=false
			gravityscale = 0 bulletvel = 0.7 bulletttl = 8 bulletdamage = 1
			isfx = true
			self.fx.tex = tex
			self.fx.scale = 4 self.fx.speedgrowth = 1.5 self.fx.decaygrowth = 0
--			self.fx.color = 0xffffff
			self.fx.alpha = 0.4 self.fx.decayalpha = 0.97
			self.fx.nbparticles = 8
			self.fx.vel = 0.2
			self.fx.ttl = 64*1
		elseif self.body.name == "flyerKeepA" then -- BULLET & FX LEVEL 2
			tex = Texture.new("gfx/fx/obj_explosion1 (2).png", true)
			bulletscale = 0.15 bulletalpha = 0.6 bulletoffsetx, bulletoffsety = 48, 0 fixedrotation=false
			gravityscale = 0 bulletvel = 2.7 bulletttl = 8 bulletdamage = 1
			isfx = true
			self.fx.tex = tex
			self.fx.scale = 5 self.fx.speedgrowth = 2 self.fx.decaygrowth = 0.7
--			self.fx.color = 0xffffff
			self.fx.alpha = 0.5 self.fx.decayalpha = 0.95
			self.fx.nbparticles = 16
			self.fx.vel = 0.25
			self.fx.ttl = 64*1.2
		end
	end
	self.bullet = LF_Dynamic_Bullet.new(self.world, {
			tex=tex, scale=bulletscale, alpha=bulletalpha,
			fixedrotation=fixedrotation, gravityscale=gravityscale,
			ttl=bulletttl,
			BIT=G_BITENEMYBULLET, COLBIT=nmebulletcollisions, ROLE=G_ENEMY_BULLET, -- common
			bulletdamage=bulletdamage,
		}
	)
	-- DEATH
	-- *****
	self.deathbody = {}
	self.deathfx = {}
	if g_currentlevel == 1 then -- DEATH LEVEL 1
		if self.body.name == "walkerA" then -- DEATH LEVEL 1
			self.deathbody.vx, self.deathbody.vy = 1, 1 -- direction when dying
			self.deathbody.dt = 0.5
			self.deathfx.tex = Texture.new("gfx/fx/fire.png", true)
			self.deathfx.texscale = 5 self.deathfx.radius = 8 self.deathfx.speed = 0.3
			self.deathfx.nbparticles = 16 self.deathfx.ttl = 64*0.5 self.deathfx.color = 0x00ff00
		elseif self.body.name == "flyerA" then -- DEATH LEVEL 1
			self.deathbody.vx, self.deathbody.vy = 0, 0.01 -- direction when dying
			self.deathbody.dt = 0.05
			self.deathfx.tex = Texture.new("gfx/fx/flash01_small.png", true)
			self.deathfx.texscale = 4 self.deathfx.radius = 4 self.deathfx.speed = 0.1
			self.deathfx.nbparticles = 12 self.deathfx.ttl = 64*1.1 self.deathfx.color = 0xff0000
		elseif self.body.name == "flyerKeepA" then -- DEATH LEVEL 1
			self.deathbody.vx, self.deathbody.vy = 0.1, 0.2 -- direction when dying
			self.deathbody.dt = 0.005
			self.deathfx.tex = Texture.new("gfx/fx/flash01_small.png", true)
			self.deathfx.texscale = 5 self.deathfx.radius = 8 self.deathfx.speed = 0.2
			self.deathfx.nbparticles = 16 self.deathfx.ttl = 64*1.2 self.deathfx.color = 0x0000ff
		end
	end
	if g_currentlevel == 2 then -- DEATH LEVEL 2
		if self.body.name == "walkerA" then -- DEATH LEVEL 2
			self.deathbody.vx, self.deathbody.vy = 2, 0 -- direction when dying
			self.deathbody.dt = 0.5
			self.deathfx.tex = Texture.new("gfx/fx/snow.png", true)
			self.deathfx.texscale = 8 self.deathfx.radius = 4 self.deathfx.speed = 0.05
			self.deathfx.nbparticles = 16 self.deathfx.ttl = 16 --self.deathfx.color = 0x00ff00
		elseif self.body.name == "walkerBossA" then -- DEATH LEVEL 2
			self.deathbody.vx, self.deathbody.vy = 24, 16 -- direction when dying
			self.deathbody.dt = 0.5
			self.deathfx.tex = Texture.new("gfx/fx/snow.png", true)
			self.deathfx.texscale = 9 self.deathfx.radius = 5 self.deathfx.speed = 0.02
			self.deathfx.nbparticles = 24 self.deathfx.ttl = 48 --self.deathfx.color = 0x00ff00
		elseif self.body.name == "flyerA" then -- DEATH LEVEL 2
			self.deathbody.vx, self.deathbody.vy = 0.2, 0.2 -- direction when dying
			self.deathbody.dt = 0.5
			self.deathfx.tex = Texture.new("gfx/fx/snow.png", true)
			self.deathfx.texscale = 8 self.deathfx.radius = 4 self.deathfx.speed = 0.05
			self.deathfx.nbparticles = 16 self.deathfx.ttl = 16 --self.deathfx.color = 0x00ff00
		elseif self.body.name == "flyerKeepA" then -- DEATH LEVEL 2
			self.deathbody.vx, self.deathbody.vy = 0.01, 128 -- direction when dying
			self.deathbody.dt = 0.00005
			self.deathfx.tex = Texture.new("gfx/fx/snow.png", true)
			self.deathfx.texscale = 9 self.deathfx.radius = 5 self.deathfx.speed = 0.02
			self.deathfx.nbparticles = 24 self.deathfx.ttl = 48 --self.deathfx.color = 0x00ff00
		end
	end
	-- class vars
	self.bulletvel = bulletvel
	self.bulletoffsetx, self.bulletoffsety = bulletoffsetx, bulletoffsety
	self.isfx = isfx
	-- lists
	if self.body.name == "walkerA" then self.world.groundnmes[self] = self.body
	elseif self.body.name == "walkerBossA" then self.world.groundnmes[self] = self.body
	elseif self.body.name == "flyerA" then self.world.airnmes[self] = self.body
	elseif self.body.name == "flyerKeepA" then self.world.airnmes[self] = self.body
	elseif self.body.name == "friendlyflyerA" then -- to do
	end
	-- audio
	self.sndshoot = Sound.new("audio/shoot.wav")
	self.sndhurt = Sound.new("audio/dinosaur-4.wav")
	self.snddead = Sound.new("audio/dinosaur-5.wav")
	self.volume = g_sfxvolume * 0.01 * 0.5
	-- listeners
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

-- create joint
function Nmes:joint(xposx, xposy)
	self.body.ground = self.world:createBody({})
	self.body.ground:setPosition(xposx, xposy)
	local jointDef
	if g_currentlevel == 1 then
		jointDef = b2.createDistanceJointDef(self.body.ground, self.body, xposx, xposy - 64*2, xposx, xposy)
		self.body.joint = self.world:createJoint(jointDef)
		self.body.joint:setDampingRatio(0.5)
		self.body.joint:setFrequency(1.2)
	end
	if g_currentlevel == 2 then
		if self.body.name == "flyerA" then
			jointDef = b2.createDistanceJointDef(self.body.ground, self.body, xposx, xposy - 64, xposx, xposy)
			self.body.joint = self.world:createJoint(jointDef)
			self.body.joint:setDampingRatio(1)
			self.body.joint:setFrequency(0.6)
		elseif self.body.name == "flyerKeepA" then
			jointDef = b2.createDistanceJointDef(self.body.ground, self.body, xposx, xposy - 32, xposx, xposy)
			self.body.joint = self.world:createJoint(jointDef)
			self.body.joint:setLength(164)
			self.body.joint:setDampingRatio(1)
			self.body.joint:setFrequency(3)
		end
	end
end

-- loop
function Nmes:onEnterFrame(e)
	if self.body.isdirty then
		local sfx = self.sndhurt:play() if sfx then sfx:setVolume(self.volume) end
		self.body.isdirty = false
	end
	if self.body.currentnrg <= 0 then
		self.body.currentnrg = self.body.nrg
	end
	-- SHOOT
	-- *****
	if self.body.isspace then
		if self.body.isdead then return end
--		print("the others num children", self:getNumChildren())
		-- common
--		local sfx = self.sndshoot:play() if sfx then sfx:setVolume(self.volume * 8) end
		local sfx = self.sndshoot:play() if sfx then sfx:setVolume(0.1) end -- self.volume
		local flip = self.body.flip
		local posx, posy = self.body:getPosition()
		local plx, ply = self.world.player1.body:getPosition()
		local angle = math.atan2(ply - posy, plx - posx)
		-- the bullet
		local tempvx, tempvy = self.bulletvel * math.cos(angle), self.bulletvel * math.sin(angle)
		self.bullet:shoot(posx+self.bulletoffsetx*flip, posy+self.bulletoffsety, flip, tempvx, tempvy)
		self:getParent():addChild(self.bullet)
		-- the fx?
		if self.isfx then
			Core.asyncCall(effectTrail, self,
				self.fx.tex, posx+self.bulletoffsetx*flip, posy+self.bulletoffsety,
				self.fx.scale, self.fx.speedgrowth, self.fx.decaygrowth,
				self.fx.color, self.fx.alpha, self.fx.decayalpha,
				angle, self.fx.nbparticles, self.fx.vel, self.fx.ttl)
		end
		-- end
		self.body.isspace = false
	end
	-- DEATH
	-- ******
	local function death(xk, xv)
--		print("dead", g_currentlevel, xv.name)
--		if xv.joint then xv.joint:setLength(xv.joint:getLength()) end -- *1.5, I couldn't make destroy joint work :-(
		local posx, posy = xv:getPosition()
		local flip = xv.flip
		-- move it all
		xv:applyLinearImpulse(xk.deathbody.vx*-flip, xk.deathbody.vy, xv:getWorldCenter()) -- test
		xk:setPosition(posx, posy)
		xk:playAnim(e.deltaTime)
		xv.timer -= xk.deathbody.dt
		if xv.timer < 0 or xv.numfloorcontacts > 0 then -- wait for the body to touch ground
			-- fx
			local sfx = self.snddead:play() if sfx then sfx:setVolume(self.volume) end
			Core.asyncCall(effectExplode, xk:getParent(),
				xk.deathfx.tex, xk.deathfx.texscale, posx, posy, xk.deathfx.radius,
				xk.deathfx.speed, xk.deathfx.nbparticles, xk.deathfx.ttl, xk.deathfx.color)
			-- the score
			self.world.score += xv.points
			self.world.scoretf:setText("SCORE: "..self.world.score)
			local mc = MovieClip.new{
				{1, 20, self.world.scoretf, {scale={4, 9, "inOutElastic"}}},
				{20, 40, self.world.scoretf, {scale={9, 4, "inOutElastic"}}}
			}
			-- now we can destroy the bodies
			self.world:destroyBody(xv)
			if xv.ground then self.world:destroyBody(xv.ground) end -- this was for the joint
			if xv.keep then xk:setAlpha(0.5) -- keep texture sprite
			else xk:getParent():removeChild(xk) -- remove texture sprite
			end
			if xv.ability == "walk" then self.world.groundnmes[xk] = nil
			elseif xv.ability == "fly" then self.world.airnmes[xk] = nil
			end
			xv = nil
			xk = nil
		end
	end
	for k, v in pairs(self.world.groundnmes) do -- k=self, v=body
		if v.isdead then death(k, v) end
	end
	for k, v in pairs(self.world.airnmes) do -- k=self, v=body
		if v.isdead then death(k, v) end
	end
end
