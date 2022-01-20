Level_Select = Core.class(Sprite)

function Level_Select:init()
	-- application
	application:setBackgroundColor(0x0)
	-- BGM
	self.audio = Audio.new()
	self.audio:playBgm("audio/dinosaur-2.wav") -- xratio
	self.volume = g_sfxvolume * 0.01 * 0.5
	-- bg
	local bg = Pixel.new(0xffffff, 1, myappwidth, myappheight)
	bg:setColor(0x0700FA, 1, 0x980DFD, 1, 90)
	-- level select
	self.mytitle = ButtonMonster.new({
		text="SELECT LEVEL", ttf=font00, textcolorup=0xff5959,
		hover=false,
	})
	-- buttons
	self.selector = 1
	self.sound = Sound.new("audio/DM-CGS-16.ogg") -- shared amongst ui buttons
	self.channelS = self.sound:play(0, nil, true) -- shared amongst ui buttons
	local pixelcolor = 0x3d2e33 -- shared amongst ui buttons
	local pixelalphaup = 0.2 -- shared amongst ui buttons
	local pixelalphadown = 0.5 -- shared amongst ui buttons
	local textcolorup = 0x0009B3 -- shared amongst ui buttons
	local textcolordown = 0x45d1ff -- shared amongst ui buttons
	local mybtn = ButtonMonster.new({
		btnscalexup=1.5, btnscalexdown=1.7,
		imguppath="tiled/levels/city01/pexels-harrison-haines-2973098C5.png", imgpaddingx=128, imgpaddingy=96,
		text="LEVEL 1", ttf=font02, textcolorup=textcolorup, textcolordown=textcolordown,
		channel=self.channelS, sound=self.sound, volume=self.volume,
	}, 1)
	local mybtn02 = ButtonMonster.new({
		btnscalexup=1.5, btnscalexdown=1.7,
		imguppath="tiled/levels/forest/parallax1.png", imgpaddingx=128, imgpaddingy=96,
		text="LEVEL 2", ttf=font02, textcolorup=textcolorup, textcolordown=textcolordown,
		channel=self.channelS, sound=self.sound, volume=self.volume,
	}, 2)
	local mybtn03 = ButtonMonster.new({
		btnscalexup=1.3, btnscalexdown=1.5,
		pixelcolorup=pixelcolor, pixelalphaup=pixelalphaup, pixelalphadown=pixelalphadown,
		text="MENU", ttf=font02, textcolorup=textcolorup, textcolordown=textcolordown,
		channel=self.channelS, sound=self.sound, volume=self.volume,
	}, 3)
	-- positions
	self.mytitle:setPosition(myappwidth/2, 0.75*myappheight/10)
	mybtn:setPosition(0.5*myappwidth/2, 3.5*myappheight/10)
	mybtn02:setPosition(1.5*myappwidth/2, 3.5*myappheight/10)
	mybtn03:setPosition(myappwidth - mybtn03:getWidth(), myappheight - mybtn03:getHeight())
	-- order
	self:addChild(bg)
	self:addChild(self.mytitle)
	self:addChild(mybtn)
	self:addChild(mybtn02)
	self:addChild(mybtn03)
	-- btns table
	self.btns = {}
	self.btns[#self.btns + 1] = mybtn
	self.btns[#self.btns + 1] = mybtn02
	self.btns[#self.btns + 1] = mybtn03
	-- btns listeners
	for k, v in ipairs(self.btns) do
		v:addEventListener("clicked", function() self:goto() end) -- click event
		v.btns = self.btns -- ui navigation update
	end
	-- let's go!
	self:updateUiVfx()
	-- LISTENERS
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

-- GAME LOOP
local timer = 0
function Level_Select:onEnterFrame(e)
end

-- EVENT LISTENERS
function Level_Select:onTransitionInBegin() self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self) end
function Level_Select:onTransitionInEnd() self:myKeysPressed() end
function Level_Select:onTransitionOutBegin() self.audio:mute("bgm") self:removeAllListeners()  end
function Level_Select:onTransitionOutEnd() end

-- KEYS HANDLER
function Level_Select:myKeysPressed()
	self:addEventListener(Event.KEY_DOWN, function(e)
		-- for mobiles and desktops
		if e.keyCode == KeyCode.BACK or e.keyCode == KeyCode.ESC then self:back() end
		-- keyboard
		if e.keyCode == KeyCode.UP or e.keyCode == g_keyup or e.keyCode == KeyCode.LEFT or e.keyCode == g_keyleft then
			self.selector -= 1 if self.selector < 1 then self.selector = #self.btns end
			self:updateUiVfx() self:updateUiSfx()
		elseif e.keyCode == KeyCode.DOWN or e.keyCode == g_keydown or e.keyCode == KeyCode.RIGHT or e.keyCode == g_keyright then
			self.selector += 1 if self.selector > #self.btns then self.selector = 1 end
			self:updateUiVfx() self:updateUiSfx()
		end
		-- modifier
		local modifier = application:getKeyboardModifiers()
		local alt = (modifier & KeyCode.MODIFIER_ALT) > 0
		-- action
		if (not alt and e.keyCode == KeyCode.ENTER) or e.keyCode == g_keyaction1 then self:goto() end
		-- switch full screen
		if alt and e.keyCode == KeyCode.ENTER then isfullscreen = not isfullscreen setFullScreen(isfullscreen) end
	end)
end

-- fx
function Level_Select:updateUiVfx()
	for k, v in ipairs(self.btns) do v.iskeyboard = true v:updateVisualState() end
end
function Level_Select:updateUiSfx()
	for k, v in ipairs(self.btns) do
		if k == self.selector then self.channelS = self.sound:play() self.channelS:setVolume(self.volume) end
	end
end

-- scenes ui keyboard navigation
function Level_Select:goto()
	for k, v in ipairs(self.btns) do
		if k == self.selector then
			if v.isdisabled then print("btn disabled!", k)
			elseif k == 1 then g_currentlevel = k scenemanager:changeScene("levelX", 2, transitions[17], easings[19])
			elseif k == 2 then g_currentlevel = k scenemanager:changeScene("levelX", 2, transitions[17], easings[19])
			elseif k == 3 then self:back()
			else print("nothing here!", k)
			end
		end
	end
end

function Level_Select:back() scenemanager:changeScene("menu", 1, transitions[2], easings[2]) end
