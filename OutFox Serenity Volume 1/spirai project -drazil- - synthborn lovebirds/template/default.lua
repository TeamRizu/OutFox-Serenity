
if (IsGame("dance") or IsGame('groove')) and (GAMESTATE:GetCurrentStyle():GetName() == "single" or GAMESTATE:GetCurrentStyle():GetName() == "versus") then
	
	if (IsGame("dance")) then
		SCREENMAN:SystemMessage("This file might not work as expected on 'dance', use 'groove' gamemode instead to play this file.")
	end

	_G.xero = {}
	xero.songdir = GAMESTATE:GetCurrentSong():GetSongDir()
	xero.loadscript = function(path) return assert(loadfile(xero.songdir..path))() end
	return Def.ActorFrame {
		InitCommand = function(self)
			xero.foreground = self
			xero.loadscript('template/sharedvars.lua')
			self:sleep(9e9)
		end,
		xero.loadscript('template/std.lua'),
		xero.loadscript('template/template.lua'),
		xero.loadscript('template/ease.lua'),
		xero.loadscript('template/plugins.lua'),
		xero.loadscript('outfox/modport.lua'),
		xero.loadscript('lua/mods.lua'),
	}
else
  return Def.Actor{}
end

-- The checks for groove and warning for 'dance' were added later by Moru Zerinho6, all the code other than that is from drazil.