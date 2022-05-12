local assets=
{ 
    Asset("ANIM", "anim/wand.zip"),
    Asset("ANIM", "anim/swap_wand.zip"), 

    Asset("ATLAS", "images/inventoryimages/wand.xml"),
    Asset("IMAGE", "images/inventoryimages/wand.tex"),
}

local prefabs = 
{
}


local function OnEquip(inst, owner) 
    --owner.AnimState:OverrideSymbol("swap_object", "swap_wands", "purplestaff")
    owner.AnimState:OverrideSymbol("swap_object", "swap_wand", "wand")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function OnUnequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end


local function fn(colour)


    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("wand")
    anim:SetBuild("wand")
    anim:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("hanakoknife")
    

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(52)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(300)
    inst.components.finiteuses:SetUses(300)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "wand"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/wand.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )

    MakeHauntableLaunch(inst)

    return inst
end

return  Prefab("hanako_knife", fn, assets, prefabs)