--!NEEDS:../../tiled/tiled_polygon.lua
Collectibles = Core.class(Tiled_Shape_Polygon)

function Collectibles:init()
	-- others
	self.snd = Sound.new("audio/Collectibles_1.wav")
	self.snd2 = Sound.new("audio/Collectibles_3.wav")
	self.volume = g_sfxvolume*0.01 * 0.3
	-- event listeners
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Collectibles:onEnterFrame(e)
	if self.body and self.img then
		self.img:setRotation(math.sin(e.time*4)*16)
		if self.body.isdirty then
			self.world:destroyBody(self.body)
			self:getParent():removeChild(self)
			if self.body.role == G_COLLECTIBLE then
				local sfx = self.snd:play() if sfx then sfx:setVolume(self.volume) end
				self.world.score += self.body.value
				self.world.scoretf:setText("SCORE: "..self.world.score)
				local mc = MovieClip.new{
					{1, 20, self.world.scoretf, {scale={4, 8, "inOutElastic"}}},
					{20, 30, self.world.scoretf, {scale={8, 4, "inOutElastic"}}}
				}
			end
			self.body = nil
			self.img = nil
			self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
			return
		end
	end
	-- spritesheet animations
	if self.isssanim then self:playAnim(e.deltaTime) end
end

-- anims
function Collectibles:prepareAnim(xtexpath, xcols, xrows, xscale)
	-- spritesheet animations
	local spritesheettex = Texture.new(xtexpath)
	self.spritesheetimgs = {} -- table that will hold all the images in the sprite sheet
	self.anims = {} -- table that will hold all our animations ("idle", "run", ...)
	-- 1 retrieve all anims in spritesheet
	local ssw, ssh = spritesheettex:getWidth()/xcols, spritesheettex:getHeight()/xrows
	local spritesheettexregion = nil
	for r = 1, xrows do
		for c = 1, xcols do
			spritesheettexregion = TextureRegion.new(spritesheettex, (c - 1) * ssw, (r - 1) * ssh, ssw, ssh)
			self.spritesheetimgs[#self.spritesheetimgs + 1] = spritesheettexregion
		end
	end
	-- 2 create animations
	self:createAnim("idle", 1, 12)
	-- 3 we can now create the bitmap
	self.img = Bitmap.new(self.spritesheetimgs[1])
	self.img:setAnchorPoint(0.5, 0.5)
--	print("bmp size before scaling", params2.ROLE, ssw, ssh)
	self.img:setScale(xscale)
--	self.img:setColorTransform(params2.r, params2.g, params2.b, params2.a)
--	self.img:setPosition(params2.offsetx, params2.offsety)
	self.img:setPosition(self.body:getPosition())
	self:addChild(self.img)
	-- anim
	self.body.animspeed = 1 / 10
	self.body.animtimer = self.body.animspeed
	self.body.currentanim = "idle"
	self.body.frame = 1
	self.isssanim = true
end

function Collectibles:createAnim(xanimname, xstart, xfinish)
	self.anims[xanimname] = {}
	for i = xstart, xfinish do
		self.anims[xanimname][#self.anims[xanimname] + 1] = self.spritesheetimgs[i]
	end
end

function Collectibles:playAnim(xdt)
	if self.body.currentanim ~= "" then
		self.body.animtimer = self.body.animtimer - xdt
		if self.body.animtimer <= 0 then
			self.body.frame += 1
			self.body.animtimer = self.body.animspeed
			-- for debugging purpose -- comment before release! XXX
			if (self.anims[self.body.currentanim] or 0) == 0 then
				print("### PLAYANIM ERROR###", self.body.role, self.body.currentanim)
			end
			-- fx
			if self.body.isdead then
				if self.body.frame > #self.anims[self.body.currentanim] then
					self.body.frame = #self.anims[self.body.currentanim]
					if self.body.role == G_PLAYER then self.body.timer = 0 end
				end
			else
				if self.body.frame > #self.anims[self.body.currentanim] then self.body.frame = 1 end
			end
			self.img:setTextureRegion(self.anims[self.body.currentanim][self.body.frame])
		end
	end
end
