local Names = LoadModule("Config.Load.lua")("Stepmania5",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\nStepmania5 Contributers:\n"..LoadModule("Config.Load.lua")("Stepmania5 Contributers",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\n\n\n\n\n\n"..LoadModule("Config.Load.lua")("SSC",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\nSSC Beta Testers:\n"..LoadModule("Config.Load.lua")("SSC Beta Testers",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\nSSC Private Beta Testers:\n"..LoadModule("Config.Load.lua")("SSC Private Beta Testers",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\nSSC Friends:\n"..LoadModule("Config.Load.lua")("SSC Friends",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\nTeam Step Masters:\n"..LoadModule("Config.Load.lua")("Team Step Masters",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\n\n\n\n\n\n"..LoadModule("Config.Load.lua")("Old Stepmania Devs",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\nLegacy Stepmania Graphics:\n"..LoadModule("Config.Load.lua")("Old Stepmania Graphics",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\nLegacy Stepmania Theme:\n"..LoadModule("Config.Load.lua")("Old Stepmania Theme",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\nLegacy Stepmania Web:\n"..LoadModule("Config.Load.lua")("Old Stepmania Web",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\nLegacy Stepmania Sound:\n"..LoadModule("Config.Load.lua")("Old Stepmania Sound",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\nLegacy Stepmania Thanks:\n"..LoadModule("Config.Load.lua")("Old Stepmania Thanks",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\nOutFox Music:\n"..LoadModule("Config.Load.lua")("Music",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")..
"\n\n\n\n\n\n\n\n\n\n\n\n\n\nIn Dedication to\n"..LoadModule("Config.Load.lua")("In Dedication to",GAMESTATE:GetCurrentSong():GetSongDir().."/credits.ini")
local tNames = ""

for word in string.gmatch(Names, '([^,]+)') do
		
	tNames = tNames.."\n"..word		
end

return Def.ActorFrame {
    OnCommand=function(self)
       self:zoom((SCREEN_HEIGHT/720)*3):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+((SCREEN_HEIGHT/720)*180)):diffusealpha(0):linear(0.5):diffusealpha(1)
    end,
	Def.Quad {
        OnCommand=function(self)
            self:FullScreen():diffuse(color("#160805")):xy(-SCREEN_CENTER_X/2,-SCREEN_CENTER_Y/2)
        end
    },
    Def.Sprite {
        Texture="BG.png",
        OnCommand=function(self) self:SetTextureFiltering(false):y(-104):zoom(1.6) end
    },
	Def.ActorFrame {
		OnCommand=function(self) self:zoom(0.5):y(100):sleep(34):linear(83.75):y(-3350) end,
	Def.BitmapText {
		Font="_roboto black Bold 24px",
        Text=tNames,
		OnCommand=function(self) self:valign(0) end
	},
	Def.Sprite {
        Texture="Stepmania5.png",
        OnCommand=function(self) self:y(-50) end
    },
	Def.Sprite {
        Texture="ssc (doubleres).png",
        OnCommand=function(self) self:y(1350) end
    },
	Def.Sprite {
        Texture="Stepmania.png",
        OnCommand=function(self) self:y(2700) end
    }
	}
}
