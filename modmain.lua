PrefabFiles = {
	"hanako",
	"hanako_none",
    "knife_hanako",
}

Assets = {

    Asset( "IMAGE", "images/saveslot_portraits/hanako.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/hanako.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/hanako.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/hanako.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/hanako_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/hanako_silho.xml" ),

    Asset( "IMAGE", "bigportraits/hanako.tex" ),
    Asset( "ATLAS", "bigportraits/hanako.xml" ),
	
	Asset( "IMAGE", "images/map_icons/hanako.tex" ),
	Asset( "ATLAS", "images/map_icons/hanako.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_hanako.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_hanako.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_hanako.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_hanako.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_hanako.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_hanako.xml" ),
	
	Asset( "IMAGE", "images/names_hanako.tex" ),
    Asset( "ATLAS", "images/names_hanako.xml" ),
	
	Asset( "IMAGE", "images/names_gold_hanako.tex" ),
    Asset( "ATLAS", "images/names_gold_hanako.xml" ),
}

AddMinimapAtlas("images/map_icons/hanako.xml")

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Ingredient = GLOBAL.Ingredient

-- The character select screen lines
STRINGS.CHARACTER_TITLES.hanako = "The Sample Character"
STRINGS.CHARACTER_NAMES.hanako = "Esc"
STRINGS.CHARACTER_DESCRIPTIONS.hanako = "*Perk 1\n*Perk 2\n*Perk 3"
STRINGS.CHARACTER_QUOTES.hanako = "\"Quote\""
STRINGS.CHARACTER_SURVIVABILITY.hanako = "Slim"

-- Custom speech strings
STRINGS.CHARACTERS.HANAKO = require "speech_hanako"

-- The character's name as appears in-game 
STRINGS.NAMES.HANAKO = "hanako"
STRINGS.SKIN_NAMES.hanako_none = "hanako"



-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("hanako", "FEMALE", skin_modes)



STRINGS.NAMES.KNIFE_HANAKO = "Hanako Knife"
STRINGS.RECIPE_DESC.KNIFE_HANAKO = "knice"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.KNIFE_HANAKO = "That's one scientific hat."

AddRecipe("knife_hanako",
{
    Ingredient("cutgrass",4)
},
GLOBAL.RECIPETABS.SCIENCE,
GLOBAL.TECH.NONE,
nil, -- placer
nil, -- min space 1.5 
nil, -- no unlock   
nil, -- num to give
"hanako", -- tag character
nil, -- atlas
nil  -- image
)