--!NEEDS:tiled_rectangle.lua

Tiled_PtPf = Core.class(Tiled_Shape_Rectangle)

function Tiled_PtPf:init()
	-- here we build a special body with a 0 pixel height to solve accumulating acceleration?
	self.world:destroyBody(self.body)
	self.body = self.world:createBody { type = b2.STATIC_BODY } -- b2.STATIC_BODY, b2.KINEMATIC_BODY, b2.DYNAMIC_BODY
	self.body.role = G_PTPLATFORM
	self.body:setAngle(^<self.rotation)
	-- the main shape
	local shape = b2.PolygonShape.new()
	shape:setAsBox(
		self.w / 2, 0, -- half w, half h
		self.w / 2, 0, -- centerx, centery
		0) -- rotation
	local fixture = self.body:createFixture {
		shape = shape, density = 0, restitution = 0, friction = 1
	}
	-- filter data
	local filterData = { categoryBits = self.BIT, maskBits = self.COLBIT, groupIndex = 0 }
	fixture:setFilterData(filterData)
	-- clean up?
	filterData = nil
	fixture = nil
	shape = nil
	-- img
	self.body.img = self.img
end
