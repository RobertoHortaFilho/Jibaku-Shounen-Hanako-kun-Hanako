local assets =
{
	Asset( "ANIM", "anim/hanako.zip" ),
	Asset( "ANIM", "anim/ghost_hanako_build.zip" ),
}

local skins =
{
	normal_skin = "hanako",
	ghost_skin = "ghost_hanako_build",
}

return CreatePrefabSkin("hanako_none",
{
	base_prefab = "hanako",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"HANAKO", "CHARACTER", "BASE"},
	build_name_override = "hanako",
	rarity = "Character",
})