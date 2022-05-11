local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

-- Your character's stats
TUNING.HANAKO_HEALTH = 150
TUNING.HANAKO_HUNGER = 150
TUNING.HANAKO_SANITY = 120

-- Custom starting inventory
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.HANAKO = {
	"flint",
	"flint",
	"twigs",
	"twigs",
}

print("mod")
print("mod")
print("mod")
print("mod")
print("mod")
print("mod")

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.HANAKO
end
local prefabs = FlattenTree(start_inv, true)

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when not a ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "hanako_speed_mod", 1)
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "hanako_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "hanako.tex" )
end




local function CustomSanityFn(inst, dt)
	return 0
end

local function update_uwu(inst)
	--print("oi print")
end

local function OnKillerOther(inst, data)
	local victim = data.victim
	if victim:HasTag("monster")then
		inst.components.sanity:DoDelta(4)
		inst.components.health:DoDelta(3)
	else
		if victim:HasTag("hostile") then
			inst.components.hunger:DoDelta(-6)
		else
			inst.components.sanity:DoDelta(-8)
			inst.components.health:DoDelta(-2)
		end 
	end
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- Set starting inventory
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	
	-- choose which sounds this character will play
	inst.soundsname = "willow"
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.HANAKO_HEALTH)
	inst.components.hunger:SetMax(TUNING.HANAKO_HUNGER)
	inst.components.sanity:SetMax(TUNING.HANAKO_SANITY)
	
	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 2
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE

	--inst._update_task_uwu = inst:DoPeriodicTask(1, update_uwu)

	inst.components.sanity.custom_rate_fn = CustomSanityFn -- diminuir sanidade
	inst.components.sanity:AddSanityAuraImmunity("ghost")
    inst.components.sanity:SetPlayerGhostImmunity(true)

	inst:ListenForEvent("killed", OnKillerOther)
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("hanako", prefabs, assets, common_postinit, master_postinit, prefabs)
