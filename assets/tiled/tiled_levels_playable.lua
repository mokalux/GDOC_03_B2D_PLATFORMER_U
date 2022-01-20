function Tiled_Levels_Playable(xworld, xobject, xlayer)
	-- player 1
	-- *************
	if xobject.name == "player1" then
		xworld.player1 = Player.new(xworld, {
			posx=xobject.x, posy=xobject.y,
			textures={
				{path="gfx/playable/y_bot_idle.png", numcols=10, numrows=10,}, -- 100
				{path="gfx/playable/y_bot_running.png", numcols=4, numrows=2,}, -- 8
				{path="gfx/playable/y_bot_jump4.png", numcols=2, numrows=1,}, -- 2
				{path="gfx/playable/y_bot_climb_up.png", numcols=5, numrows=2,}, -- 10
				{path="gfx/playable/y_bot_climb_down.png", numcols=5, numrows=2,}, -- 10
			},
			scale=0.4,
--			animspeed=24, movespeed=8*96, jumpspeed=8*280, maxnumjump=2,
			animspeed=14, movespeed=8*84, jumpspeed=8*126, maxnumjump=2, -- 100
			offsety=-14, shapescale=4,
			density=1, restitution=0, friction=0.1, -- 0.1 looks good, friction=0 otherwise sticks on walls and small shapes XXX
			BIT=G_BITPLAYER, COLBIT=playercollisions, ROLE=G_PLAYER,
			lives=3, nrg=5,
		})
		xlayer:addChild(xworld.player1)
	end

	-- LEVEL 1
	-- *************
	if g_currentlevel == 1 then -- LEVEL 1
		if xobject.name == "walkerA" then -- LEVEL 1
			Nmes.new(xworld, {
				posx=xobject.x, posy=xobject.y,
				textures={
					{path="gfx/playable/dance_5x5.png", numcols=5, numrows=5,},
				},
				scale=0.7,
				alpha=1.5,
				animspeed=14, movespeed=8*32, jumpspeed=8*0.7, maxnumjump=2,
				offsety=-16, shapescale=6,
				density=1, restitution=0.5, friction=0.1,
				BIT=G_BITENEMY, COLBIT=nmecollisions, ROLE=G_ENEMY,
				name=xobject.name, lives=1, nrg=4,
				points=10, ability="walk",
			})

		elseif xobject.name == "walkerBossA" then -- LEVEL 1
			Nmes.new(xworld, {
				posx=xobject.x, posy=xobject.y,
				textures={
					{path="gfx/playable/slime01.png", numcols=8, numrows=2,},
				},
				scale=1.2,
				animspeed=14, movespeed=8*0.2, jumpspeed=8*0.2, maxnumjump=1,
				offsetx=-0, offsety=-0, shapescale=3,
				density=1, restitution=0.5, friction=0.1,
				BIT=G_BITENEMY, COLBIT=nmecollisions, ROLE=G_ENEMY,
				name=xobject.name, lives=2, nrg=4,
				points=100, ability="walk",
				dokeep=true,
			})

		elseif xobject.name == "flyerA" then -- LEVEL 1
			Nmes.new(xworld, {
				posx=xobject.x, posy=xobject.y,
				textures={
					{path="gfx/playable/bat_fly.png", numcols=1, numrows=9,},
				},
				scale=0.5,
				animspeed=14, movespeed=8*64, jumpspeed=8*0.5, maxnumjump=2,
				offsety=0, shapescale=4,
				density=1, restitution=0.5, friction=0,
				BIT=G_BITENEMY, COLBIT=nmecollisions, ROLE=G_ENEMY,
				name=xobject.name, lives=1, nrg=2,
				points=20, ability="fly",
			})

		elseif xobject.name == "flyerKeepA" then -- LEVEL 1
			Nmes.new(xworld, {
				posx=xobject.x, posy=xobject.y,
				textures={
					{path="gfx/playable/bat_fly.png", numcols=1, numrows=9,},
				},
				scale=0.5,
				animspeed=14, movespeed=8*0.5, jumpspeed=8*0.5, maxnumjump=2,
				offsety=0, shapescale=4.5,
				density=1, restitution=0.5, friction=0,
				BIT=G_BITENEMY, COLBIT=nmecollisions, ROLE=G_ENEMY,
				name=xobject.name, lives=1, nrg=2,
				points=40, ability="fly",
				dokeep=true,
			})
		end
	end
	-- LEVEL 2
	-- *************
	if g_currentlevel == 2 then
		if xobject.name == "walkerA" then -- LEVEL 2
			Nmes.new(xworld, {
				posx=xobject.x, posy=xobject.y,
				textures={
					{path="gfx/playable/low_spec_triceratops_idle.png", numcols=3, numrows=5,},
					{path="gfx/playable/low_spec_triceratops_walk.png", numcols=3, numrows=4,},
				},
				scale=0.5,
				alpha=1.5,
				animspeed=14, movespeed=8*32, jumpspeed=8*280, maxnumjump=1,
				offsety=-1, shapescale=6,
				density=1, restitution=0.2, friction=0.1,
				BIT=G_BITENEMY, COLBIT=nmecollisions, ROLE=G_ENEMY,
				name=xobject.name, lives=2, nrg=5,
				points=200, ability="walk",
			})

		elseif xobject.name == "walkerBossA" then -- LEVEL 2
			Nmes.new(xworld, {
				posx=xobject.x, posy=xobject.y,
				textures={
					{path="gfx/playable/escarabajo_idle.png", numcols=5, numrows=3,},
					{path="gfx/playable/escarabajo_walk.png", numcols=5, numrows=4,},
				},
				scale=0.7,
				animspeed=14, movespeed=8*28, jumpspeed=8*280, maxnumjump=1,
				offsetx=0, offsety=-34, shapescale=4,
				density=1, restitution=0.2, friction=0.1,
				BIT=G_BITENEMY, COLBIT=nmecollisions, ROLE=G_ENEMY,
				name=xobject.name, lives=3, nrg=5,
				points=1000, ability="walk",
				dokeep=true,
			})

		elseif xobject.name == "flyerA" then -- LEVEL 2
			Nmes.new(xworld, {
				posx=xobject.x, posy=xobject.y,
				textures={
					{path="gfx/playable/low_spec_pterosaur_oga_flyB_bright.png", numcols=6, numrows=2,}
				},
				scale=0.5,
				animspeed=18, movespeed=8*32, jumpspeed=8*100, maxnumjump=1000,
				offsety=8, shapescale=5,
				density=1, restitution=0.5, friction=0,
				BIT=G_BITENEMY, COLBIT=nmecollisions, ROLE=G_ENEMY,
				name=xobject.name, lives=1, nrg=3,
				points=50, ability="fly",
			})

		elseif xobject.name == "flyerKeepA" then -- LEVEL 2
			Nmes.new(xworld, {
				posx=xobject.x, posy=xobject.y,
				textures={
					{path="gfx/playable/low_spec_pterosaur_oga_flyA_bright.png", numcols=6, numrows=2,},
					{path="gfx/playable/low_spec_pterosaur_oga_die.png", numcols=6, numrows=2,},
				},
				scale=0.75,
				animspeed=14, movespeed=8*32, jumpspeed=8*128, maxnumjump=1000,
				offsety=22, shapescale=4.5,
				density=1, restitution=0.5, friction=0,
				BIT=G_BITENEMY, COLBIT=nmecollisions, ROLE=G_ENEMY,
				name=xobject.name, lives=2, nrg=4,
				dokeep=true,
				points=100, ability="fly",
			})

		end
	end
end
