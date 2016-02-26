function SwapBasicAbilities(keys)
    local caster = keys.caster
    battoAbility = keys.ability
	
    caster:SwapAbilities("onimusha_dash", "onimusha_battojutsu_q", false, true)
    caster:SwapAbilities("onimusha_guard", "onimusha_battojutsu_w", false, true)
    caster:SwapAbilities("onimusha_orochi", "onimusha_battojutsu_e", false, true)

    slashOrder = ""
end

function SwapUltimateAbilities(keys)
    local caster = keys.caster
	
	if not string.match(slashOrder, "Q") then
		caster:SwapAbilities("onimusha_battojutsu_q", "onimusha_dash", false, true)
	end
	if not string.match(slashOrder, "W") then
		caster:SwapAbilities("onimusha_battojutsu_w", "onimusha_guard", false, true)
	end
	if not string.match(slashOrder, "E") then
		caster:SwapAbilities("onimusha_battojutsu_e", "onimusha_orochi", false, true)
	end
	
	slashOrder = ""
	caster:RemoveModifierByName("modifier_battojutsu")
end

function BattojutsuQ( keys )
    local caster = keys.caster
    local ability = keys.ability

    local range = battoAbility:GetLevelSpecialValueFor("range", battoAbility:GetLevel() - 1)
	local casterLoc = caster:GetAbsOrigin()
    caster:StartGesture(ACT_DOTA_ATTACK)


    slashOrder = slashOrder .. "Q"

     DamageTable = {}
    
        DamageTable.victim = target
        DamageTable.attacker = caster
        DamageTable.damage = caster:GetAttackDamage()
        DamageTable.damage_type = DAMAGE_TYPE_PHYSICAL
        DamageTable.ability = ability

    local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

    if #units > 0 then
        FindClearSpaceForUnit( caster, units[1]:GetAbsOrigin(), true )
        battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
        caster:SetForwardVector((caster:GetOrigin() - units[1]:GetOrigin()):Normalized())
        local casterAngles = caster:GetAngles()
        caster:SetAngles(0, casterAngles.y, casterAngles.z)
        caster:PerformAttack(units[1], true, true, true, false, false)
        caster:SwapAbilities("onimusha_battojutsu_q", "onimusha_dash", false, true)
    else
        FindClearSpaceForUnit( caster, caster:GetAbsOrigin(), true )
        battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
        caster:PerformAttack(caster, true, true, true, false, false)
        caster:SwapAbilities("onimusha_battojutsu_q", "onimusha_dash", false, true)
    end

    if string.len(slashOrder) == 3 then
        print(string.find(1, slashOrder))
        local final_slash = caster:FindAbilityByName("onimusha_battojutsu_r")
        Timers:CreateTimer( 0.15, function()
            if final_slash then caster:CastAbilityImmediately(final_slash, caster:GetPlayerOwnerID()) end
        end)
    end
end

function BattojutsuW( keys )
    local caster = keys.caster
    local ability = keys.ability
    
    local range = battoAbility:GetLevelSpecialValueFor("range", battoAbility:GetLevel() - 1)
    local casterLoc = caster:GetAbsOrigin()
    caster:StartGesture(ACT_DOTA_ATTACK)


    slashOrder = slashOrder .. "W"

     DamageTable = {}
    
        DamageTable.victim = target
        DamageTable.attacker = caster
        DamageTable.damage = caster:GetAttackDamage()
        DamageTable.damage_type = DAMAGE_TYPE_PHYSICAL
        DamageTable.ability = ability

    local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

    if #units > 0 then
        FindClearSpaceForUnit( caster, units[1]:GetAbsOrigin(), true )
        battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
        caster:SetForwardVector((caster:GetOrigin() - units[1]:GetOrigin()):Normalized())
        local casterAngles = caster:GetAngles()
        caster:SetAngles(0, casterAngles.y, casterAngles.z)
        caster:PerformAttack(units[1], true, true, true, false, false)
        caster:SwapAbilities("onimusha_battojutsu_w", "onimusha_guard", false, true)
    else
        FindClearSpaceForUnit( caster, caster:GetAbsOrigin(), true )
        battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
        caster:PerformAttack(caster, true, true, true, false, false)
        caster:SwapAbilities("onimusha_battojutsu_w", "onimusha_guard", false, true)
    end

    if string.len(slashOrder) == 3 then
		print(string.find(0, slashOrder))
        local final_slash = caster:FindAbilityByName("onimusha_battojutsu_r")
        Timers:CreateTimer( 0.15, function()
            if final_slash then caster:CastAbilityImmediately(final_slash, caster:GetPlayerOwnerID()) end
        end)
    end
end

function BattojutsuE( keys )
    local caster = keys.caster
    local ability = keys.ability
    
    local range = battoAbility:GetLevelSpecialValueFor("high_range", battoAbility:GetLevel() - 1)
    local casterLoc = caster:GetAbsOrigin()
    caster:StartGesture(ACT_DOTA_ATTACK)


    slashOrder = slashOrder .. "E"

    DamageTable = {}
    
        DamageTable.victim = target
        DamageTable.attacker = caster
        DamageTable.damage = caster:GetAttackDamage()
        DamageTable.damage_type = DAMAGE_TYPE_PHYSICAL
        DamageTable.ability = ability

    local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

    if #units > 0 then
        FindClearSpaceForUnit( caster, units[1]:GetAbsOrigin(), true )
        battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
        caster:SetForwardVector((caster:GetOrigin() - units[1]:GetOrigin()):Normalized())
        local casterAngles = caster:GetAngles()
        caster:SetAngles(0, casterAngles.y, casterAngles.z)
        caster:PerformAttack(units[1], true, true, true, false, false)
        caster:SwapAbilities("onimusha_battojutsu_e", "onimusha_orochi", false, true)
    else
        FindClearSpaceForUnit( caster, caster:GetAbsOrigin(), true )
        battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
        caster:PerformAttack(caster, true, true, true, false, false)
        caster:SwapAbilities("onimusha_battojutsu_e", "onimusha_orochi", false, true)
    end

    if string.len(slashOrder) == 3 then
		print(string.find(0, slashOrder))
        local final_slash = caster:FindAbilityByName("onimusha_battojutsu_r")
        Timers:CreateTimer( 0.15, function()
            if final_slash then caster:CastAbilityImmediately(final_slash, caster:GetPlayerOwnerID()) end
        end)
    end
end

function BattojutsuR( keys )
    local caster = keys.caster
    local ability = keys.ability
    local range = battoAbility:GetLevelSpecialValueFor("range", battoAbility:GetLevel() - 1)
    local highRange = battoAbility:GetLevelSpecialValueFor("high_range", battoAbility:GetLevel() - 1)
    local casterLoc = caster:GetAbsOrigin()
    caster:StartGesture(ACT_DOTA_ATTACK)

	
	print(slashOrder)


    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local maimDuration = ability:GetLevelSpecialValueFor("maim_duration", ability:GetLevel() - 1)
    local stunDuration = ability:GetLevelSpecialValueFor("stun_duration", ability:GetLevel() - 1)
    local blindDuration = ability:GetLevelSpecialValueFor("blind_duration", ability:GetLevel() - 1)

    caster:RemoveModifierByName("modifier_battojutsu_attack")
    

    DamageTable = {}
    
        DamageTable.victim = target
        DamageTable.attacker = caster
        DamageTable.damage = caster:GetAttackDamage()
        DamageTable.damage_type = DAMAGE_TYPE_PHYSICAL
        DamageTable.ability = ability

    if slashOrder == "QWE" then

        local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

        if #units > 0 then
            DamageTable.victim = units[1]
            caster:SetForwardVector((units[1]:GetOrigin() - caster:GetOrigin()):Normalized())
            local casterAngles = caster:GetAngles()
            caster:SetAngles(0, casterAngles.y, casterAngles.z)
            DamageTable.damage_type = DAMAGE_TYPE_PURE
            ability:ApplyDataDrivenModifier(caster, units[1], "modifier_hirameki", {Duration = 0.1})
            ApplyDamage(DamageTable)
            if units[1]:GetHealthPercent() < 7.5 and units[1]:IsAlive() then
                caster:PerformAttack(units[1], true, true, true, false, false)
                if units[1]:IsAlive() then
                    units[1]:Kill(ability, caster)
                end
            end
        else
            DamageTable.victim = caster
            DamageTable.damage_type = DAMAGE_TYPE_PURE
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_hirameki", {Duration = 0.1})
            ApplyDamage(DamageTable)
            if caster:GetHealthPercent() < 7.5 and caster:IsAlive() then
                caster:PerformAttack(caster, true, true, true, false, false)
                if caster:IsAlive() then
                    caster:Kill(ability, caster)
                end
            end
        end

    elseif slashOrder == "QEW" then
        battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_final_strike_b", {Duration = 0.1})
        local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

        if #units > 0 then
            local targets = FindUnitsInRadius(caster:GetTeam(), units[1]:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
            FindClearSpaceForUnit( caster, units[1]:GetAbsOrigin(), false )
            caster:SetForwardVector((units[1]:GetOrigin() - caster:GetOrigin()):Normalized())
            local casterAngles = caster:GetAngles()
            caster:SetAngles(0, casterAngles.y, casterAngles.z)
            caster:PerformAttack(units[1], true, true, true, false, false)
            ability:ApplyDataDrivenModifier(caster, units[1], "modifier_ryukansen", {Duration = maimDuration})
            for i = 1, #targets do
                if targets[i] ~= units[i] then
                    DamageTable.victim = targets[i]
                    ApplyDamage(DamageTable)
                    ability:ApplyDataDrivenModifier(caster, targets[i], "modifier_ryukansen", {Duration = maimDuration})
                end
            end
        else
            local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

            caster:PerformAttack(caster, true, true, true, false, false)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_ryukansen", {Duration = maimDuration})
            for i = 1, #targets do
                if targets[i] ~= caster then
                    DamageTable.victim = targets[i]
                    ApplyDamage(DamageTable)
                    ability:ApplyDataDrivenModifier(caster, targets[i], "modifier_ryukansen", {Duration = maimDuration})
                end
            end
        end

    elseif slashOrder == "WQE" then
        battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_final_strike_c", {Duration = 0.1})
        local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

        if #units > 0 then
            FindClearSpaceForUnit( caster, units[1]:GetAbsOrigin(), false )
            caster:SetForwardVector((units[1]:GetOrigin() - caster:GetOrigin()):Normalized())
            local casterAngles = caster:GetAngles()
            caster:SetAngles(0, casterAngles.y, casterAngles.z)
            caster:PerformAttack(units[1], true, true, true, false, false)
            ability:ApplyDataDrivenModifier(caster, units[1], "modifier_ryumeisen", {Duration = stunDuration})
        else
            FindClearSpaceForUnit( caster, caster:GetAbsOrigin(), false )
            caster:PerformAttack(caster, true, true, true, false, false)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_ryumeisen", {Duration = stunDuration})
        end

    elseif slashOrder == "WEQ" then
        battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_final_strike_d", {Duration = 0.1})
        local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

        if #units > 0 then
            FindClearSpaceForUnit( caster, units[1]:GetAbsOrigin(), false )
            caster:SetForwardVector((units[1]:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
            local casterAngles = caster:GetAngles()
            caster:SetAngles(0, casterAngles.y, casterAngles.z)
            caster:PerformAttack(units[1], true, true, true, false, false)
            ability:ApplyDataDrivenModifier(caster, units[1], "modifier_rairyusen", {Duration = blindDuration})
            local targets = FindUnitsInRadius(caster:GetTeam(), units[1]:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

            for i = 1, #targets do
                DamageTable.victim = targets[i]
                ability:ApplyDataDrivenModifier(caster, targets[i], "modifier_rairyusen", {Duration = blindDuration})
            end
        else
            FindClearSpaceForUnit( caster, caster:GetAbsOrigin(), false )
            caster:PerformAttack(caster, true, true, true, false, false)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_rairyusen", {Duration = blindDuration})
            local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

            for i = 1, #targets do
                DamageTable.victim = targets[i]
                ability:ApplyDataDrivenModifier(caster, targets[i], "modifier_rairyusen", {Duration = blindDuration})
            end
        end

    elseif slashOrder == "EQW" then
        battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_final_strike_e", {Duration = 0.1})
        local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, highRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

        if #units > 0 then
            FindClearSpaceForUnit( caster, units[1]:GetAbsOrigin(), false )
            caster:SetForwardVector((units[1]:GetOrigin() - caster:GetOrigin()):Normalized())
            local casterAngles = caster:GetAngles()
            caster:SetAngles(0, casterAngles.y, casterAngles.z)
            caster:PerformAttack(units[1], true, true, true, false, false)
        else
            FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false )
            caster:PerformAttack(caster, true, true, true, false, false)
        end

    elseif slashOrder == "EWQ" then
        battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_final_strike_f", {Duration = 0.1})
        local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, highRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

        if #units > 0 then
            caster:SetForwardVector((units[1]:GetOrigin() - caster:GetOrigin()):Normalized())
            local casterAngles = caster:GetAngles()
            caster:SetAngles(0, casterAngles.y, casterAngles.z)
            caster:PerformAttack(units[1], true, true, true, false, false)
        else
            caster:PerformAttack(caster, true, true, true, false, false)
        end
    end

    caster:RemoveModifierByName("modifier_battojutsu")
    slashOrder = ""
end