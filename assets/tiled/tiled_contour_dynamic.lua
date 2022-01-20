LF_Contour_Dynamic = Core.class(Sprite)

function LF_Contour_Dynamic:init(xworld, xtexture, xscalex, xscaley, xvelx, xvely,
			xfixedrotation, xdensity, xrestitution, xfriction, xtype)
	self.world = xworld

	local texture = Texture.new(xtexture)
	local image = Bitmap.new(texture)
	image:setScale(xscalex, xscaley)
	self.w, self.h = image:getWidth(), image:getHeight()
	local render = RenderTarget.new(self.w, self.h)
	render:draw(image)
	self.bitmap = Bitmap.new(render)
	self:addChild(self.bitmap)
	local contour = Contour.trace(render)
	contour = Contour.clean(contour)
	local shapes = Contour.shape(contour)

	self.body = xworld:createBody { type = b2.DYNAMIC_BODY }
	self.body.type = xtype
	self.body.isdead = false
	self.body:setFixedRotation(xfixedrotation)
	local fixture = { density = xdensity, restitution = xrestitution, friction = xfriction }
--	local filterData = { categoryBits = g_nme, maskBits = g_wall + g_bullet + g_player + g_platform + g_passthroughplatform, groupIndex = 0 }
	local filterData = { categoryBits = g_nme, maskBits = g_wall + g_bullet + g_player + g_passthroughplatform, groupIndex = 0 }
	Contour.apply(self.body, shapes, fixture, filterData)
	self.body:setLinearVelocity(xvelx, xvely)

	-- listeners
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function LF_Contour_Dynamic:onEnterFrame(e)
	if self.body ~= nil then
		if self.body.isdead then
			self.world:destroyBody(self.body)
			self:getParent():removeChild(self)
			self.body = nil
			return
		end
		-- bitmap
		self.bitmap:setPosition(self.body:getPosition())
		self.bitmap:setRotation(self.body:getAngle() * 180 / math.pi)
	end
end
