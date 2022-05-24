local assets =
{
    Asset("ANIM", "anim/frog_legs.zip"),
}

local prefabs =
{
    "cutgrass",
}

local function commonfn(anim, cookable)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("frog_legs")
    inst.AnimState:SetBuild("frog_legs")
    inst.AnimState:PlayAnimation(anim)

    if cookable then
        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")
    end

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.GENERIC

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    if cookable then
        inst:AddComponent("cookable")
        inst.components.cookable.product = "froglegs_cooked"
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    MakeHauntableLaunchAndPerish(inst)

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = 4

    return inst
end

local function defaultfn()
    local inst = commonfn("idle", true)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = 15
    inst.components.edible.hungervalue = 25
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.edible.sanityvalue = 10

    return inst
end

local function cookedfn()
    local inst = commonfn("cooked")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.edible.healthvalue = 20
    inst.components.edible.hungervalue = 30
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
    inst.components.edible.sanityvalue = 30

    return inst
end

return Prefab("raw_donuts_hanako", defaultfn, assets, prefabs),
        Prefab("cutgrass", cookedfn, assets) --donuts_hanako