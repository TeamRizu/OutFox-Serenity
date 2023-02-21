--[[
----
This is an edit of mirin-porting.lua to better suit the Lunar Template.
Please use the original if you plan to port using the Mirin Template.
----
]]--

xero()

return Def.Actor {
    LoadCommand = function(self)
        bw, bh = 640, 480
        sm_scaleW, sm_scaleH = sw / bw, sh / bh
        sm_scaleR = sm_scaleW / sm_scaleH
        sm_fix = (FUCK_EXE and 0) or 1

        function CorrectZDist(actor)
            if not FUCK_EXE and actor and actor.GetNumChildren then
                actor:fardistz(1000 * sm_scaleW)
                for an = 0, actor:GetNumChildren() - 1 do
                    CorrectZDist(actor:GetChildAt(an))
                end
            end
        end
        function CorrectFOV(actor, fov)
            if not FUCK_EXE and actor and actor.GetNumChildren then
                actor:fov(fov)
                for an = 0, actor:GetNumChildren() - 1 do
                    CorrectFOV(actor:GetChildAt(an), fov)
                end
            end
        end

        alias
        {'confusionzoffset', 'confusionoffset'}
        {'hidenoteflashes', 'hidenoteflash'}

        local PN = {}
        for pn = 1, 2 do
			if P[pn] then 
				P[pn]:fardistz(1000 * sm_scaleW)
				P[pn]:zoomz(sm_scaleW)
				P[pn]:rotafterzoom(false)

				if P[pn]:GetChild('NoteField'):GetNumWrapperStates() == 0 then
					P[pn]:GetChild('NoteField'):AddWrapperState()
				end
				PN[pn] = P[pn]:GetChild('NoteField'):GetWrapperState(1)
				PN[pn]:rotafterzoom(false)
			end
        end

        local POptions = {
            GAMESTATE:GetPlayerState(0):GetPlayerOptions('ModsLevel_Song'),
            GAMESTATE:GetPlayerState(1):GetPlayerOptions('ModsLevel_Song')
        }

        alias
        {'holdstealth', 'stealthholds'}
        {'halgun', 'hideholdjudgments'}
        {'centered2', 'centeredpath'}
        {'reversetype', 'unboundedreverse'}
        {'arrowpath', 'notepath'}
        {'arrowpath0', 'notepath1'}
        {'arrowpath1', 'notepath2'}
        {'arrowpath2', 'notepath3'}
        {'arrowpath3', 'notepath4'}
		{'arrowpathgirth', 'notepathwidth'}

        setdefault {100, 'tinyusesminicalc'}

        for _, tween in ipairs {
            {'x', 1},
            {'y', 1},
            {'z', 1},
            {'rotationx', 1},
            {'rotationy', 1},
            {'rotationz', 1},
            {'skewx', 0.01},
            {'skewy', 0.01},
            {'zoomx', 0.01, 'zoom', 0.01},
            {'zoomy', 0.01, 'zoom', 0.01},
            {'zoomz', 0.01},
        } do
            local name, mul, other, other_mul = tween[1], tween[2], tween[3], tween[4]
            if other then
                definemod {
                    name, other,
                    function(m, n, pn)
                        if PN[pn] and PN[pn][name] then PN[pn][name](PN[pn], (m * mul) * (n * other_mul)) end
                    end,
                    defer = true
                }
            else
                definemod {
                    name,
                    function(n, pn)
                        if PN[pn] and PN[pn][name] then PN[pn][name](PN[pn], n * mul) end
                    end,
                    defer = true
                }
            end
        end

        definemod
        {
            'tiny',
            function(n)
                return n, n
            end,
            'tinyx', 'tinyy',
            defer = true
        }
        {
            'hide',
            function(n, pn)
                if PN[pn] then PN[pn]:visible(n <= 0) end
            end,
            defer = true
        }
        {
            'hidenoteflash',
            function(n)
                return n, n, n, n
            end,
            'hidenoteflash1', 'hidenoteflash2', 'hidenoteflash3', 'hidenoteflash4',
            defer = true
        }
        {
            'holdgirth',
            function(n)
                return -n, -n, -n, -n
            end,
            'holdtinyx1', 'holdtinyx2', 'holdtinyx3', 'holdtinyx4',
            defer = true
        }
        --[[ Under construction, use at your own risk
        {
            'mini',
            function(n)
                if PN[pn] then PN[pn]:zoomz(PN[pn]:GetZoomZ() * (1 / (1 - n * 0.005)))
                return n
            end,
            'mini',
            defer = true
        }
        ]]--

        do
            local frontratio = 410 / THEME:GetMetric('Player', 'DrawDistanceBeforeTargetsPixels')
            local backratio = -114 / THEME:GetMetric('Player', 'DrawDistanceAfterTargetsPixels')

            for _, v in ipairs{
                {'drawsize', frontratio},
                {'drawsizeback', backratio},
                {'arrowpathdrawsize', frontratio, 'notepathdrawsize'},
                {'arrowpathdrawsizeback', backratio, 'notepathdrawsizeback'}
            } do
                local name, distratio, ali = v[1], v[2], v[3]
                local function scaledist(n)
                    return (n + 100) * distratio - 100
                end

                if ali then
                    definemod {name, scaledist, ali, defer = true}
                else
                    node {name, scaledist, name, defer = true}
                end
            end
        end

        for col = 1, 4 do
            for _, mod in ipairs {
                {'ConfusionXOffset', 0.01},
                {'ConfusionYOffset', 0.01},
                {'ConfusionZOffset', 0.01},
                {'MoveX', 0.01},
                {'MoveY', 0.01},
                {'MoveZ', 0.01},
                {'NoteSkewX', 0.01},
                {'NoteSkewY', 0.01},
                {'Dark', 0.01},
                {'Reverse', 0.01},
            } do
                local modname, mul = mod[1]..col, mod[2]
                if string.sub(mod[1], 1, 4) == 'Move' then
                    definemod {
                        string.lower(mod[1])..(col - 1), string.lower(mod[1]),
                        function(m, n, pn)
                            if POptions[pn] and POptions[pn][modname] then
                                POptions[pn][modname](POptions[pn], (m + n) * mul, 9e9)
                            end
                        end,
                        defer = true
                    }
                else
                    definemod {
                        string.lower(mod[1])..(col - 1),
                        function(n, pn)
                            if POptions[pn] and POptions[pn][modname] then
                                POptions[pn][modname](POptions[pn], n * mul, 9e9)
                            end
                        end,
                        defer = true
                    }
                end
            end
        end
    end
}
