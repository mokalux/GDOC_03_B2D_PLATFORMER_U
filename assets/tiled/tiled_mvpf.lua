--!NEEDS:tiled_rectangle.lua

Tiled_MvPf = Core.class(Tiled_Shape_Rectangle)

function Tiled_MvPf:init()
	if self.body:getType() == b2.STATIC_BODY then
		print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
		print("YOUR BODY SHOULD NOT BE OF TYPE STATIC_BODY!")
		print(self.body.role)
		print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
	end
	-- the left side
	local shapeL = b2.PolygonShape.new()
	shapeL:setAsBox(
		0, self.h / 2, -- half w, half h
		0, self.h / 2, -- centerx, centery
		0) -- rotation
	local fixtureL = self.body:createFixture {
		shape = shapeL, density = 0, restitution = 0, friction = 0
	}
	-- the right side
	local shapeR = b2.PolygonShape.new()
	shapeR:setAsBox(
		0, self.h / 2, -- half w, half h
		self.w, self.h / 2, -- centerx, centery
		0) -- rotation
	local fixtureR = self.body:createFixture {
		shape = shapeR, density = 0, restitution = 0, friction = 0
	}
	-- filter data
	if self.BIT == G_BITSENSOR then
		fixtureR:setSensor(true)
		fixtureL:setSensor(true)
	end
	local filterData = { categoryBits = self.BIT, maskBits = self.COLBIT, groupIndex = 0 }
	fixtureL:setFilterData(filterData)
	fixtureR:setFilterData(filterData)
	-- clean up?
	fixtureR = nil
	fixtureL = nil
	shapeR = nil
	shapeL = nil
	-- img
	self.body.img = self.img
	-- movements
	self.directionx = 0
	self.directiony = 0
	self.minx, self.maxx = 0, 0
	self.miny, self.maxy = 0, 0
	self.vx = 0
	self.vy = 0
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

local posx, posy = 0, 0
function Tiled_MvPf:onEnterFrame(e)
	local dt = e.deltaTime
	posx, posy = self.body:getPosition()
	if posx >= self.maxx then self.directionx = -1
	elseif posx <= self.minx then self.directionx = 1
	end
	if posy >= self.maxy then self.directiony = -1
	elseif posy <= self.miny then self.directiony = 1
	end
	self.body:setLinearVelocity(self.vx*dt*self.directionx, self.vy*dt*self.directiony)
	if self.img then
		self.img:setPosition(self.body:getPosition())
		self.img:setRotation(^<self.body:getAngle())
	end
end
