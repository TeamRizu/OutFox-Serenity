local Names = LoadModule("Config.Load.lua")("TeamRizu",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")
local tNames = {false}
local tImage = {"TeamRizu.png"}
for word in string.gmatch(Names, '([^,]+)') do
    tNames[#tNames+1] = word
end
tNames[#tNames+1] = "Helpers:"
Names = LoadModule("Config.Load.lua")("Helpers",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")
for word in string.gmatch(Names, '([^,]+)') do
    tNames[#tNames+1] = word
end
tNames[#tNames+1] = "Special Thanks:"
Names = LoadModule("Config.Load.lua")("Special Thanks",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")
for word in string.gmatch(Names, '([^,]+)') do
    tNames[#tNames+1] = word
end

local CartOffset = 1

local Carts = Def.ActorFrame{}
for i = 1,#tNames do
    Carts[#Carts+1] = Def.ActorFrame {
        OnCommand=function(self) self:x(480):linear(66.5):x(-4800) end,
        Def.Sprite {
            Texture="Cart 2x1.png",
            InitCommand=function(self) self:SetTextureFiltering(false):x(-180+34+(96*i)):SetAllStateDelays(0.25):setstate(CartOffset) if CartOffset == 0 then CartOffset = 1 else CartOffset = 0 end end
         },
		 Def.BitmapText {
			Font="_roboto black Bold 24px",
            Text=tNames[i] and tNames[i] or "",
            InitCommand=function(self) self:SetTextureFiltering(false):xy(-180+34+(96*i),-2):zoom(.45) end
         }		 
    }
	if tImage[i] then
		Carts[#Carts+1] = Def.ActorFrame {
			OnCommand=function(self) self:x(480):linear(66.5):x(-4800) end,
			Def.Sprite {
				Texture=tImage[i],
				InitCommand=function(self) self:SetTextureFiltering(false):xy(-180+34+(96*i),-2):zoom(.15) end   
			}
        }
	end
end

Carts[#Carts+1] = Def.ActorFrame {
	OnCommand=function(self) self:x(480):linear(66.5):x(-4800) end,
	Def.Sprite {
		Texture="fox.png",
		InitCommand=function(self) self:SetTextureFiltering(false):xy(-180+4+(96*(#Carts-1)),-2):zoom(.1):sleep(0+(#Carts*1.3)):diffusealpha(0) end 		
	},
	Def.Sprite {
		Texture="Cabose 2x1.png",
		InitCommand=function(self) self:SetTextureFiltering(false):x(-180+10+(96*(#Carts-1))):SetAllStateDelays(0.25):setstate(CartOffset) if CartOffset == 0 then CartOffset = 1 else CartOffset = 0 end end
	},
}

return Def.ActorFrame {
	Def.ActorFrame {
		InitCommand=function(self)
			self:zoom((SCREEN_HEIGHT/720)*3):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+((SCREEN_HEIGHT/720)*300)):sleep(9e9)
		end,
		OnCommand=function(self)
			for pn = 1,2 do
				GAMESTATE:GetPlayerState(pn-1):GetPlayerOptions('ModsLevel_Song'):FailSetting('FailType_Off')
				if GAMESTATE:IsPlayerEnabled("PlayerNumber_P"..pn) then			
					for _,col in ipairs(SCREENMAN:GetTopScreen():GetChild("PlayerP"..pn):GetChild("NoteField"):get_column_actors()) do
						col:sleep((#Carts*1.3)):linear(.5):diffusealpha(.25)
					end
				end
			end
		end,
		
		Def.Sprite {
			Texture="FG.png",
			InitCommand=function(self) self:SetTextureFiltering(false):y(-104):zoom(1.6) end,
			OnCommand=function(self) self:diffusealpha(0):linear(0.5):diffusealpha(1):sleep(3+(#Carts*1.3)):queuecommand("Scroll") end,
			ScrollCommand=function(self) self:texcoordvelocity(0.1,0) end,
		},
		Def.ActorFrame {
			OnCommand=function(self) self:x(480):linear(66.5):x(-4800) end,
			Def.Sprite {
				Texture="Train 16x1.png",
				InitCommand=function(self) self:SetTextureFiltering(false):SetAllStateDelays(0.125):setstate(1):x(-180) end
			},
			Def.Sprite {
				Texture="Coal 2x1.png",
				InitCommand=function(self) self:SetTextureFiltering(false):x(-180+58):SetAllStateDelays(0.25) end
			},
			Def.Sound {
				File="Train.ogg",
				OnCommand=function(self) self:play() end
			},
			Def.Sound {
				File="Horn.ogg",
				OnCommand=function(self) self:sleep(5):queuecommand("Play") end,
            PlayCommand=function(self) self:play() end
			}	
		},
		Carts,
		Def.Sprite {
			Texture="right fox 3x1.png",
			InitCommand=function(self) self:animate(false):setstate(0):SetTextureFiltering(false):diffusealpha(0):sleep(0+(#Carts*1.3)):diffusealpha(1):zoom(0.15):decelerate(0.5):y(-50):accelerate(0.5):y(0):sleep(2.5):queuecommand("Walk") end,
			WalkCommand=function(self) self:animate(true) end,
			Frame0000=0,
			Delay0000=.1,
			Frame0001=1,
			Delay0001=.1,
			Frame0002=2,
			Delay0002=.1,
			Frame0003=1,
			Delay0003=.1
		}
	}
}