local assets =
{
    Asset("ANIM", "anim/spear.zip"),
    Asset("ANIM", "anim/swap_spear.zip"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end


local function OnAttack(inst, attacker, target)
    if target ~= nil and attacker ~= nil then
        if attacker:HasTag("player") and target:HasTag("hanakoheal") and attacker.components.health ~= nil then
            attacker.components.health:DoDelta(2)
        end
        
        if attacker:HasTag("hanako") and not target:HasTag("hanakoheal") and target.components.health ~= nil then
            target:AddTag("hanakoheal")
            target.components.health:DoDelta(-10)
        end
    
    end
end



-- fn

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spear")
    inst.AnimState:SetBuild("swap_spear")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("knifehanako")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(52)
    inst.components.weapon:SetOnAttack(OnAttack)

    -------

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES*2)
    inst.components.finiteuses:SetUses(TUNING.SPEAR_USES*2)

    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    --inst.components.inventoryitem.imagename = "wand"
    --inst.components.inventoryitem.atlasname = "images/inventoryimages/wand.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("knife_hanako", fn, assets)