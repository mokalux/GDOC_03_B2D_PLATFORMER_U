-- plugins
require "scenemanager"
require "easing"
require "liquidfun"

-- global app size
myappleft, myapptop, myappright, myappbot = application:getLogicalBounds()
myappwidth, myappheight = myappright - myappleft, myappbot - myapptop
print(myappleft, myapptop, myappright, myappbot)
print(myappwidth, myappheight)

-- app setup
if application:getDeviceInfo() == "Windows" and not application:isPlayerMode() then
--if application:getDeviceInfo() == "Windows" then -- for testing before release
	application:set("windowTitle", "My lovely window title")
	application:set("windowPosition", 0.25 * myappwidth, 96)
	application:set("windowColor", 0/255, 0/255, 0/255)
end
-- global functions
isfullscreen = false
function setFullScreen(xbool) application:setFullScreen(xbool) end
-- global fonts (see also composite font)
font00 = TTFont.new("fonts/Cabin-Regular-TTF.ttf", (12*10)//1)
font01 = TTFont.new("fonts/Cabin-Regular-TTF.ttf", (12*5.2)//1)
font02 = TTFont.new("fonts/Cabin-Regular-TTF.ttf", (12*4)//1)
font10 = TTFont.new("fonts/Cabin-Regular-TTF.ttf", (12*3)//1)

-- LIQUIDFUN: here we store all possible contact TYPE -- NO LIMIT :-)
G_GROUND = 2^0
G_WALL = 2^1
G_MVPLATFORM = 2^2
G_MVPTPLATFORM = 2^3
G_PTPLATFORM = 2^4
G_PLAYER = 2^5
G_PLAYER_BULLET = 2^6
G_ENEMY = 2^7
G_ENEMY_BULLET = 2^8
G_FRIENDLY = 2^9
G_EXIT = 2^10
G_DANGER = 2^11
G_LADDER = 2^12
G_COLLECTIBLE = 2^13
G_BUMP = 2^14
G_MOVEABLE = 2^15
G_WATER = 2^16
-- LIQUIDFUN: here we define some category BITS (that is those objects can collide) -- 2^15 = MAX
G_BITSOLID = 2^0
G_BITPTPF = 2^1 -- need it because not all fixtures collide with ptpf
G_BITPLAYER = 2^2
G_BITPLAYERBULLET = 2^3
G_BITENEMY = 2^4
G_BITENEMYBULLET = 2^5
G_BITFRIENDLY = 2^6
G_BITSENSOR = 2^7
G_BITMOVEABLE = 2^8
-- and their appropriate masks (that is what can collide with what)
--solidcollisions = G_BITPLAYER + G_BITPLAYERBULLET + G_BITENEMY + G_BITENEMYBULLET + G_BITFRIENDLY + G_BITMOVEABLE
--solidcollisions = G_BITPLAYER + G_BITENEMY + G_BITFRIENDLY + G_BITMOVEABLE
solidcollisions = G_BITSOLID + G_BITPLAYER + G_BITENEMY + G_BITFRIENDLY + G_BITMOVEABLE
--playercollisions = G_BITSOLID + G_BITPTPF + G_BITENEMY + G_BITENEMYBULLET + G_BITSENSOR + G_BITMOVEABLE
playercollisions = G_BITSOLID + G_BITPTPF + G_BITENEMY + G_BITENEMYBULLET + G_BITSENSOR + G_BITMOVEABLE
--playercollisions = G_BITSOLID + G_BITENEMY + G_BITENEMYBULLET + G_BITSENSOR + G_BITMOVEABLE
--playerbulletcollisions = G_BITSOLID + G_BITENEMY + G_BITENEMYBULLET + G_BITFRIENDLY
playerbulletcollisions = G_BITENEMY + G_BITENEMYBULLET + G_BITFRIENDLY
nmecollisions = G_BITSOLID + G_BITPTPF + G_BITPLAYER + G_BITPLAYERBULLET + G_BITENEMY
nmecollisions2 = G_BITSOLID + G_BITPTPF + G_BITPLAYER + G_BITPLAYERBULLET + G_BITENEMY + G_BITSENSOR
--nmebulletcollisions = G_BITSOLID + G_BITPLAYER + G_BITPLAYERBULLET
nmebulletcollisions = G_BITPLAYER + G_BITPLAYERBULLET
friendlycollisions = G_BITSOLID + G_BITPTPF + G_BITPLAYERBULLET
moveablecollisions = G_BITSOLID + G_BITPTPF + G_BITPLAYER + G_BITMOVEABLE
