LF_Dynamic_Bullet = Core.class(Sprite)

function LF_Dynamic_Bullet:init(xworld, xparams)
	-- the params
	local params = xparams or {}
	params.tex = xparams.tex or nil
	params.scale = xparams.scale or 1
	params.alpha = xparams.alpha or 1
	params.fixedrotation = xparams.fixedrotation or nil
	params.gravityscale = xparams.gravityscale or nil
	params.ttl = xparams.ttl or nil
	params.BIT = xparams.BIT or nil
	params.COLBIT = xparams.COLBIT or nil
	params.ROLE = xparams.ROLE or nil
	params.bulletdamage = xparams.bulletdamage or nil
	-- class variables
	self.defaultttl = params.ttl
	self.ttl = self.defaultttl
	self.bulletcreated = nil -- for performance
	-- the image
	self.bitmap = Bitmap.new(params.tex)
	self.bitmap:setScale(params.scale)
	self.bitmap:setAnchorPoint(0.5, 0.5)
	self.bitmap:setAlpha(params.alpha)
	self:addChild(self.bitmap)
	local w, h = self.bitmap:getWidth(), self.bitmap:getHeight()
	-- the body
	self.bulletbody = xworld:createBody { type = b2.DYNAMIC_BODY }
	self.bulletbody:setFixedRotation(params.fixedrotation)
	self.bulletbody:setGravityScale(params.gravityscale)
	self.bulletbody:setBullet(true)
	-- the shape
	local shape = b2.CircleShape.new(0, 0, w / 2)
	local fixture = self.bulletbody:createFixture { shape=shape, density=1, restitution=0, friction=1 }
	fixture:setFilterData( { categoryBits=params.BIT, maskBits=params.COLBIT, groupIndex=0 } )
	-- body vars
	self.bulletbody.role = params.ROLE
	self.bulletbody.isdirty = false
	-- clean
	fixture = nil
	shape = nil
	params = nil
	-- let's go!
	self.bulletbody:setActive(false)
	-- listeners
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

-- functions
local PI180 = 180 / math.pi

function LF_Dynamic_Bullet:shoot(xposx, xposy, xflip, xvelx, xvely)
	self.bulletbody:setLinearVelocity(0, 0) -- reset velocity
	self.bulletbody:setAngle(0) -- reset angle
	self.bulletbody:setPosition(xposx, xposy)
	self.bulletbody:setActive(true)
	self.bulletbody:applyLinearImpulse(xvelx, xvely, self.bulletbody:getWorldCenter()) -- physics
	self.bulletcreated = true
end

function LF_Dynamic_Bullet:remove()
	self.bulletbody:setPosition(0, 0) -- magik xxx
	self.bulletbody:setActive(false)
	self.bitmap:setPosition(self.bulletbody:getPosition())
	self.bulletbody.isdirty = false
	self.ttl = self.defaultttl
	self.bulletcreated = nil
end

-- game loop
function LF_Dynamic_Bullet:onEnterFrame(e)
	if self.bulletcreated then
		if self.bulletbody.isdirty then self:remove() return end
		self.bitmap:setPosition(self.bulletbody:getPosition())
		self.bitmap:setRotation(self.bulletbody:getAngle() * PI180)
		self.ttl -= 0.1 -- magik xxx
		if self.ttl < 0 then self.bulletbody.isdirty = true end
	end
end
