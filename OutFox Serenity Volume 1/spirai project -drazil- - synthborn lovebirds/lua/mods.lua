collectgarbage()

xero()

if GAMESTATE:GetNumPlayersEnabled() > 1 then
	local difflist = {
		'Hard',
		'Challenge',
	}

	local steps = nil

	local plrsteps = {
		GAMESTATE:GetCurrentSteps(PlayerNumber[1]),
		GAMESTATE:GetCurrentSteps(PlayerNumber[2])
	}

	while steps == nil do
		if plrsteps[1] and plrsteps[1]:GetDifficulty() == 'Difficulty_Hard' then
			steps = plrsteps[1]
		elseif plrsteps[2] and plrsteps[2]:GetDifficulty() == 'Difficulty_Hard' then
			steps = plrsteps[2]
		elseif plrsteps[1] then
			steps = plrsteps[1]
		elseif plrsteps[2] then
			steps = plrsteps[2]
		end
	end

	if plrsteps[1] ~= plrsteps[2] then
		for pn = 1, 2 do
			GAMESTATE:SetCurrentSteps(PlayerNumber[pn], steps)
		end
		SCREENMAN:GetTopScreen():SetNextScreenName('ScreenStageInformation'):PostScreenMessage('SM_GoToNextScreen', 0)
	end
end

local actors = Def.ActorFrame {}
if FUCK_EXE then
	actors = actors .. {
		Def.ActorProxy { Name = 'PP[1]' },
		Def.ActorProxy { Name = 'PP[2]' },
		Def.ActorProxy { Name = 'PJ[1]' },
		Def.ActorProxy { Name = 'PJ[2]' },
		Def.ActorProxy { Name = 'PC[1]' },
		Def.ActorProxy { Name = 'PC[2]' },
		Def.Sprite { Name = 'draz_sprite'},
		Def.ActorFrameTexture { Name = 'draz_aft' },
	}
else
	--	Correct AFT recursion in Outfox meets the following criteria:
	--		1. One normal AFT contains all affected actors and one sprite.
	--		2. One recursive AFT contains one sprite.
	--		3. The sprites for each AFT get the texture of the other.
	--		4. There is a sprite between each AFT that gets the texture of the
	--		   non-recursive AFT.
	--		5. All tweens and alpha diffuses are done on the non-recursive sprite.
	actors = actors .. {
		Def.ActorFrameTexture { 
			Name = 'draz_aft',
			Def.Sprite {
				Name = 'draz_bg',
				Texture = '../synthborn-bg.png',
				InitCommand = function(self)
					self:Center()
				end,
			},
			Def.ActorProxy { Name = 'PP[1]' },
			Def.ActorProxy { Name = 'PP[2]' },
			Def.ActorProxy { Name = 'PJ[1]' },
			Def.ActorProxy { Name = 'PJ[2]' },
			Def.ActorProxy { Name = 'PC[1]' },
			Def.ActorProxy { Name = 'PC[2]' },
			Def.Sprite { Name = 'draz_sprite'},
		},
		Def.ActorFrameTexture { 
			Name = 'draz_aftR',
			Def.Sprite { Name = 'draz_spriteR'},
		},
		Def.Sprite { Name = 'lmfao_sprite' },
	}
end

return Def.ActorFrame {
    LoadCommand = function(self)
        -- judgment / combo proxies
        for pn = 1, 2 do
		 if P[pn] then
				setupJudgeProxy(PJ[pn], P[pn]:GetChild('Judgment'), pn)
				setupJudgeProxy(PC[pn], P[pn]:GetChild('Combo'), pn)
         end			
        end
        -- player proxies
        for pn = 1, #PP do
		 if P[pn] then
			PP[pn]:SetTarget(P[pn])
			P[pn]:hidden(1)
		end
        end
		
		sprite(draz_sprite) -- set up the sprite
		aft(draz_aft) -- set up the aft
		sprite(draz_spriteR) -- set up the sprite
		aftrecursive(draz_aftR) -- set up the aft
		sprite(lmfao_sprite)
		aftsprite(draz_aft,draz_spriteR)
		aftsprite(draz_aftR,draz_sprite)
		aftsprite(draz_aft,lmfao_sprite)
		
		

        -- funy arow wigles go here
		set {0,3,'xmod'}
		set {0,400,'arrowpathgirth'}
		func {0, function()
			if P1 then 
				P1:x(SCREEN_CENTER_X)
			end
			if P2 then
				P2:x(SCREEN_CENTER_X)
			end
		end}
		
		local curcol = 0
		
		for i = 0,13.75,0.25 do
			set {i,100,'arrowpath'..curcol}
			ease {i,1,outQuad,0,'arrowpath'..curcol}
			if curcol < 3 then
				curcol = curcol+1
			else
				curcol = 0
			end
		end
		
		set {0,100,'centered'}
		
		if FUCK_EXE then
		  set
		  {0, 100, 'stealthglowred'}
		  {0, (165/255) * 100, 'stealthglowgreen'}
		else
		  set
		  {0, (165/255) * 100, 'stealthglowgreen'}
		  {0, 100, 'stealthglowred'}
		  {0, 0, 'stealthglowblue'}
		end
		--set {0,360*2,'rotationz', plr = 1}
		--set {0,-360*2,'rotationz', plr = 2}
		set {0,100,'dark'}
		set {0,-100,'cover'}
		--set {0,100,'dizzy'}
		set {0,-200,'mini'}
		set {0,-628,'confusionzoffset',plr = 1}
		set {0,628,'confusionzoffset',plr = 2}
		--set {0,-200,'tantipsy'}
		set {0,300,'drunk',plr = 1}
		set {0,-300,'tipsy',plr = 1}
		set {0,-300,'drunk',plr = 2}
		set {0,300,'tipsy',plr = 2}
		--set {0,-628*2,'confusionzoffset', plr = 1}
		--set {0,628*2,'confusionzoffset', plr = 2}
		--ease {0,14,outSine,0,'confusionzoffset'}
		--ease {0,14,outSine,0,'rotationz'}
		ease {0,14,outSine,0,'drunk'}
		ease {0,14,outSine,0,'tipsy'}
		ease {0,14,outSine,0,'mini'}
		ease {0,14,outSine,0,'confusionzoffset'}
		--ease {0,14,outSine,0,'tantipsy'}
		ease {0.5,13.5,outSine,0,'dark'}
		func {0, 14, outSine, SCREEN_CENTER_X, SCREEN_CENTER_X*0.5, function(p)
			if P1 then 
				P1:x(p)
			end
		end}
		func {0, 14, outSine, SCREEN_CENTER_X, SCREEN_CENTER_X*1.5, function(p)
			if P2 then
			    P2:x(p)
			end
		end}
		ease {0,14,outSine,0,'centered'}
		
		local mult = 1
		
		for i = 14,15.75,0.25 do
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,0.25,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			mult = -mult
		end
		ease {16,1,outSine,0,'drunk'}
		ease {16,1,outSine,0,'tipsy'}
		
		local funnyflashes = {16,22.5,23.5,24,32,38.5,39.5,40,48,54.5,55.5,56,64,70.5,71.5,72,112,118.5,119.5,120,128,134.5,135.5,136,144,150.5,151.5,152,160,166.5,167.5,168,176,182.5,183.5,184,192,198.5,199.5,200}
		
		for i = 1,table.getn(funnyflashes) do
			local beat = funnyflashes[i]
			local aftmult = 1
			if not FUCK_EXE then aftmult = 0.9 end
			func {beat, 4, outSine, 0.85, 0, function(p)
				draz_sprite:diffusealpha(p * aftmult)
			end}
			func {beat, 4, outSine, 1.05, 1, function(p)
				draz_sprite:zoom(p)
			end}
			
			
			ease {beat,0,outSine,50,'stealth'}
			ease {beat,2,outSine,0,'stealth'}
		end
		
		func {0, function()
			draz_sprite:diffusealpha(0)
		end}
		
		for i = 16,47,1 do
			--ease {i,0.25,outQuad,50*mult,'drunk'}
			--ease {i,0.25,outQuad,50*mult,'tipsy'}
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,1,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			mult = -mult
		end
		
		for i = 47,48,0.25 do
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,1,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			mult = -mult
		end
		
		func {47, 1, outQuad, SCREEN_CENTER_X*0.5, SCREEN_CENTER_X, function(p)
			if P1 then 
			P1:x(p)
			end
		end}
		func {47, 1, outQuad, SCREEN_CENTER_X*1.5, SCREEN_CENTER_X, function(p)
			if P2 then 
			P2:x(p)
			end
		end}
		
		func {48, 8, bounce, SCREEN_CENTER_X, SCREEN_CENTER_X*0.5, function(p)
			if P1 then 
			P1:x(p)
			end
		end}
		func {48, 8, bounce, SCREEN_CENTER_X, SCREEN_CENTER_X*0.5, function(p)
			if P2 then 
			P2:x(p)
			end
		end}
		
		ease {48,8,bounce,-30,'rotationy'}
		ease {56,8,bounce,30,'rotationy'}
		--ease {63,1,bounce,-30,'rotationy'}
		ease {64,8,bounce,-30,'rotationy'}
		ease {72,8,bounce,30,'rotationy'}
		
		func {56, 8, bounce, SCREEN_CENTER_X, SCREEN_CENTER_X*1.5, function(p)
			if P1 then 
			P1:x(p)
			end
		end}
		
		func {56, 8, bounce, SCREEN_CENTER_X, SCREEN_CENTER_X*1.5, function(p)
			if P2 then 
			P2:x(p)
			end
		end}
		
		for i = 48,63,1 do
			--ease {i,0.25,outQuad,50*mult,'drunk'}
			--ease {i,0.25,outQuad,50*mult,'tipsy'}
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,1,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			mult = -mult
		end
		
		for i = 64,79,1 do
			--ease {i,0.25,outQuad,50*mult,'drunk'}
			--ease {i,0.25,outQuad,50*mult,'tipsy'}
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,1,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			mult = -mult
		end
		
		for i = 63,64,0.25 do
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,1,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			mult = -mult
		end
		
		ease {63,1,outQuad,99,'reverse'}
		
		--[[func {63, 1, outQuad, SCREEN_CENTER_X*1.5, SCREEN_CENTER_X*0.5, function(p)
			P1:x(p)
		end}
		func {63, 1, outQuad, SCREEN_CENTER_X*1.5, SCREEN_CENTER_X*0.5, function(p)
			P2:x(p)
		end}]]
		
		func {64, 8, bounce, SCREEN_CENTER_X, SCREEN_CENTER_X*0.5, function(p)
			if P1 then 
			P1:x(p)
			end
		end}
		func {64, 8, bounce, SCREEN_CENTER_X, SCREEN_CENTER_X*0.5, function(p)
			if P2 then 
			P2:x(p)
			end
		end}
		
		func {72, 8, bounce, SCREEN_CENTER_X, SCREEN_CENTER_X*1.5, function(p)
			if P1 then 
			P1:x(p)
			end
		end}
		
		func {72, 8, bounce, SCREEN_CENTER_X, SCREEN_CENTER_X*1.5, function(p)
			if P2 then 
			P2:x(p)
			end
		end}
		
		for i = 79,80,0.25 do
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,0.25,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			mult = -mult
		end
		
		ease {62.9,0,outCirc,360,'rotationy'}
		ease {63,2,outQuad,0,'rotationy'}
		
		ease {62.9,0,outCirc,-614,'confusionyoffset'}
		ease {63,2,outQuad,0,'confusionyoffset'}
		
		ease {78.9,0,outCirc,360,'rotationy'}
		ease {79,2,outQuad,0,'rotationy'}
		
		ease {78.9,0,outCirc,-614,'confusionyoffset'}
		ease {79,2,outQuad,0,'confusionyoffset'}
		
		ease {79,1,outQuad,0,'reverse'}
		ease {79,1,outCirc,-40,'rotationx'}
		ease {79,1,outCirc,-50,'flip'}
		ease {79,1,outCirc,-100,'movey'}
		ease {79,1,outCirc,100,'drawsize'}
		--ease {80,1,outCirc,100,'tipsy'}
		--ease {80,1,outCirc,,'drunk'}
		
		local sounds = {
			{80.000,0,1},
			{81.000,1,1},
			{82.000,2,1},
			{82.500,1,1},
			{83.000,0,1},
			{84.000,3,1},
			{85.000,1,1},
			{86.000,2,1},
			{86.500,1,1},
			{87.000,3,1},
			{88.000,0,1},
			{89.000,3,1},
			{89.667,1,1},
			{90.000,3,1},
			{90.500,0,1},
			{91.000,1,1},
			{92.000,0,1},
			{93.000,3,1},
			{94.000,1,1},
			{94.500,2,1},
			{95.000,0,1},
			{96.000,3,1},
			{97.000,1,1},
			{98.000,2,1},
			{98.500,1,1},
			{99.000,3,1},
			{100.000,0,1},
			{101.000,1,1},
			{102.000,2,1},
			{102.500,1,1},
			{103.000,0,1},
			{104.000,3,1},
			{105.000,0,1},
			{105.667,1,1},
			{106.000,0,1},
			{106.500,3,1},
			{107.000,1,1},
			{108.000,3,1},
			{109.000,0,1},
			{110.000,1,1},
			{110.500,2,1},
			{111.000,3,1},
		}
		
		local draz_swap = 0
		
		for i,v in pairs(sounds) do
			if draz_swap == 1 then
				ease {v[1],2,outQuart,100,'tipsy'}
				ease {v[1],2,outQuart,100,'drunk'}
				draz_swap = 0
			else
				ease {v[1],2,outQuart,-100,'tipsy'}
				ease {v[1],2,outQuart,-100,'drunk'}
				draz_swap =	1
			end
		end
		
		ease {80,8,bounce,-30,'rotationy'}
		ease {88,8,bounce,30,'rotationy'}
		--ease {63,1,bounce,-30,'rotationy'}
		ease {96,8,bounce,-30,'rotationy'}
		ease {104,8,bounce,30,'rotationy'}
		
		set {80,100,'wave'}
		set {80,50,'waveoffset'}
		
		ease {111,1,outQuad,99,'reverse'}
		ease {111,1,outCirc,50,'movey'}
		
		for i = 111,112,0.25 do
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,0.25,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			mult = -mult
		end
		
		ease {112,8,bounce,-30,'rotationy'}
		ease {120,8,bounce,30,'rotationy'}
		--ease {63,1,bounce,-30,'rotationy'}
		ease {128,8,bounce,-30,'rotationy'}
		ease {136,8,bounce,30,'rotationy'}
		
		local arrows = {
			{112.000,3,2,length=1.000},
			{113.000,1,1},
			{114.000,2,1},
			{114.500,1,1},
			{115.000,3,1},
			{116.000,0,1},
			{117.000,1,1},
			{118.000,2,1},
			{118.500,1,2,length=0.500},
			{119.000,2,1},
			{121.000,0,1},
			{121.667,2,1},
			{122.000,0,1},
			{122.500,3,1},
			{123.000,2,1},
			{124.000,3,1},
			{125.000,0,1},
			{126.000,1,1},
			{126.500,2,1},
			{127.000,3,1},
			{128.000,0,2,length=1.000},
			{129.000,1,1},
			{130.000,2,1},
			{130.500,1,1},
			{131.000,0,1},
			{132.000,3,1},
			{133.000,1,1},
			{134.000,2,1},
			{134.500,1,2,length=0.500},
			{135.000,2,1},
			{135.500,2,2,length=0.500},
			{136.000,0,2,length=1.000},
			{137.000,3,1},
			{137.667,2,1},
			{138.000,3,1},
			{138.500,0,1},
			{139.000,2,1},
			{140.000,0,1},
			{141.000,3,1},
			{142.000,1,1},
			{142.500,2,1},
			{143.000,0,1},
		}
		
		for i,v in pairs(arrows) do
			if draz_swap == 1 then
				ease {v[1],2,outQuart,100,'tipsy'}
				ease {v[1],2,outQuart,100,'drunk'}
				draz_swap = 0
			else
				ease {v[1],2,outQuart,-100,'tipsy'}
				ease {v[1],2,outQuart,-100,'drunk'}
				draz_swap =	1
			end
		end
		
		ease {143,1,outQuad,0,'reverse'}
		ease {143,1,outCirc,0,'rotationx'}
		ease {143,1,outCirc,0,'flip'}
		ease {143,1,outCirc,0,'wave'}
		ease {143,1,outCirc,0,'movey'}
		
		for i = 143,144,0.25 do
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,0.25,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			mult = -mult
		end
		
		func {143, 1, outSine, SCREEN_CENTER_X, SCREEN_CENTER_X*0.5, function(p)
			if P1 then 
			P1:x(p)
			end
		end}
		func {143, 1, outSine, SCREEN_CENTER_X, SCREEN_CENTER_X*1.5, function(p)
			if P2 then 
			P2:x(p)
			end
		end}
			
		
		for j = 80,111,1 do
			--ease {i,0.25,outQuad,50*mult,'drunk'}
			--ease {i,0.25,outQuad,50*mult,'tipsy'}
			set {j,-150,'tiny'}
			ease {j,1,outQuad,0,'tiny'}
		end
		
		for j = 112,143,1 do
			--ease {i,0.25,outQuad,50*mult,'drunk'}
			--ease {i,0.25,outQuad,50*mult,'tipsy'}
			set {j,-150,'tiny'}
			ease {j,1,outQuad,0,'tiny'}
		end
		
		for j = 82.5,142.5,4 do
			--ease {i,0.25,outQuad,50*mult,'drunk'}
			--ease {i,0.25,outQuad,50*mult,'tipsy'}
			set {j,-150,'tiny'}
			ease {j,1,outQuad,0,'tiny'}
		end
		
		for i = 144,174,1 do
			--ease {i,0.25,outQuad,50*mult,'drunk'}
			--ease {i,0.25,outQuad,50*mult,'tipsy'}
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,0.25,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			ease {i,1,bounce,-30,'movey'}
			mult = -mult
		end
		
		for j = 176,191,1 do
			--ease {i,0.25,outQuad,50*mult,'drunk'}
			--ease {i,0.25,outQuad,50*mult,'tipsy'}
			ease {j,0,outQuad,-100,'tiny'}
			ease {j,1,outQuad,0,'tiny'}
			ease {j,0,outQuad,70*mult,'drunk'}
			ease {j,1,outQuad,0,'drunk'}
			ease {j,0,outQuad,70*mult,'tipsy'}
			ease {j,1,outQuad,0,'tipsy'}
			ease {j,1,bounce,-30,'movey'}
			ease {j,0,outQuad,20,'brake'}
			ease {j,1,outQuad,0,'brake'}
			mult = -mult
		end
		
		for i = 192,206,1 do
			--ease {i,0.25,outQuad,50*mult,'drunk'}
			--ease {i,0.25,outQuad,50*mult,'tipsy'}
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,0.25,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
		    ease {i,1,bounce,-30,'movey'}
			
			mult = -mult
		end
		
		for i = 174,175.75,0.25 do
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,0.25,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			mult = -mult
		end
		
		for i = 191,192,0.25 do
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,0.25,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			ease {i,1,bounce,20,'movey'}
			mult = -mult
		end
		
		for i = 206,208,0.25 do
			set {i,100*mult,'drunk'}
			set {i,100*mult,'tipsy'}
			ease {i,1,outQuad,0,'drunk'}
			ease {i,1,outQuad,0,'tipsy'}
			set {i,-100,'tiny'}
			ease {i,0.25,outQuad,0,'tiny'}
			set {i,30,'brake'}
			ease {i,1,outQuad,0,'brake'}
			mult = -mult
		end
		
		gamer = {
			{152.000,0,2,1.000},
			{153.000,2,2,0.500},
			{153.500,1,2,1.000},
			{154.500,3,2,0.500},
			{155.000,2,2,1.500},
			{156.500,3,2,1.000},
			{157.500,0,2,0.500},
			{158.000,1,2,1.000},
			{159.000,2,2,0.500},
			{159.500,3,1,0.5},
			{168.000,0,2,1.000},
			{169.000,2,2,0.500},
			{169.500,1,2,1.000},
			{170.500,3,2,0.500},
			{171.000,2,2,1.500},
			{172.500,3,2,1.000},
			{173.500,0,2,0.500},
			{174.000,1,2,1.000},
			{175.000,2,2,0.500},
			{175.500,3,1,0.5},
			{184.000,0,2,1.000},
			{185.000,2,2,0.500},
			{185.500,1,2,1.000},
			{186.500,3,2,0.500},
			{187.000,2,2,1.500},
			{188.500,3,2,1.000},
			{189.500,0,2,0.500},
			{190.000,1,2,1.000},
			{191.000,2,2,0.500},
			{191.500,3,1,0.5},
			{200.000,0,2,1.000},
			{201.000,2,2,0.500},
			{201.500,1,2,1.000},
			{202.500,3,2,0.500},
			{203.000,2,2,1.500},
			{204.500,3,2,1.000},
			{205.500,0,2,0.500},
			{206.000,1,2,1.000},
			{207.000,2,2,0.500},
			{207.500,3,1,0.5},	
		}
		
		set{152,100,'dizzyholds'}
		
		for i,v in pairs(gamer) do
			if draz_swap == 1 then
				ease {v[1],v[4],bounce,-30,'rotationy'}
				ease {v[1],v[4],bounce,-30,'dizzy'}
				ease {v[1],v[4],bounce,-30,'movex'}
				--ease {v[1],v[4],bounce,-50,'cubicx'}
				--ease {v[1],v[4]*2,bounce,20,'wave'}
				draz_swap = 0
			else
				ease {v[1],v[4],bounce,30,'rotationy'}
				ease {v[1],v[4],bounce,30,'dizzy'}
				--ease {v[1],v[4],bounce,50,'cubicx'}
				--ease {v[1],v[4],bounce,20,'wave'}
				ease {v[1],v[4],bounce,30,'movex'}
				draz_swap =	1
			end
		end
		
		ease {174,2,outQuart,99,'reverse'}
		
		ease {206,2,outQuart,0,'reverse'}
		
		ease {208,2,outQuart,0,'zoom'}
			
    end,

    -- funy scren budies go here
	actors
	
}
