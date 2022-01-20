Audio = Core.class()
 
function Audio:init()
	self.bgmChannel = nil
	self.bgmCurrentName = nil
	self.bgmCurrent = nil
	self.bgmPos = 0
	self.bgmMute = false
	self.sfxMute = false
end
 
function Audio:playBgm(name, ratio, force)
	if name ~= self.bgmCurrentName or force then
		if self.bgmChannel then
			self.bgmChannel:stop()
			self.bgmChannel = nil
			self.bgmCurrentName = nil
			self.bgmCurrent = nil
			self.bgmPos = 0
		end
		if not self.bgmMute and not self.bgmChannel then
			self.bgmCurrentName = name
			self.bgmCurrent = Sound.new(name)
			self.bgmChannel = self.bgmCurrent:play(self.bgmPos, true)
			self:setBgmVolume(ratio)
		end
	end
end
function Audio:playSfx(name) if not self.sfxMute then return self.sfxs:play() end end
 
function Audio:setBgmVolume(xratio)
	self.bgmChannel:setVolume(g_sfxvolume*0.01*(xratio or 1))
--	print(g_sfxvolume*0.01*(xratio or 1))
end

function Audio:mute(mode)
	if mode == "bgm" then
		self.bgmMute = true
		if self.bgmChannel then
			self.bgmPos = self.bgmChannel:getPosition()
			self.bgmChannel:stop()
			self.bgmChannel = nil
		end
	elseif mode == "sfx" then
		self.sfxMute = true
	else
		self.bgmMute = true
		if self.bgmChannel then
			self.bgmPos = self.bgmChannel:getPosition()
			self.bgmChannel:stop()
			self.bgmChannel = nil
		end
		self.sfxMute = true
	end
end
function Audio:unmute(mode)
	if mode == "bgm" then
		self.bgmMute = false
		self.bgmChannel = self.bgmCurrent:play(self.bgmPos, math.huge)
	elseif mode == "sfx" then
		self.sfxMute = false
	else
		self.bgmMute = false
		self.bgmChannel = self.bgmCurrent:play(self.bgmPos, math.huge)
		self.sfxMute = false
	end
end
