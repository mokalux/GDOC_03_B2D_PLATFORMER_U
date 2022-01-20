--!NEEDS:tiled_polygon.lua
Tiled_Door = Core.class(Tiled_Shape_Polygon)

function Tiled_Door:init()
	-- extra
	self.body.isactive = false
	self.body.timer = 80
	-- add a left and right shape for sliding effect
	local shapeL = b2.PolygonShape.new()
	shapeL:setAsBox(
		2, self.h / 2, -- half w, half h
		-1, self.h / 2, -- centerx, centery
		0 -- rotation
	)
	local fixtureL = self.body:createFixture{
		shape = shapeL, density = 1, restitution = 0, friction = 0,
	}
	local shapeR = b2.PolygonShape.new()
	shapeR:setAsBox(
		2, self.h / 2, -- half w, half h
		self.w + 1, self.h / 2, -- centerx, centery
		0 -- rotation
	)
	local fixtureR = self.body:createFixture{
		shape = shapeR, density = 1, restitution = 0, friction = 0,
	}
	-- clean
	fixtureR = nil
	shapeR = nil
	fixtureL = nil
	shapeL = nil
	-- others
	self.snd = Sound.new("audio/Collectibles_1.wav")
	self.volume = g_sfxvolume*0.01 * 0.3
	-- events listeners
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function Tiled_Door:onEnterFrame(e)
	if self.body then
		if self.body.isdirty then
			-- move up
			if self.body.timer > 0 then
				self.body.timer -= 0.75
				self.body:setLinearVelocity(0, -2)
				if self.body.img then
					self.body.img:setPosition(self.body:getPosition())
					self.body.img:setRotation(^<self.body:getAngle())
				end
			else
				self.body:setLinearVelocity(0, 0)
				self.body = nil
				self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
			end
		end
	end
end
