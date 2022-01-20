Tiled_Shape_Polygon = Core.class(Sprite)

function Tiled_Shape_Polygon:init(xworld, xparams)
	-- params
	local params = xparams or {}
	params.x = xparams.x or nil
	params.y = xparams.y or nil
	params.coords = xparams.coords or nil
	params.color = xparams.color or nil -- hex
	params.r = xparams.r or 1
	params.g = xparams.g or 1
	params.b = xparams.b or 1
	params.alpha = xparams.alpha or 1
	params.texpath = xparams.texpath or nil
	params.isshape = xparams.isshape or nil
	params.shapelinewidth = xparams.shapelinewidth or 0
	params.shapelinecolor = xparams.shapelinecolor or nil
	params.shapelinealpha = xparams.shapelinealpha or 1
	params.isbmp = xparams.isbmp or nil
	params.ispixel = xparams.ispixel or nil
	params.isdeco = xparams.isdeco or not (xparams.isdeco == nil) -- default = false
	params.scalex = xparams.scalex or 1
	params.scaley = xparams.scaley or params.scalex
	params.rotation = xparams.rotation or 0
	params.type = xparams.type or nil -- default = b2.STATIC_BODY
	params.fixedrotation = xparams.fixedrotation or (xparams.fixedrotation == nil) -- default to true
	params.density = xparams.density or nil
	params.restitution = xparams.restitution or nil
	params.friction = xparams.friction or nil
	params.gravityscale = xparams.gravityscale or 1
	params.BIT = xparams.BIT or nil
	params.COLBIT = xparams.COLBIT or nil
	params.ROLE = xparams.ROLE or nil
	params.data = xparams.data or nil
	params.value = xparams.value or nil
	-- the world
	self.world = xworld
	-- image
	if params.BIT == G_BITSENSOR and not params.tex and not params.isshape and not params.isbmp then
		-- no image for sensors
	else
		-- a function
		local pw, ph = 0, 0 -- the polygon dimensions
		local function sizes()
			-- calculate polygon width and height
			local minx, maxx, miny, maxy = 0, 0, 0, 0
			for k, v in pairs(params.coords) do
				--print("polygon coords", k, v.x, v.y)
				if v.x <= minx then minx = v.x end
				if v.y <= miny then miny = v.y end
				if v.x >= maxx then maxx = v.x end
				if v.y >= maxy then maxy = v.y end
			end
			pw, ph = maxx - minx, maxy - miny -- the polygon dimensions
--			print(pw, ph)
		end
		if params.isshape then
			self.img = Shape.new()
			self.img:setLineStyle(params.shapelinewidth, params.shapelinecolor, params.shapelinealpha) -- (width, color, alpha)
			if params.texpath then
--				local tex = Texture.new(params.texpath, false, {wrap = TextureBase.REPEAT})
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
			self.img:moveTo(params.coords[1].x, params.coords[1].y)
			for p = 2, #params.coords do
				self.img:lineTo(params.coords[p].x, params.coords[p].y)
			end
			self.img:closePath()
			self.img:endPath()
			self.img:setRotation(params.rotation)
			self.img:setAlpha(params.alpha)
			self.img:setColorTransform(params.r, params.g, params.b, params.alpha)
			self.w, self.h = self.img:getWidth(), self.img:getHeight()
--			print(self.w, self.h)
		end
		if params.isbmp then
			if not params.texpath then print("!!!YOU MUST PROVIDE A TEXTURE FOR THE BITMAP!!!") return end
			sizes() -- calculate polygon width and height
			local tex = Texture.new(params.texpath, false)
			self.img = Bitmap.new(tex)
			self.img.isbmp = true
			self.img.w, self.img.h = pw, ph
			self.img:setAnchorPoint(0.5, 0.5)
			if params.rotation > 0 then self.img:setAnchorPoint(0, 0.5) end
			if params.rotation < 0 then self.img:setAnchorPoint(0.5, 1) end
			self.img:setScale(params.scalex, params.scaley)
			self.img:setRotation(params.rotation)
			tex = nil
		end
		if params.ispixel then
			if params.texpath then
				sizes() -- calculate polygon width and height
				local tex = Texture.new(params.texpath, false, {wrap = TextureBase.REPEAT})
				self.img = Pixel.new(tex, pw, ph)
				self.img.ispixel = true
				self.img.w, self.img.h = pw, ph
				self.img:setAnchorPoint(0, -0.5) -- 0.5, 0.5
				if params.rotation > 0 then self.img:setAnchorPoint(0, 0.5) end
				if params.rotation < 0 then self.img:setAnchorPoint(0.5, 1) end
				self.img:setScale(params.scalex, params.scaley)
				self.img:setRotation(params.rotation)
				self.img:setTexturePosition(0, 0)
				tex = nil
			else
				-- calculate polygon width and height
				local minx, maxx, miny, maxy = 0, 0, 0, 0
				for k, v in pairs(params.coords) do
					--print("polygon coords", k, v.x, v.y)
					if v.x < minx then minx = v.x end
					if v.y < miny then miny = v.y end
					if v.x > maxx then maxx = v.x end
					if v.y > maxy then maxy = v.y end
				end
				local pw, ph = maxx - minx, maxy - miny -- the polygon dimensions
				self.img = Pixel.new(params.color, 1, pw, ph)
				self.img.ispixel = true
				self.img.w, self.img.h = pw, ph
				self.img:setScale(params.scalex, params.scaley)
				self.img:setRotation(params.rotation)
			end
		end
		-- debug
		if self.img then
			if xworld.isdebug then self.img:setAlpha(0.5) end
			self:addChild(self.img)
		end
	end
	if not params.isdeco then
		-- body b2.STATIC_BODY, b2.KINEMATIC_BODY, b2.DYNAMIC_BODY
		self.body = xworld:createBody {type = params.type}
		self.body:setGravityScale(params.gravityscale)
		self.body.role = params.ROLE
		self.body.isdirty = false
		self.body:setFixedRotation(params.fixedrotation)
		self.body:setAngle(^<params.rotation)
		self.body.img = self.img
		self.body.data = params.data
		self.body.value = params.value
		-- the shape
		local shape
		local cs = {}
		for c = 1, #params.coords do
			cs[#cs+1] = params.coords[c].x
			cs[#cs+1] = params.coords[c].y
		end
		if #params.coords == 2 then -- this is a line
			shape = b2.EdgeShape.new(cs[1], cs[2], cs[3], cs[4])
		else -- this is a polygon
			shape = b2.ChainShape.new()
			shape:createLoop(unpack(cs)) -- XXX
		end
		local fixture = self.body:createFixture {
			shape = shape,
			density = params.density, restitution = params.restitution, friction = params.friction
		}
		if params.BIT == G_BITSENSOR then fixture:setSensor(true) end
		local filterData = { categoryBits = params.BIT, maskBits = params.COLBIT, groupIndex = 0 }
		fixture:setFilterData(filterData)
		-- clean up?
		filterData = nil
		fixture = nil
		cs = nil
		shape = nil
	end
	-- listeners
	if params.ROLE == G_EXIT then
		self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	end
end

function Tiled_Shape_Polygon:onEnterFrame()
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
end

function Tiled_Shape_Polygon:setPosition(xposx, xposy)
	if self.body then
		self.body:setPosition(xposx, xposy)
		if self.img then self.img:setPosition(self.body:getPosition()) end
	else
		if self.img then self.img:setPosition(xposx, xposy) end
	end
end

function Tiled_Shape_Polygon:reload()
	scenemanager:changeScene("levelX", 2, transitions[1], easings[1])
end
