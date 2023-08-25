KCEpinephrine = {}
KCEpinephrine.OnGiveXP = {}
KCEpinephrine.totalTime = 2 * 60
KCEpinephrine.bodyPartsThatImpactCombatSpeed = { BodyPartType.Hand_R, BodyPartType.ForeArm_R, BodyPartType.UpperArm_R }
KCEpinephrine.bodyPartsThatImpactWalkSpeed = {}
KCEpinephrine.factor = -0.0001
KCEpinephrine.keepTime = 1
KCEpinephrine.resultBiteTime = 80.0
KCEpinephrine.resultScratchTime = 20.0
KCEpinephrine.resultCutTime = 20.0
KCEpinephrine.resultDeepWoundTime = 20.0
KCEpinephrine.resultFractureTime = 60.0
KCEpinephrine.notWorkingTime = 12 * 60 * 60

KCEpinephrine.resultFatigue = 0.7
KCEpinephrine.resultEndurance = 0.5
KCEpinephrine.resultHunger = 0.5
KCEpinephrine.resultThirst = 0.7
KCEpinephrine.resultPanic = 120.0
KCEpinephrine.resultMinusWeight = 2.0
KCEpinephrine.resultFear = 0.8
KCEpinephrine.resultWetness = 80

KCEpinephrine.data = {}
KCEpinephrine.data.takingEffect = false
KCEpinephrine.data.remainingTime = -1
KCEpinephrine.data.bodyPartData = {}
KCEpinephrine.data.lastTime = -1
--KCEpinephrine.data.tooMuch = false

function KCEpinephrine.Inject(items, result, player)
    local currentTime = getGametimeTimestamp()
    if currentTime - KCEpinephrine.data.lastTime <= KCEpinephrine.notWorkingTime then
        player:Say(getText("IGUI_inject_KCEpinephrine_in_not_working_time"))
        return
    end

    if not KCEpinephrine.data.takingEffect then
        for key, value in pairs(KCEpinephrine.bodyPartsThatImpactCombatSpeed) do
            local bodyPart = player:getBodyDamage():getBodyPart(value)
            KCEpinephrine.data.bodyPartData[value] = { scratch = bodyPart:getScratchSpeedModifier(),
                                                       cut = bodyPart:getCutSpeedModifier(),
                                                       burn = bodyPart:getBurnSpeedModifier(),
                                                       deepWound = bodyPart:getDeepWoundSpeedModifier(),
                                                       additionalPain = bodyPart:getAdditionalPain() }
            bodyPart:setScratchSpeedModifier(KCEpinephrine.factor)
            bodyPart:setCutSpeedModifier(KCEpinephrine.factor)
            bodyPart:setBurnSpeedModifier(KCEpinephrine.factor)
            bodyPart:setDeepWoundSpeedModifier(KCEpinephrine.factor)

            bodyPart:setAdditionalPain(-10000);
        end

        player:getStats():setFatigue(0)
        player:getStats():setEndurance(1)
        player:getStats():setPain(0)
        player:getStats():setFear(0)
        player:getStats():setPanic(0)
    end
    KCEpinephrine.data.takingEffect = true
    KCEpinephrine.data.lastTime = currentTime
    KCEpinephrine.KeepBiteAndTime()
    KCEpinephrine.data.remainingTime = KCEpinephrine.totalTime
    --KCEpinephrine.StoreData()

    player:Say(getText("IGUI_lets_fight_after_KCEpinephrine_injection"))
end

function KCEpinephrine.CheckRemainingTime()
    if not KCEpinephrine.data.takingEffect then
        return
    end

    KCEpinephrine.KeepBiteAndTime()

    KCEpinephrine.data.remainingTime = KCEpinephrine.data.remainingTime - 10
    if KCEpinephrine.data.remainingTime <= 0 then
        KCEpinephrine.RestoreConfig()
        local hasSideEffect = KCEpinephrine.ProduceSideEffect()

        KCEpinephrine.data.takingEffect = false
        local content = "IGUI_the_KCEpinephrine_effect_stops"
        if hasSideEffect then
            content = "IGUI_the_KCEpinephrine_effect_stops_with_side_effect"
        end
        getPlayer():Say(getText(content))
    end

    --KCEpinephrine.StoreData()
end

function KCEpinephrine.KeepBiteAndTime()
    if not KCEpinephrine.data.takingEffect then
        return
    end

    local player = getPlayer()
    for key, value in pairs(KCEpinephrine.bodyPartsThatImpactCombatSpeed) do
        local bodyPart = player:getBodyDamage():getBodyPart(value)
        if bodyPart:bitten() or bodyPart:getBiteTime() > 0 then
            bodyPart:setBiteTime(KCEpinephrine.keepTime)
        end
    end
end

function KCEpinephrine.RestoreConfig()
    local player = getPlayer()
    for key, value in pairs(KCEpinephrine.bodyPartsThatImpactCombatSpeed) do
        local bodyPart = player:getBodyDamage():getBodyPart(value)
        bodyPart:setScratchSpeedModifier(KCEpinephrine.data.bodyPartData[value].scratch)
        bodyPart:setCutSpeedModifier(KCEpinephrine.data.bodyPartData[value].cut)
        bodyPart:setBurnSpeedModifier(KCEpinephrine.data.bodyPartData[value].burn)
        bodyPart:setDeepWoundSpeedModifier(KCEpinephrine.data.bodyPartData[value].deepWound)

        bodyPart:setAdditionalPain(KCEpinephrine.data.bodyPartData[value].additionalPain)
    end
end

function KCEpinephrine.ProduceSideEffect()
    local player = getPlayer()

    player:getStats():setFatigue(math.max(player:getStats():getFatigue(), KCEpinephrine.resultFatigue))
    player:getStats():setEndurance(math.min(player:getStats():getEndurance(), KCEpinephrine.resultEndurance))

    player:getStats():setPanic(math.max(player:getStats():getPanic(), KCEpinephrine.resultPanic))
    player:getStats():setFear(math.max(player:getStats():getFear(), KCEpinephrine.resultFear))
    player:getStats():setHunger(math.max(player:getStats():getHunger(), KCEpinephrine.resultHunger))
    player:getStats():setThirst(math.max(player:getStats():getThirst(), KCEpinephrine.resultThirst))

    player:getNutrition():setWeight(player:getNutrition():getWeight() - KCEpinephrine.resultMinusWeight)
    player:getBodyDamage():setWetness(math.max(player:getBodyDamage():getWetness(), KCEpinephrine.resultWetness))

    local hasSideEffect = false
    local bodyParts = player:getBodyDamage():getBodyParts()
    for i = 0, bodyParts:size() - 1 do
        local bodyPart = bodyParts:get(i)

        if bodyPart:scratched() then
            bodyPart:setScratchTime(KCEpinephrine.resultScratchTime)
            hasSideEffect = true
        end
        if bodyPart:isCut() then
            bodyPart:setCutTime(KCEpinephrine.resultCutTime)
            hasSideEffect = true
        end
        if bodyPart:deepWounded() then
            bodyPart:setDeepWoundTime(KCEpinephrine.resultDeepWoundTime)
            hasSideEffect = true
        end
        if bodyPart:bitten() then
            bodyPart:setBiteTime(KCEpinephrine.resultBiteTime)
            hasSideEffect = true
        end
    end
    return hasSideEffect
end
--function KCEpinephrine.StoreData()
--    local modData = getPlayer():getModData()
--    modData.KCEpinephrineData = KCEpinephrine.data
--end

--function KCEpinephrine.LoadData()
--    local modData = getPlayer():getModData()
--    if modData.KCEpinephrineData ~= nil then
--        --todo: need to figure out why bodyPartData cannot be store, probably it does not works for table
--        KCEpinephrine.data = modData.KCEpinephrineData
--    end
--end

function KCEpinephrine.OnGiveXP.Doctor2(recipe, ingredients, result, player)
    player:getXp():AddXP(Perks.Doctor, 2)
end

Events.EveryTenMinutes.Add(KCEpinephrine.CheckRemainingTime)
--Events.OnGameStart.Add(KCEpinephrine.LoadData)
