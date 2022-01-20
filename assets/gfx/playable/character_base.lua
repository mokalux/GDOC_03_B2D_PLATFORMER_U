Character_Base = Core.class(Sprite)

function Character_Base:init(xworld, xparams)
	self.world = xworld
	-- the params
	local params = xparams or {}
	params.posx = xparams.posx or 0
	params.posy = xparams.posy or 0
	params.textures = xparams.textures or {} -- table
	params.r = xparams.r or 1
	params.g = xparams.g or 1
	params.b = xparams.b or 1
	params.alpha = xparams.alpha or 1
	params.scale = xparams.scale or 1
	params.anchorx = xparams.anchorx or 0.5
	params.anchory = xparams.anchory or 0.5
	params.offsetx = xparams.offsetx or 0
	params.offsety = xparams.offsety or 0
	params.shapescale = xparams.shapescale or 1
	params.animspeed = xparams.animspeed or 7
	params.movespeed = xparams.movespeed or 8
	params.jumpspeed = xparams.jumpspeed or nil
	params.maxnumjump = xparams.maxnumjump or 0
	params.density = xparams.density or nil
	params.restitution = xparams.restitution or nil
	params.friction = xparams.friction or nil
	params.BIT = xparams.BIT or nil
	params.COLBIT = xparams.COLBIT or nil
	params.ROLE = xparams.ROLE or nil
	params.name = xparams.name or nil
	params.lives = xparams.lives or 1
	params.nrg = xparams.nrg or 1
	params.points = xparams.points or nil
	params.ability = xparams.ability or nil
	params.dokeep = xparams.dokeep or nil
	-- class variables
	self.posx, self.posy = params.posx, params.posy
	self.w, self.h = 0, 0
	-- spritesheet animations
	self.spritesheetimgs = {} -- table that will hold all the images in the sprite sheet
	self.anims = {} -- table that will hold all our animations ("idle", "run", ...)
	-- 1 retrieve all anims in spritesheet
	local spritesheettexregion
	for i = 1, #params.textures do
		for r = 1, params.textures[i].numrows do
			for c = 1, params.textures[i].numcols do
				local tex = Texture.new(params.textures[i].path, true)
				self.w, self.h = tex:getWidth()/params.textures[i].numcols,
					tex:getHeight()/params.textures[i].numrows
				spritesheettexregion = TextureRegion.new(tex, (c - 1) * self.w, (r - 1) * self.h, self.w, self.h)
				self.spritesheetimgs[#self.spritesheetimgs + 1] = spritesheettexregion
			end
		end
	end
	-- 2 create animations
--	self:createAnim("idle", 11, 18)
	-- 3 we can now create the character
	self.bitmap = Bitmap.new(self.spritesheetimgs[1])
	self.bitmap:setAnchorPoint(params.anchorx, params.anchory)
	self.bitmap:setPosition(params.offsetx, params.offsety)
--	print("bmp size before scaling", params.ROLE, self.w, self.h)
	self.bitmap:setScale(params.scale)
	self.bitmap:setColorTransform(params.r, params.g, params.b, params.alpha)
	self:addChild(self.bitmap)
	-- the body
	self.body = self.world:createBody{type = b2.DYNAMIC_BODY}
	self.body:setFixedRotation(true)
	self.body:setPosition(params.posx, params.posy)
	-- the shape
	self.w, self.h = self.bitmap:getWidth()//1, self.bitmap:getHeight()//1
--	print("bmp size after scaling", params.ROLE, self.w, self.h)
	local playershape = b2.CircleShape.new(0, 0, self.w/params.shapescale) -- //1 :-) (centerx, centery, radius)
	self.fixture = self.body:createFixture{
		shape = playershape, density = params.density, restitution = params.restitution, friction = params.friction,
	}
	-- filter data
	self.filterData = { categoryBits = params.BIT, maskBits = params.COLBIT, groupIndex = 0 }
	self.fixture:setFilterData(self.filterData)
	-- body vars
	self.body.isleft, self.body.isright, self.body.isup, self.body.isdown = false, false, false, false
	self.body.isspace = false
	self.body.role = params.ROLE
	self.body.name = params.name
	self.body.lives = params.lives
	self.body.currentlives = self.body.lives
	self.body.nrg = params.nrg
	self.body.currentnrg = self.body.nrg
	self.body.currentanim = ""
	self.body.frame = 0
	self.body.animspeed = 1 / params.animspeed
	self.body.animtimer = self.body.animspeed
	self.body.playerscale = self.bitmap:getScale()
	self.body.flip = 1
	self.body.shapescale = params.shapescale
	self.body.movespeed = params.movespeed * self.body.playerscale
	self.body.jumpspeed = params.jumpspeed * self.body.playerscale
	self.body.maxnumjump = params.maxnumjump
	self.body.numjumpcount = self.body.maxnumjump
	self.body.numfloorcontacts = 0 -- is on floor
	self.body.numwallcontacts = 0 -- is on wall
	self.body.numladdercontacts = 0 -- is on ladder
	self.body.numptpfcontacts = 0 -- is on passthrough platform
	self.body.nummvpfcontacts = 0 -- is on moving platform
	self.body.canjump = true
	self.body.isgoingdownplatform = false
	self.body.cangodown = true
	self.body.isdirty = false
	self.body.isdead = false
	self.body.timer = 0
	self.body.isonme = nil -- is on nme
	self.body.points = params.points
	self.body.ability = params.ability
	self.body.keep = params.dokeep -- keep the sprite on screen when dead
	-- LISTENERS
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

-- functions
function Character_Base:createAnim(xanimname, xstart, xfinish)
	self.anims[xanimname] = {}
	for i = xstart, xfinish do
		self.anims[xanimname][#self.anims[xanimname] + 1] = self.spritesheetimgs[i]
	end
end

function Character_Base:playAnim(xdt)
	if self.body.currentanim ~= "" then
		self.body.animtimer = self.body.animtimer - xdt
		if self.body.animtimer <= 0 then
			self.body.frame += 1
			self.body.animtimer = self.body.animspeed
--			if self.body.currentanim == "death" then print("yyy", self.body.animspeed) end
			-- for debugging purpose -- comment before release! XXX
--			if (self.anims[self.body.currentanim] or 0) == 0 then
--				print("### PLAYANIM ERROR###", self.body.role, self.body.currentanim)
--			end
			-- fx
			if self.body.isdead then
				if self.body.frame > #self.anims[self.body.currentanim] then
					self.body.frame = #self.anims[self.body.currentanim]
					if self.body.role == G_PLAYER then self.body.timer = 0 end -- wait for the anim b4 restarting
				end
			else
				if self.body.frame > #self.anims[self.body.currentanim] then self.body.frame = 1 end
			end
			self.bitmap:setTextureRegion(self.anims[self.body.currentanim][self.body.frame])
		end
	end
end

-- loop
local desiredVelX, desiredVelY = 0, 0
function Character_Base:onEnterFrame(e)
	if not self.body then return end
	local dt = e.deltaTime

	-- HURT ANIM = NO CONTROL!
	-- ************************
	if self.body.timer > 0 then -- funny hit anim :-)
		self.body.timer -= 1
--		print(self.world.player1.body.timer, dt)
		if self.body.needrecover then
			if self.body.timer <= 0 then
				self:setColorTransform(255/255, 255/255, 255/255, 1) -- back to normal colors
				self.body.timer = 0
				self.body.needrecover = false
			end
		end
	end
	if not self.body.isdead then
		if not self.body:isActive() then return end
		local vx, vy = self.body:getLinearVelocity()
		desiredVelX, desiredVelY = 0, 0

		-- AIR fine tune jump
--		self.body:setGravityScale(1.47) -- fine tune jump
		self.body:setGravityScale(1.3) -- fine tune jump
		if self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts <= 0
				then
--			if vy > 2 then self.body:setGravityScale(2) end -- 4, 2, going down
			if vy > 2 then self.body:setGravityScale(1.5) end -- 4, 2, going down
		end

		-- IS DIRTY?
		-- *********
		if self.body.isdirty then
			self.body.currentnrg -= 1 -- magik XXX
			self.body.currentanim = "hurt"
--			self.body.timer = 16 -- magik XXX

		-- IS ON ME?
		-- *********
		elseif self.body.isonme then
			desiredVelY = -self.body.jumpspeed * dt * 0.5
			self.body.numjumpcount = 1
		end
		if self.body.currentnrg <= 0 then
			self.body.currentlives -= 1
		end
		if self.body.currentlives <= 0 then -- dead
			self.body.currentanim = "death"
			self.body.timer = 60
			self.body.isdead = true
			return
		end

		-- CONTROLS
		-- FLOOR ONLY
		-- ***********
		if self.body.numfloorcontacts > 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("FLOOR ONLY", dt)
--			if self.body.role == G_PLAYER then print("FLOOR ONLY", vy) end
			-- animations
--			if vx >= -1 and vx <= 1 then self.body.currentanim = "idle"
			if vx >= -0.1 and vx <= 0.1 then self.body.currentanim = "idle"
			else self.body.currentanim = "run"
			end
			-- controls
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown and self.body.canjump and self.body.numjumpcount > 0 then
				self.body:applyLinearImpulse(0, -vy/2, self.body:getWorldCenter()) -- cancel vy XXX
				desiredVelY = -self.body.jumpspeed * dt
				self.body.canjump = false
				self.body.numjumpcount -= 1
--			elseif self.body.isdown and not self.body.isup then
			end

		-- FLOOR & WALL
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("FLOOR & WALL", dt)
			-- animations
			if vx >= -1 and vx <= 1 then self.body.currentanim = "idle"
			else self.body.currentanim = "run"
			end
			-- controls
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown and self.body.canjump and self.body.numjumpcount > 0 then
				desiredVelY = -self.body.jumpspeed * dt
				self.body.canjump = false
				self.body.numjumpcount -= 1
--			elseif self.body.isdown and not self.body.isup then
			end

		-- FLOOR & LADDER
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("FLOOR & LADDER", dt)
			-- animations
			if vx >= -1 and vx <= 1 then self.body.currentanim = "idle"
			else self.body.currentanim = "run"
			end
			-- controls
			self.body:setGravityScale(-vy)
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown then
				desiredVelY = -self.body.jumpspeed * dt*0.1
--			elseif self.body.isdown and not self.body.isup then
			end

		-- FLOOR & PTPF
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("FLOOR & PTPF", dt)
			-- animations
			if vx >= -1 and vx <= 1 then self.body.currentanim = "idle"
			else self.body.currentanim = "run"
			end
			-- controls
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown and self.body.canjump and self.body.numjumpcount > 0 then
				desiredVelY = -self.body.jumpspeed * dt
				self.body.canjump = false
				self.body.numjumpcount -= 1
			elseif self.body.isdown and not self.body.isup then
				desiredVelY = 0
				self.body.isgoingdownplatform = true -- new 20210907
			end

		-- FLOOR & MVPF
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts > 0
				then
--			print("FLOOR & MVPF", dt)
			-- animations
			if vx >= -1 and vx <= 1 then self.body.currentanim = "idle"
			else self.body.currentanim = "run"
			end
			-- controls
			if self.body.isleft and not self.body.isright then desiredVelX = -self.body.movespeed * dt self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then desiredVelX = self.body.movespeed * dt self.body.flip = 1
			else vx = 0 -- must keep, moves body along with platform
			end
			if self.body.isup and not self.body.isdown and self.body.canjump and self.body.numjumpcount > 0 then
				desiredVelY = -self.body.jumpspeed * dt
				self.body.canjump = false
				self.body.numjumpcount -= 1
			end

		-- FLOOR & WALL & LADDER
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("FLOOR & WALL & LADDER", dt)
			-- animations
			if vx ~= 0 then self.body.currentanim = "climbup"
			elseif vy < -1 then self.body.currentanim = "climbup"
			elseif vy > 1 then self.body.currentanim = "climbdown"
			else self.body.currentanim = "climbidle"
			end
			-- controls
			self.body:setGravityScale(-vy)
			self.body.isgoingdownplatform = false -- OK
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt*0.5
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt*0.5
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown then
				desiredVelY = -self.body.jumpspeed * dt*0.2 -- 0.1
				self.body.canjump = false -- OK
			elseif self.body.isdown and not self.body.isup then
				desiredVelY = self.body.jumpspeed * dt*0.1
			end

		-- FLOOR & WALL & PTPF
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("FLOOR & WALL & PTPF", dt)
			-- animations
			if vx >= -1 and vx <= 1 then self.body.currentanim = "idle"
			else self.body.currentanim = "run"
			end
			-- controls
			if self.body.isleft and not self.body.isright then desiredVelX = -self.body.movespeed * dt self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then desiredVelX = self.body.movespeed * dt self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown and self.body.canjump and self.body.numjumpcount > 0 then
				desiredVelY = -self.body.jumpspeed * dt
				self.body.canjump = false
				self.body.numjumpcount -= 1
			elseif self.body.isdown and not self.body.isup then
				desiredVelY = 0
				self.body.isgoingdownplatform = true -- new 2021 09 07
			end

		-- FLOOR & WALL & MVPF
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts > 0
				then
--			print("FLOOR & WALL & MVPF", dt)
			-- animations
			if vx >= -1 and vx <= 1 then self.body.currentanim = "idle"
			else self.body.currentanim = "run"
			end
			-- controls
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown and self.body.canjump and self.body.numjumpcount > 0 then
				desiredVelY = -self.body.jumpspeed * dt
				self.body.canjump = false
				self.body.numjumpcount -= 1
--			elseif self.body.isdown and not self.body.isup then
			end

		-- FLOOR & WALL & LADDER & PTPF
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("FLOOR & WALL & LADDER & PTPF", dt)
			-- animations
			if vx ~= 0 then self.body.currentanim = "climbup"
			elseif vy < -1 then self.body.currentanim = "climbup"
			elseif vy > 1 then self.body.currentanim = "climbdown"
			else self.body.currentanim = "climbidle"
			end
			-- controls
			self.body:setGravityScale(-vy)
			self.body.isgoingdownplatform = false -- OK
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt*0.5
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt*0.5
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown then
				desiredVelY = -self.body.jumpspeed * dt*0.1
				self.body.canjump = false -- OK
			elseif self.body.isdown and not self.body.isup then
				desiredVelY = self.body.jumpspeed * dt*0.1
			end

		-- FLOOR & WALL & LADDER & MVPF
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts > 0
				then
			print("FLOOR & WALL & LADDER & MVPF", dt)

		-- FLOOR & WALL & LADDER & PTPF & MVPF
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts > 0
				then
			print("FLOOR & WALL & LADDER & PTPF & MVPF", dt)

		-- FLOOR & LADDER & PTPF
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("FLOOR & LADDER & PTPF", dt)
			-- animations
			if vy <= -1 then self.body.currentanim = "climbup"
			elseif vy >= 1 then self.body.currentanim = "climbdown"
			else self.body.currentanim = "climbidle"
			end
			-- controls
			self.body:setGravityScale(-vy)
			if self.body.isleft and not self.body.isright then desiredVelX = -self.body.movespeed * dt*0.5 self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then desiredVelX = self.body.movespeed * dt*0.5 self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown then
				desiredVelY = -self.body.jumpspeed * dt*0.2
				self.body.canjump = false
			elseif self.body.isdown and not self.body.isup then
				self.body.isgoingdownplatform = true
				desiredVelY = 0
			end

		-- FLOOR & LADDER & MVPF
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts > 0
				then
			print("FLOOR & LADDER & MVPF", dt)

		-- FLOOR & LADDER & PTPF & MVPF
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts > 0
				then
			print("FLOOR & LADDER & PTPF & MVPF", dt)

		-- FLOOR & PTPF & MVPF
		-- ***********
		elseif self.body.numfloorcontacts > 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts > 0
				then
--			print("FLOOR & PTPF & MVPF", dt)
			-- animations
			if vx >= -1 and vx <= 1 then self.body.currentanim = "idle"
			else self.body.currentanim = "run"
			end
			-- controls
			if self.body.isleft and not self.body.isright then desiredVelX = -self.body.movespeed * dt self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then desiredVelX = self.body.movespeed * dt self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown and self.body.canjump and self.body.numjumpcount > 0 then
				desiredVelY = -self.body.jumpspeed * dt
				self.body.canjump = false
				self.body.numjumpcount -= 1
			elseif self.body.isdown and not self.body.isup then
				self.body.isgoingdownplatform = true
				desiredVelY = 0
			end

		-- WALL ONLY
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("WALL ONLY", dt)
			-- animations
--			if vx >= -1 and vx <= 1 then self.body.currentanim = "idle"
--			else self.body.currentanim = "run"
--			end
			if vy >= 4 then self.body.currentanim = "jumpdown"
			elseif vy <= -3 then self.body.currentanim = "jumpup"
			else self.body.currentanim = "idle"
			end
			-- controls
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown and self.body.canjump and self.body.numjumpcount > 0 then
				desiredVelY = -self.body.jumpspeed * dt
				self.body.canjump = false
				self.body.numjumpcount -= 1
--			elseif self.body.isdown and not self.body.isup then
			end

		-- WALL & LADDER
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("WALL & LADDER", dt)
			-- animations
			if vx ~= 0 then self.body.currentanim = "climbup"
			elseif vy < -1 then self.body.currentanim = "climbup"
			elseif vy > 1 then self.body.currentanim = "climbdown"
			else self.body.currentanim = "climbidle"
			end
			-- controls
			self.body:setGravityScale(-vy)
			self.body.isgoingdownplatform = false -- OK
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt*0.5
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt*0.5
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown then
				desiredVelY = -self.body.jumpspeed * dt*0.1
				self.body.canjump = false -- OK
			elseif self.body.isdown and not self.body.isup then
				desiredVelY = self.body.jumpspeed * dt*0.1
			end

		-- WALL & PTPF
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("WALL & PTPF", dt) -- nothing to do yet!

		-- WALL & MVPF
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts > 0
				then
--			print("WALL & MVPF", dt)
			-- animations
			if vx >= -1 and vx <= 1 then self.body.currentanim = "idle"
			else self.body.currentanim = "run"
			end
			-- controls
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown and self.body.canjump and self.body.numjumpcount > 0 then
				desiredVelY = -self.body.jumpspeed * dt
				self.body.canjump = false
				self.body.numjumpcount -= 1
--			elseif self.body.isdown and not self.body.isup then
			end

		-- WALL & LADDER & PTPF
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("WALL & LADDER & PTPF", dt)
			-- animations
			if vy < -1 then self.body.currentanim = "climbup"
			elseif vy > 1 then self.body.currentanim = "climbdown"
			else self.body.currentanim = "climbidle"
			end
			-- controls
			self.body:setGravityScale(-vy)
			self.body.canjump = false -- OK
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt*0.5
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt*0.5
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown then
				desiredVelY = -self.body.jumpspeed * dt*0.1
			elseif self.body.isdown and not self.body.isup then
				desiredVelY = self.body.jumpspeed * dt*0.1
			end

		-- WALL & LADDER & MVPF
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts > 0
				then
			print("WALL & LADDER & MVPF", dt)

		-- WALL & LADDER & PTPF & MVPF
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts > 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts > 0
				then
			print("WALL & LADDER & PTPF & MVPF", dt)

		-- LADDER ONLY
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("LADDER ONLY", dt)
			-- animations
			if vx ~= 0 then self.body.currentanim = "climbup"
			elseif vy < -1 then self.body.currentanim = "climbup"
			elseif vy > 1 then self.body.currentanim = "climbdown"
			else self.body.currentanim = "climbidle"
			end
			-- controls
			self.body:setGravityScale(-vy)
			self.body.isgoingdownplatform = false -- OK
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt*0.5
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt*0.5
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown then
				desiredVelY = -self.body.jumpspeed * dt*0.1
				self.body.canjump = false -- OK
			elseif self.body.isdown and not self.body.isup then
				self.body.canjump = true -- new 20211203
				desiredVelY = self.body.jumpspeed * dt*0.1
			end

		-- LADDER & PTPF
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("LADDER & PTPF", dt)
			-- animations
			if vy < -1 then self.body.currentanim = "climbup"
			elseif vy > 1 then self.body.currentanim = "climbdown"
			else self.body.currentanim = "climbidle"
			end
			-- controls
			self.body:setGravityScale(-vy)
			self.body.canjump = false -- OK
			if self.body.isleft and not self.body.isright then
				desiredVelX = -self.body.movespeed * dt*0.5
				self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then
				desiredVelX = self.body.movespeed * dt*0.5
				self.body.flip = 1
			end
			if self.body.isup and not self.body.isdown then
				desiredVelY = -self.body.jumpspeed * dt*0.1
			elseif self.body.isdown and not self.body.isup then
				desiredVelY = self.body.jumpspeed * dt*0.1
			end

		-- LADDER & MVPF
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts > 0
				then
			print("LADDER & MVPF", dt)

		-- LADDER & PTPF & MVPF
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts > 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts > 0
				then
			print("LADDER & PTPF & MVPF", dt)

		-- PTPF ONLY
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("PTPF ONLY", dt)
			-- animations
			if vx >= -1 and vx <= 1 then self.body.currentanim = "idle"
			else self.body.currentanim = "run"
			end
			-- controls
			if self.body.isleft and not self.body.isright then desiredVelX = -self.body.movespeed * dt self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then desiredVelX = self.body.movespeed * dt self.body.flip = 1
			end
			if self.body.isup and self.body.canjump and self.body.numjumpcount > 0 and not self.body.isdown then
				desiredVelY = -self.body.jumpspeed * dt
				self.body.canjump = false
				self.body.numjumpcount -= 1
			elseif self.body.isdown and self.body.cangodown and not self.body.isup then
				self.body.isgoingdownplatform = true
				self.body.cangodown = false
				desiredVelY = self.body.jumpspeed * dt*0.5
			end

		-- PTPF & MVPF
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts > 0
				and self.body.nummvpfcontacts > 0
				then
			print("PTPF & MVPF", dt)

		-- MVPF ONLY
		-- ***********
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts > 0
				then
--			print("MVPF ONLY", dt)
			-- animations
			if vx >= -2 and vx <= 2 then self.body.currentanim = "idle" -- mvpf vx related!
			else self.body.currentanim = "run"
			end
			-- controls
			if self.body.isleft and not self.body.isright then desiredVelX = -self.body.movespeed * dt self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then desiredVelX = self.body.movespeed * dt self.body.flip = 1
			else vx = 0 -- must keep, moves body along with platform
			end
			if self.body.isup and self.body.canjump and self.body.numjumpcount > 0 and not self.body.isdown then
				desiredVelY = -self.body.jumpspeed * dt -- * 0.9
				self.body.canjump = false
				self.body.numjumpcount -= 1
			elseif self.body.isdown and not self.body.isup then
				desiredVelY = self.body.jumpspeed * dt*0.1
			else vy = 0 -- can delete!
			end

		-- AIR
		-- ***
		elseif self.body.numfloorcontacts <= 0
				and self.body.numwallcontacts <= 0
				and self.body.numladdercontacts <= 0
				and self.body.numptpfcontacts <= 0
				and self.body.nummvpfcontacts <= 0
				then
--			print("AIR", dt)
--			if self.body.role == G_PLAYER then print("AIR", vy) end
			-- animations
			if vy > 4 then self.body.currentanim = "jumpdown" -- 3 magik XXX
			elseif vy <= -4 then self.body.currentanim = "jumpup" -- -3 magik XXX
--			elseif vx < -0.1 or vx > 0.1 then self.body.currentanim = "run"
			else self.body.currentanim = "jumpdown"
			end
			-- controls
			self.body.isgoingdownplatform = false -- IMPORTANT
			if self.body.isleft and not self.body.isright then desiredVelX = -self.body.movespeed * dt self.body.flip = -1
			elseif self.body.isright and not self.body.isleft then desiredVelX = self.body.movespeed * dt self.body.flip = 1
			end
			if self.body.isup and self.body.canjump and self.body.numjumpcount > 0 and not self.body.isdown then
				self.body:applyLinearImpulse(0, -vy/2, self.body:getWorldCenter()) -- cancel vy XXX
--				self.body:applyLinearImpulse(0, -self.body.jumpspeed * dt, self.body:getWorldCenter()) -- cancel vy XXX
--				desiredVelY = -self.body.jumpspeed * 0.85 * dt
				desiredVelY = -self.body.jumpspeed * dt
--				if vy > 0 then desiredVelY = -self.body.jumpspeed * 0.95 * dt -- going down
----				else desiredVelY = -self.body.jumpspeed * 0.735 * dt -- going up
--				else desiredVelY = -self.body.jumpspeed * 0.85 * dt -- going up
--				end
				self.body.canjump = false
				self.body.numjumpcount -= 1
			end

		-- error
		else
			print(
				"floor", self.body.numfloorcontacts,
				"wall", self.body.numwallcontacts,
				"ladder", self.body.numladdercontacts,
				"ptpf", self.body.numptpfcontacts,
				"mvpf", self.body.nummvpfcontacts,
				dt
			)
		end

--[[
		-- fine tune jump?
		if vy < -12 then ---17=300  magik XXX
--			print(vy)
			self.body:applyLinearImpulse(0, -vy/2, self.body:getWorldCenter()) -- cancel vy/2 XXX
--			self.body:applyLinearImpulse(0, 0, self.body:getWorldCenter()) -- cancel vy/2 XXX
		end
]]
		-- final movements
		local velChange = desiredVelX - vx
		local impulse = self.body:getMass() * velChange
		self.body:applyLinearImpulse(impulse, desiredVelY, self.body:getWorldCenter())
		-- animations
		self:playAnim(dt)
		-- update position
		self:setPosition(self.body:getPosition())
		self.bitmap:setScale(self.body.playerscale * self.body.flip, self.body.playerscale)
	end
end
