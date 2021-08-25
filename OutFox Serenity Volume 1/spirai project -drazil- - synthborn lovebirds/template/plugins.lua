xero()
local path_to_plugins = 'plugins/'
local af = Def.ActorFrame {}
local filestruct
if FUCK_EXE then
    filestruct = {GAMESTATE:GetFileStructure(songdir..path_to_plugins)}
else
    filestruct = FILEMAN:GetDirListing(songdir..path_to_plugins)
end
for _, filename in ipairs(filestruct) do
    if string.sub(filename, -4, -1) == '.lua' then
        af[#af + 1] = loadscript(path_to_plugins..filename)
    end
end
return af
