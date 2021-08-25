return Def.ActorFrame{
	Def.Sprite{
		Texture="matduke-bg2",
		OnCommand=function(self)
			self:scale_or_crop_background()
		end
	},
	Def.Sprite{
		Texture="matduke-bg2",
		OnCommand=function(self)
			self:scale_or_crop_background()
			:blend("BlendMode_Add"):diffuseramp():effectclock("bgm")
		end
	}
}