Tiled_Contour_Static = Core.class(Sprite)

function Tiled_Contour_Static:init(xworld, xparams)
	-- params
	local params = xparams or {}
	params.x = xparams.x or nil
	params.y = xparams.y or nil
	params.w = xparams.w or nil
	params.h = xparams.h or nil
	params.rotation = xparams.rotation or nil
	params.color = xparams.color or nil
	params.r = xparams.r or 1
	params.g = xparams.g or 1
	params.b = xparams.b or 1
	params.alpha = xparams.alpha or 1
	params.texpath = xparams.texpath or nil
	params.istexpot = xparams.istexpot or nil
	params.isdeco = xparams.isdeco or not (xparams.isdeco == nil) -- default = false
	params.isshape = xparams.isshape or nil
	params.shapelinewidth = xparams.shapelinewidth or 0
	params.shapelinecolor = xparams.shapelinecolor or nil
	params.shapelinealpha = xparams.shapelinealpha or 1
	params.isbmp = xparams.isbmp or nil
	params.ispixel = xparams.ispixel or nil
	params.scalex = xparams.scalex or 1
	params.scaley = xparams.scaley or params.scalex
	params.type = xparams.type or nil -- default = b2.STATIC_BODY
	params.fixedrotation = xparams.fixedrotation or nil
	params.density = xparams.density or nil
	params.restitution = xparams.restitution or nil
	params.friction = xparams.friction or nil
	params.gravityscale = xparams.gravityscale or 1
	params.BIT = xparams.BIT or nil
	params.COLBIT = xparams.COLBIT or nil
	params.ROLE = xparams.ROLE or nil
	params.data = xparams.data or nil
	-- the world
	self.world = xworld
	-- the others
--	self.w = params.w
--	self.h = params.h
	self.rotation = params.rotation
	self.BIT = params.BIT
	self.COLBIT = params.COLBIT
	-- image
	local texture = Texture.new(params.texpath)
	local image = Bitmap.new(texture)
	image:setScale(params.scalex, params.scaley)
	self.w, self.h = image:getWidth(), image:getHeight()
	local render = RenderTarget.new(self.w, self.h)
	render:draw(image)
	self.bitmap = Bitmap.new(render)
	self:addChild(self.bitmap)
	-- contour
	local contour = Contour.trace(render)
	contour = Contour.clean(contour)
	-- the body
	self.body = xworld:createBody { type = b2.STATIC_BODY }
	self.body.role = params.ROLE
	self.body:setAngle(^<params.rotation)
	local shapes = Contour.shape(contour)
	local fixture = { density = params.density, restitution = params.restitution, friction = params.friction }
	local filterData = { categoryBits = params.BIT, maskBits = params.COLBIT, groupIndex = 0 }
	Contour.apply(self.body, shapes, fixture, filterData)
end

function Tiled_Contour_Static:setPosition(xposx, xposy)
	self.body:setPosition(xposx, xposy)
	self.bitmap:setPosition(self.body:getPosition())
	self.bitmap:setRotation(self.body:getAngle() * 180 / math.pi)
end
