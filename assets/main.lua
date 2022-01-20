-- global prefs functions
function myLoadPrefs(xconfigfilepath)
	local mydata = getData(xconfigfilepath) -- try to read information from file
	if not mydata then -- if no prefs file, create it
		mydata = {}
		-- set prefs
		mydata.g_language = g_language
		mydata.g_difficulty = g_difficulty
		mydata.g_level = g_level
		mydata.g_sfxvolume = g_sfxvolume
		
		mydata.g_keyleft = g_keyleft
		mydata.g_keyright = g_keyright
		mydata.g_keyup = g_keyup
		mydata.g_keydown = g_keydown
		mydata.g_keyaction1 = g_keyaction1

		mydata.g_show_mobile = g_show_mobile

		-- save prefs
		saveData(xconfigfilepath, mydata) -- create file and save datas
	else -- prefs file exists, use it!
		-- set prefs
		g_language = mydata.g_language
		g_difficulty = mydata.g_difficulty
		g_level = mydata.g_level
		g_sfxvolume = mydata.g_sfxvolume

		g_keyleft = mydata.g_keyleft
		g_keyright = mydata.g_keyright
		g_keyup = mydata.g_keyup
		g_keydown = mydata.g_keydown
		g_keyaction1 = mydata.g_keyaction1

		g_show_mobile = mydata.g_show_mobile
	end
end
function mySavePrefs(xconfigfilepath)
	local mydata = {} -- clear the table
	-- set prefs
	mydata.g_language = g_language
	mydata.g_difficulty = g_difficulty
	mydata.g_level = g_level
	mydata.g_sfxvolume = g_sfxvolume

	mydata.g_keyleft = g_keyleft
	mydata.g_keyright = g_keyright
	mydata.g_keyup = g_keyup
	mydata.g_keydown = g_keydown
	mydata.g_keyaction1 = g_keyaction1

	mydata.g_show_mobile = g_show_mobile

	-- save prefs
	saveData(xconfigfilepath, mydata) -- save new data
end
-- tiled levels
tiled_levels = {}
tiled_levels[1] = loadfile("tiled/levels/forest01.lua")()
--tiled_levels[2] = loadfile("tiled/levels/mountain_village.lua")()
tiled_levels[2] = loadfile("tiled/levels/abstract05.lua")()
tiled_levels[3] = loadfile("tiled/levels/land.lua")()
g_currentlevel = 1
-- global prefs
g_configfilepath = "|D|GDOC_03_B2D_PLATFORMER.txt"
g_language = application:getLanguage()
g_level = g_currentlevel
g_difficulty = 1
g_sfxvolume = 10
g_keyleft = KeyCode.LEFT
g_keyright = KeyCode.RIGHT
g_keyup = KeyCode.UP
g_keydown = KeyCode.DOWN
g_keyaction1 = KeyCode.SPACE
g_show_mobile = true
-- let's load initial prefs
myLoadPrefs(g_configfilepath) -- load prefs
-- control the garbage collector rate
collectgarbage("setstepmul", 8000*2) -- 1000
collectgarbage()
-- scene manager
scenemanager = SceneManager.new{
	["menu"] = Menu,
	["options"] = Options,
	["level_select"] = Level_Select,
	["levelX"] = LevelX,
}
scenemanager:changeScene("levelX")
stage:addChild(scenemanager)
-- scenemanager transitions and easings tables
transitions = {
	SceneManager.moveFromRight, -- 1
	SceneManager.moveFromLeft, -- 2
	SceneManager.moveFromBottom, -- 3
	SceneManager.moveFromTop, -- 4
	SceneManager.moveFromRightWithFade, -- 5
	SceneManager.moveFromLeftWithFade, -- 6
	SceneManager.moveFromBottomWithFade, -- 7
	SceneManager.moveFromTopWithFade, -- 8
	SceneManager.overFromRight, -- 9
	SceneManager.overFromLeft, -- 10
	SceneManager.overFromBottom, -- 11
	SceneManager.overFromTop, -- 12
	SceneManager.overFromRightWithFade, -- 13
	SceneManager.overFromLeftWithFade, -- 14
	SceneManager.overFromBottomWithFade, -- 15
	SceneManager.overFromTopWithFade, -- 16
	SceneManager.fade, -- 17
	SceneManager.crossFade, -- 18
	SceneManager.flip, -- 19
	SceneManager.flipWithFade, -- 20
	SceneManager.flipWithShade, -- 21
}
easings = {
	easing.inBack, -- 1
	easing.outBack, -- 2
	easing.inOutBack, -- 3
	easing.inBounce, -- 4
	easing.outBounce, -- 5
	easing.inOutBounce, -- 6
	easing.inCircular, -- 7
	easing.outCircular, -- 8
	easing.inOutCircular, -- 9
	easing.inCubic, -- 10
	easing.outCubic, -- 11
	easing.inOutCubic, -- 12
	easing.inElastic, -- 13
	easing.outElastic, -- 14
	easing.inOutElastic, -- 15
	easing.inExponential, -- 16
	easing.outExponential, -- 17
	easing.inOutExponential, -- 18
	easing.linear, -- 19
	easing.inQuadratic, -- 20
	easing.outQuadratic, -- 21
	easing.inOutQuadratic, -- 22
	easing.inQuartic, -- 23
	easing.outQuartic, -- 24
	easing.inOutQuartic, -- 25
	easing.inQuintic, -- 26
	easing.outQuintic, -- 27
	easing.inOutQuintic, -- 28
	easing.inSine, -- 29
	easing.outSine, -- 30
	easing.inOutSine, -- 31
}
