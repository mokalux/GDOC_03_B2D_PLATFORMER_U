Tiled_Shape_Ellipse = Core.class(Sprite)

function Tiled_Shape_Ellipse:init(xworld, xparams)
	-- params
	local params = xparams or {}
	params.x = xparams.x or nil
	params.y = xparams.y or nil
	params.w = xparams.w or 32
	params.h = xparams.h or 32
	params.steps = xparams.steps or 32 -- 24
	params.color = xparams.color or nil
	params.r = xparams.r or 1
	params.g = xparams.g or 1
	params.b = xparams.b or 1
	params.alpha = xparams.alpha or 1
	params.texpath = xparams.texpath or nil
	params.isdeco = xparams.isdeco or not (xparams.isdeco == nil) -- default = false
	params.isshape = xparams.isshape or nil
	params.shapelinewidth = xparams.shapelinewidth or nil
	params.shapelinecolor = xparams.shapelinecolor or nil
	params.shapelinealpha = xparams.shapelinealpha or 1
	params.isbmp = xparams.isbmp or nil
	params.ispixel = xparams.ispixel or nil
	params.scalex = xparams.scalex or 1
	params.scaley = xparams.scaley or params.scalex
	params.rotation = xparams.rotation or 0
	params.type = xparams.type or nil -- default = b2.STATIC_BODY
	params.fixedrotation = xparams.fixedrotation or (xparams.fixedrotation == nil) -- default to true
	params.density = xparams.density or 0
	params.restitution = xparams.restitution or nil
	params.friction = xparams.friction or nil
	params.gravityscale = xparams.gravityscale or 1
	params.BIT = xparams.BIT or nil
	params.COLBIT = xparams.COLBIT or nil
	params.ROLE = xparams.ROLE or nil
	params.data = xparams.data or nil
	-- the world
	self.world = xworld
	-- image
	if params.BIT == G_BITSENSOR and not params.tex and not params.isshape and not params.isbmp then
		-- no image for sensors
	else
		local sin, cos = math.sin, math.cos
		if params.isshape then
			self.img = Shape.new()
			if params.shapelinewidth then
				self.img:setLineStyle(params.shapelinewidth, params.shapelinecolor, params.shapelinealpha)
			end
			if params.texpath then
				local tex = Texture.new(params.texpath, false, {wrap = TextureBase.REPEAT, extend=false}) -- new 20211110 XXX
				local matrix = Matrix.new(params.scalex, 0, 0, params.scaley, 0, 0)
				self.img:setFillStyle(Shape.TEXTURE, tex, matrix)
				tex = nil
			elseif params.color then
				self.img:setFillStyle(Shape.SOLID, params.color, params.alpha)
			else
				self.img:setFillStyle(Shape.NONE)
			end
			self.img:beginPath()
			for i = 0, 360, 360 / params.steps  do
				self.img:lineTo(
					(params.w / 2) + params.w / 2 * cos(^<i),
					(params.h / 2) + params.h / 2 * sin(^<i)
				)
			end
			self.img:endPath()
			self.img:setRotation(params.rotation)
			self.img:setAlpha(params.alpha)
			self.img:setColorTransform(params.r, params.g, params.b, params.alpha)
		end
		if params.isbmp then
			if not params.texpath then print("!!!YOU MUST PROVIDE A TEXTURE FOR THE BITMAP!!!") return end
			local tex = Texture.new(params.texpath, false)
			self.img = Bitmap.new(tex)
			self.img:setAnchorPoint(0.5, 0.5)
			self.img:setScale(params.scalex, params.scaley)
			self.img:setRotation(params.rotation)
			params.w, params.h = self.img:getWidth(), self.img:getHeight()
--			print("bmp", params.w, params.h, params.rotation)
			tex = nil
		end
		if params.ispixel then
			if params.texpath then
				local tex = Texture.new(params.texpath, false, {wrap = TextureBase.REPEAT})
				self.img = Pixel.new(tex, params.w, params.h)
				self.img.ispixel = true
--				self.img.w, self.img.h = params.w, params.h
				self.img:setScale(params.scalex, params.scaley)
				self.img:setRotation(params.rotation)
--				print("pixel", params.w, params.h, params.rotation)
				tex = nil
			else
				self.img = Pixel.new(0xff0000, 1, params.w, params.h)
				self.img.ispixel = true
--				self.img.w, self.img.h = params.w, params.h
				self.img:setScale(params.scalex, params.scaley)
				self.img:setRotation(params.rotation)
--				print("pixel", params.w, params.h, params.rotation)
			end
		end
		-- debug
		if self.img then
			if self.world.isdebug then self.img:setAlpha(0.5) end
			self:addChild(self.img)
		end
	end
	if not params.isdeco then
		-- body
		self.body = self.world:createBody { type = params.type } -- b2.STATIC_BODY, b2.KINEMATIC_BODY, b2.DYNAMIC_BODY
		self.body:setGravityScale(params.gravityscale)
		self.body.role = params.ROLE
		self.body.isdirty = false
		self.body:setFixedRotation(params.fixedrotation)
		self.body:setAngle(^<params.rotation)
		self.body.img = self.img
		self.body.data = params.data
		-- the shape
		local sin, cos = math.sin, math.cos
		if params.w ~= params.h then -- oval
--			print("oval")
			local cs = {}
			for i = 0, 360, 360 / params.steps  do
				cs[#cs + 1] = (params.w / 2) + params.w / 2 * cos(^<i)
				cs[#cs + 1] = (params.h / 2) + params.h / 2 * sin(^<i)
			end
			local shape = b2.ChainShape.new()
			shape:createLoop(unpack(cs))
			local fixture = self.body:createFixture {
				shape = shape,
				density = params.density, restitution = params.restitution, friction = params.friction
			}
			if params.BIT == G_BITSENSOR then fixture:setSensor(true) end
			local filterData = { categoryBits = params.BIT, maskBits = params.COLBIT, groupIndex = 0 }
			fixture:setFilterData(filterData)
		else -- circle
--			print("circle")
			local hypo = params.w / 2 + params.h / 2
			local shape = b2.CircleShape.new(
				hypo / 2,
				hypo / 2,
				params.w / 2) -- (centerx, centery, radius)
			local fixture = self.body:createFixture {
				shape = shape,
				density = params.density, restitution = params.restitution, friction = params.friction
			}
			if params.BIT == G_BITSENSOR then fixture:setSensor(true) end
			local filterData = { categoryBits = params.BIT, maskBits = params.COLBIT, groupIndex = 0 }
			fixture:setFilterData(filterData)
		end
		-- clean up?
		filterData = nil
		fixture = nil
		shape = nil
	end
	-- listeners
	if params.ROLE == G_EXIT or params.ROLE == G_MOVEABLE then
		self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	end
end

function Tiled_Shape_Ellipse:onEnterFrame()
	if self.body then
		if self.body.isdirty then
			self.world:destroyBody(self.body)
			self:getParent():removeChild(self)
			if self.body.role == G_EXIT then
				g_currentlevel += 1
				if g_currentlevel > #tiled_levels then g_currentlevel = 1 end
				self:reload()
			end
			self.body = nil
		end
	end
	if self.body.role == G_MOVEABLE then
		if self.body then
			if self.img then
				self.img:setPosition(self.body:getPosition())
				self.img:setRotation(^>self.body:getAngle())
			end
		end
	end
end

function Tiled_Shape_Ellipse:setPosition(xposx, xposy)
	if self.body then
		self.body:setPosition(xposx, xposy)
		if self.img then
			self.img:setPosition(self.body:getPosition())
			self.img:setRotation(^>self.body:getAngle())
		end
	else
		if self.img then
			self.img:setPosition(xposx, xposy)
			self.img:setRotation(self.img:getRotation() + 0 * 180 / math.pi) -- ???
		end
	end
end

function Tiled_Shape_Ellipse:reload()
	scenemanager:changeScene("levelX", 5, transitions[1], easings[1])
end
