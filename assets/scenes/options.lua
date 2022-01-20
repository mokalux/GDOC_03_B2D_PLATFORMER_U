Options = Core.class(Sprite)

local keyNames = {
  [KeyCode.LEFT] = "LEFT",
  [KeyCode.RIGHT] = "RIGHT",
  [KeyCode.UP] = "UP",
  [KeyCode.DOWN] = "DOWN",
  [KeyCode.SPACE] = "SPACE",
  [KeyCode.BACKSPACE] = "BACKSPACE",
  [KeyCode.SHIFT] = "SHIFT",
  [KeyCode.CTRL] = "CONTROL",
  [KeyCode.ALT] = "ALT",
  [KeyCode.TAB] = "TAB",
  [KeyCode.F1] = "F1",
}

function Options:init()
	-- application
	application:setBackgroundColor(0x0)
	-- BGM
	self.audio = Audio.new()
	self.audio:playBgm("audio/dinosaur-3.wav") -- xratio
	self.volume = g_sfxvolume * 0.01 * 0.5
	-- bg
	local bg = Pixel.new(0xffffff, 1, myappwidth, myappheight)
	bg:setColor(0x0700FA, 1, 0x980DFD, 1, 90)
	-- title
	self.mytitle = ButtonMonster.new({
		text="OPTIONS", ttf=font00, textcolorup=0xff5959,
		hover=false,
	})
	-- sliders
	local volumeslider = SliderText.new({
		initialvalue=g_sfxvolume, maximum=100, -- steps=2,
		slitcolor=0x330033, slitalpha=1, slitw=myappwidth - 2*64, slith=64,
		knobcolor=0x00ffff, knobalpha=0.6, knobw=40, knobh=80,
		text="VOLUME: ", textscale=4, textoffsetx=0, textoffsety=-44, textrotation=0,
		id=1,
	})
	self.difficultyslider = SliderText.new({
		initialvalue=g_difficulty, maximum=2, --steps=2,
		slitcolor=0x330033, slitalpha=1, slitw=(myappwidth - 2*64) / 2, slith=64,
		knobcolor=0x00ffff, knobalpha=0.6, knobw=40, knobh=80,
		text=nil, textscale=4, textoffsetx=0, textoffsety=-44, textrotation=0,
		id=2,
	})
	-- buttons
	self.selector = 1
	self.isselected = false
	self.sound = Sound.new("audio/DM-CGS-16.ogg") -- shared amongst ui buttons
	self.channelS = self.sound:play(0, nil, true) -- shared amongst ui buttons
	-- btns key mapping
	local key, keycode
	if (keyNames[g_keyleft] or 0) == 0 then key = utf8.char(g_keyleft) keycode = g_keyleft
	else key = keyNames[g_keyleft] keycode = g_keyleft
	end
	self.btnLEFT = ButtonMonster.new({
		btnscalexup=1.3, btnscalexdown=1.3,
		pixelcolorup=0x3d2e33, pixelalphaup=0.2, pixelalphadown=0.5,
		text=key, ttf=font02, textcolorup=0x0009B3, textcolordown=0x45d1ff,
		channel=self.channelS, sound=self.sound, volume=self.volume,
		fun=self.remapKey,
	}, 1)
	if (keyNames[g_keyright] or 0) == 0 then key = utf8.char(g_keyright) keycode = g_keyright
	else key = keyNames[g_keyright] keycode = g_keyright
	end
	self.btnRIGHT = ButtonMonster.new({
		btnscalexup=1.3, btnscalexdown=1.3,
		pixelcolorup=0x3d2e33, pixelalphaup=0.2, pixelalphadown=0.5,
		text=key, ttf=font02, textcolorup=0x0009B3, textcolordown=0x45d1ff,
		channel=self.channelS, sound=self.sound, volume=self.volume,
		fun=self.remapKey,
	}, 2)
	if (keyNames[g_keyup] or 0) == 0 then key = utf8.char(g_keyup) keycode = g_keyup
	else key = keyNames[g_keyup] keycode = g_keyup
	end
	self.btnUP = ButtonMonster.new({
		btnscalexup=1.3, btnscalexdown=1.3,
		pixelcolorup=0x3d2e33, pixelalphaup=0.2, pixelalphadown=0.5,
		text=key, ttf=font02, textcolorup=0x0009B3, textcolordown=0x45d1ff,
		channel=self.channelS, sound=self.sound, volume=self.volume,
		fun=self.remapKey,
	}, 3)
	if (keyNames[g_keydown] or 0) == 0 then key = utf8.char(g_keydown) keycode = g_keydown
	else key = keyNames[g_keydown] keycode = g_keydown
	end
	self.btnDOWN = ButtonMonster.new({
		btnscalexup=1.3, btnscalexdown=1.3,
		pixelcolorup=0x3d2e33, pixelalphaup=0.2, pixelalphadown=0.5,
		text=key, ttf=font02, textcolorup=0x0009B3, textcolordown=0x45d1ff,
		channel=self.channelS, sound=self.sound, volume=self.volume,
		fun=self.remapKey,
	}, 4)
	if (keyNames[g_keyaction1] or 0) == 0 then key = utf8.char(g_keyaction1) keycode = g_keyaction1
	else key = keyNames[g_keyaction1] keycode = g_keyaction1
	end
	self.btnSHOOT = ButtonMonster.new({
		btnscalexup=1.3, btnscalexdown=1.3,
		pixelcolorup=0x3d2e33, pixelalphaup=0.2, pixelalphadown=0.5,
		text=key, ttf=font02, textcolorup=0x0009B3, textcolordown=0x45d1ff,
		channel=self.channelS, sound=self.sound, volume=self.volume,
		fun=self.remapKey,
	}, 5)
	-- btn show/hide mobile controls
	self.btn04 = ButtonMonster.new({
		btnscalexup=1.3, btnscalexdown=1.5,
		pixelcolorup=0x3d2e33, pixelalphaup=0.2, pixelalphadown=0.5,
		text="MOBILE", ttf=font02, textcolorup=0x0009B3, textcolordown=0x45d1ff,
		channel=self.channelS, sound=self.sound, volume=self.volume,
	}, 6)
	-- btn menu
	self.btn03 = ButtonMonster.new({
		btnscalexup=1.3, btnscalexdown=1.5,
		pixelcolorup=0x3d2e33, pixelalphaup=0.2, pixelalphadown=0.5,
		text="MENU", ttf=font02, textcolorup=0x0009B3, textcolordown=0x45d1ff,
		channel=self.channelS, sound=self.sound, volume=self.volume,
	}, 7)
	-- positions
	self.mytitle:setPosition(myappwidth/2, 0.75*myappheight/10)
	volumeslider:setPosition(64, 3.5 * myappheight / 10)
	self.difficultyslider:setPosition(64, 5.5 * myappheight / 10)
	self.btnLEFT:setPosition(6.5 * myappwidth / 10, 6 * myappheight / 10)
	self.btnRIGHT:setPosition(8.5 * myappwidth / 10, 6 * myappheight / 10)
	self.btnUP:setPosition(7.3 * myappwidth / 10, 4.6 * myappheight / 10)
	self.btnDOWN:setPosition(7.5 * myappwidth / 10, 7.4 * myappheight / 10)
	self.btnSHOOT:setPosition(4.5 * myappwidth / 10, 7.4 * myappheight / 10)
	self.btn04:setPosition(self.btn04:getWidth() + 48, myappheight - self.btn04:getHeight())
	self.btn03:setPosition(myappwidth - self.btn03:getWidth()/2, myappheight - self.btn03:getHeight()/2)
	-- order
	self:addChild(bg)
	self:addChild(self.mytitle)
	self:addChild(volumeslider)
	self:addChild(self.difficultyslider)
	self:addChild(self.btnLEFT)
	self:addChild(self.btnRIGHT)
	self:addChild(self.btnUP)
	self:addChild(self.btnDOWN)
	self:addChild(self.btnSHOOT)
	self:addChild(self.btn04)
	self:addChild(self.btn03)
	-- btns table
	self.btns = {}
	self.btns[#self.btns + 1] = self.btnLEFT
	self.btns[#self.btns + 1] = self.btnRIGHT
	self.btns[#self.btns + 1] = self.btnUP
	self.btns[#self.btns + 1] = self.btnDOWN
	self.btns[#self.btns + 1] = self.btnSHOOT
	self.btns[#self.btns + 1] = self.btn04
	self.btns[#self.btns + 1] = self.btn03
	-- btns listeners
	for k, v in ipairs(self.btns) do
		v:addEventListener("clicked", function() self:goto() end) -- click event
		v.btns = self.btns -- ui navigation update
	end
	-- let's go!
	self:difficulty(g_difficulty)
	self:updateUiVfx()
	-- LISTENERS
	volumeslider:addEventListener("value_changing", self.onValueChanging, self)
	volumeslider:addEventListener("value_changed", self.onValueChanged, self)
	self.difficultyslider:addEventListener("value_changing", self.onValueChanging, self)
	self.difficultyslider:addEventListener("value_changed", self.onValueChanged, self)
	self:addEventListener("enterBegin", self.onTransitionInBegin, self)
	self:addEventListener("enterEnd", self.onTransitionInEnd, self)
	self:addEventListener("exitBegin", self.onTransitionOutBegin, self)
	self:addEventListener("exitEnd", self.onTransitionOutEnd, self)
end

-- game loop
local timer = 0
function Options:onEnterFrame(e)
end

-- listeners
function Options:onValueChanging(e)
	if e.id == 1 then
		g_sfxvolume = e.value
		self.audio:setBgmVolume()
		self.channelS:setVolume(g_sfxvolume*0.01)
		for _, v in pairs(self.btns) do v:setVolume(g_sfxvolume*0.01) end
	elseif e.id == 2 then self:difficulty(e.value)
	end
end

function Options:onValueChanged(e)
	if e.id == 1 then
		g_sfxvolume = e.value
		self.audio:setBgmVolume()
		self.channelS:setVolume(g_sfxvolume*0.01)
		for _, v in pairs(self.btns) do v:setVolume(g_sfxvolume*0.01) end
	elseif e.id == 2 then g_difficulty = e.value self:difficulty(e.value)
	end
	mySavePrefs(g_configfilepath)
end

-- functions
function Options:difficulty(x)
	if x >= 2 then self.difficultyslider.textfield:setText("HARD")
	elseif x >= 1 then self.difficultyslider.textfield:setText("MEDIUM")
	else self.difficultyslider.textfield:setText("EASY")
	end
end

function Options:onTransitionInBegin() self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self) end
function Options:onTransitionInEnd() self:myKeysPressed() end
function Options:onTransitionOutBegin() self.audio:mute("bgm") self:removeAllListeners() end
function Options:onTransitionOutEnd() end

-- KEYS HANDLER
function Options:myKeysPressed()
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
function Options:updateUiVfx()
	for k, v in ipairs(self.btns) do v.iskeyboard = true v:updateVisualState() end
end
function Options:updateUiSfx()
	for k, v in ipairs(self.btns) do
		if k == self.selector then self.channelS = self.sound:play() self.channelS:setVolume(self.volume) end
	end
end

-- scenes ui keyboard navigation
function Options:goto()
	local key
	local textInputDialog
	for k, v in ipairs(self.btns) do
		if k == self.selector then
			if v.isdisabled then print("btn disabled!", k)
			elseif k == 6 then g_show_mobile = not g_show_mobile
			elseif k == 7 then self:back()
			else print("nothing here!", k)
			end
		end
	end
end

function Options:onKeyDown(ev)
	local key, keycode
	if (keyNames[ev.keyCode] or 0) == 0 then key = utf8.char(ev.keyCode)
	else key = keyNames[ev.keyCode]
	end
	keycode = ev.keyCode
	-- check
	local keys = {left=g_keyleft, right=g_keyright, up=g_keyup, down=g_keydown, shoot=g_keyaction1}
	local function isDouble(kc)
		local double = false
		for k, v in pairs(keys) do if v == kc then double = true end end
		return double
	end
	if self.selector == 1 then if not isDouble(keycode) then self.btnLEFT:setText(key) g_keyleft = keycode end
	elseif self.selector == 2 then if not isDouble(keycode) then self.btnRIGHT:setText(key) g_keyright = keycode end
	elseif self.selector == 3 then if not isDouble(keycode) then self.btnUP:setText(key) g_keyup = keycode end
	elseif self.selector == 4 then if not isDouble(keycode) then self.btnDOWN:setText(key) g_keydown = keycode end
	elseif self.selector == 5 then if not isDouble(keycode) then self.btnSHOOT:setText(key) g_keyaction1 = keycode end
	end
	mySavePrefs(g_configfilepath)
	self:remapKey()
end

function Options:remapKey()
	self.isselected = not self.isselected
	local btn
	if self.isselected then
		if self.selector == 1 then btn = self.btnLEFT
		elseif self.selector == 2 then btn = self.btnRIGHT
		elseif self.selector == 3 then btn = self.btnUP
		elseif self.selector == 4 then btn = self.btnDOWN
		elseif self.selector == 5 then btn = self.btnSHOOT
		end
		btn:setColorTransform(0/255, 255/255, 0/255, 255/255)
		btn:addEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	else
		if self.selector == 1 then btn = self.btnLEFT
		elseif self.selector == 2 then btn = self.btnRIGHT
		elseif self.selector == 3 then btn = self.btnUP
		elseif self.selector == 4 then btn = self.btnDOWN
		elseif self.selector == 5 then btn = self.btnSHOOT
		end
		btn:setColorTransform(255/255, 255/255, 255/255, 255/255)
		btn:removeEventListener(Event.KEY_DOWN, self.onKeyDown, self)
	end
end

function Options:back() scenemanager:changeScene("menu", 1, transitions[1], easings[2]) end
