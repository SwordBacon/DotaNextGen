function LevelUpAbility( keys )
	local caster = keys.caster
	local ability = keys.ability
	local abilitylevel = ability:GetLevel()

	ability1 = caster:FindAbilityByName("onimusha_battojutsu_q")
	ability2 = caster:FindAbilityByName("onimusha_battojutsu_w")
	ability3 = caster:FindAbilityByName("onimusha_battojutsu_e")
	ability4 = caster:FindAbilityByName("onimusha_battojutsu_r")

	ability1:SetLevel(abilitylevel)
	ability2:SetLevel(abilitylevel)
	ability3:SetLevel(abilitylevel)
	ability4:SetLevel(abilitylevel)
end

function SwapBasicAbilities(keys)
	local caster = keys.caster
	caster.battoAbility = caster:FindAbilityByName("onimusha_battojutsu")
	
	caster:SwapAbilities("onimusha_dash", "onimusha_battojutsu_q", false, true)
	caster:SwapAbilities("onimusha_guard", "onimusha_battojutsu_w", false, true)
	caster:SwapAbilities("onimusha_orochi", "onimusha_battojutsu_e", false, true)

	slashOrder = ""
	finalSlash = true
end

function SwapUltimateAbilities(keys)
	local caster = keys.caster
	local ability = caster:FindAbilityByName("onimusha_battojutsu")
	if not ability then return end
	local battoDuration = ability:GetSpecialValueFor("duration")
	if combos == nil then combos = {} end

	if caster:HasModifier("modifier_battojutsu") then
		local combo_limit = ability:GetSpecialValueFor("combos")
		if caster:HasScepter() then combo_limit = ability:GetSpecialValueFor("combos_scepter") end

		if #combos < combo_limit - 1 then 
			for _,k in pairs(combos) do
				if slashOrder == k then
					slashOrder = ""
					caster:RemoveModifierByName("modifier_battojutsu")
					combos = {}
					SwapUltimateAbilities(keys)
					break
				end
			end
		else
			slashOrder = ""
			caster:RemoveModifierByName("modifier_battojutsu")
			combos = {}
			SwapUltimateAbilities(keys)
			return
		end
		if caster:HasModifier("modifier_battojutsu") and string.len(slashOrder) == 3 then
			table.insert(combos, slashOrder)
			SwapBasicAbilities(keys)
			caster:EmitSound("DOTA_Item.Refresher.Activate")
			caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_combo", {Duration = 0.1})
			caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu", {Duration = battoDuration})
		end
		slashOrder = ""
	elseif string.len(slashOrder) ~= 3 then
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
		combos = {}
		caster:RemoveModifierByName("modifier_battojutsu")
	end
end

function CheckForUniqueCombos( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName("onimusha_battojutsu")
	if combos == nil then combos = {} end

	for _,k in pairs(combos) do
		if slashOrder == k then
			slashOrder = ""
			caster:RemoveModifierByName("modifier_battojutsu")
			combos = {}
			SwapUltimateAbilities(keys)
			finalSlash = false
			break
		end
	end
end

function BattojutsuQ( keys )
	local caster = keys.caster
	local ability = keys.ability

	local range = caster.battoAbility:GetLevelSpecialValueFor("range", caster.battoAbility:GetLevel() - 1)
	local casterLoc = caster:GetAbsOrigin()
	caster:StartGesture(ACT_DOTA_ATTACK)
	caster:RemoveModifierByName("modifier_show_dash")
	caster:RemoveModifierByName("modifier_hide_dash")

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
		caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
		caster:SetForwardVector((caster:GetOrigin() - units[1]:GetOrigin()):Normalized())
		local casterAngles = caster:GetAngles()
		caster:SetAngles(0, casterAngles.y, casterAngles.z)
		caster:PerformAttack(units[1], true, false, true, false, false)
		caster:SwapAbilities("onimusha_battojutsu_q", "onimusha_dash", false, true)
	else
		FindClearSpaceForUnit( caster, caster:GetAbsOrigin(), true )
		caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
		caster:PerformAttack(caster, true, false, true, false, false)
		caster:SwapAbilities("onimusha_battojutsu_q", "onimusha_dash", false, true)
	end

	if string.len(slashOrder) == 3 then
		local final_slash = caster:FindAbilityByName("onimusha_battojutsu_r")
		CheckForUniqueCombos(keys)
		Timers:CreateTimer( 0.15, function()
			if final_slash and finalSlash then caster:CastAbilityImmediately(final_slash, caster:GetPlayerOwnerID()) end
		end)
	end
end

function BattojutsuW( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	local range = caster.battoAbility:GetLevelSpecialValueFor("range", caster.battoAbility:GetLevel() - 1)
	local casterLoc = caster:GetAbsOrigin()
	caster:StartGesture(ACT_DOTA_ATTACK)
	caster:RemoveModifierByName("modifier_show_dash")
	caster:RemoveModifierByName("modifier_hide_dash")


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
		caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
		caster:SetForwardVector((caster:GetOrigin() - units[1]:GetOrigin()):Normalized())
		local casterAngles = caster:GetAngles()
		caster:SetAngles(0, casterAngles.y, casterAngles.z)
		caster:PerformAttack(units[1], true, false, true, false, false)
		caster:SwapAbilities("onimusha_battojutsu_w", "onimusha_guard", false, true)
	else
		FindClearSpaceForUnit( caster, caster:GetAbsOrigin(), true )
		caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
		caster:PerformAttack(caster, true, false, true, false, false)
		caster:SwapAbilities("onimusha_battojutsu_w", "onimusha_guard", false, true)
	end

	if string.len(slashOrder) == 3 then
		local final_slash = caster:FindAbilityByName("onimusha_battojutsu_r")
		CheckForUniqueCombos(keys)
		Timers:CreateTimer( 0.15, function()
			if final_slash and finalSlash then caster:CastAbilityImmediately(final_slash, caster:GetPlayerOwnerID()) end
		end)
	end
end

function BattojutsuE( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	local range = caster.battoAbility:GetLevelSpecialValueFor("range", caster.battoAbility:GetLevel() - 1)
	local casterLoc = caster:GetAbsOrigin()
	caster:StartGesture(ACT_DOTA_ATTACK)
	caster:RemoveModifierByName("modifier_show_dash")
	caster:RemoveModifierByName("modifier_hide_dash")


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
		caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
		caster:SetForwardVector((caster:GetOrigin() - units[1]:GetOrigin()):Normalized())
		local casterAngles = caster:GetAngles()
		caster:SetAngles(0, casterAngles.y, casterAngles.z)
		caster:PerformAttack(units[1], true, false, true, false, false)
		caster:SwapAbilities("onimusha_battojutsu_e", "onimusha_orochi", false, true)
	else
		FindClearSpaceForUnit( caster, caster:GetAbsOrigin(), true )
		caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_attack", {Duration = 0.1})
		caster:PerformAttack(caster, true, false, true, false, false)
		caster:SwapAbilities("onimusha_battojutsu_e", "onimusha_orochi", false, true)
	end

	if string.len(slashOrder) == 3 then
		local final_slash = caster:FindAbilityByName("onimusha_battojutsu_r")
		CheckForUniqueCombos(keys)
		Timers:CreateTimer( 0.15, function()
			if final_slash and finalSlash then caster:CastAbilityImmediately(final_slash, caster:GetPlayerOwnerID()) end
		end)
	end
end

function BattojutsuR( keys )
	local caster = keys.caster
	local ability = keys.ability
	local range = caster.battoAbility:GetLevelSpecialValueFor("range", caster.battoAbility:GetLevel() - 1)
	local highRange = caster.battoAbility:GetLevelSpecialValueFor("high_range", caster.battoAbility:GetLevel() - 1)
	local casterLoc = caster:GetAbsOrigin()
	caster:RemoveModifierByName("modifier_show_dash")
	caster:RemoveModifierByName("modifier_hide_dash")
	caster:StartGesture(ACT_DOTA_ATTACK)

	local radius = ability:GetSpecialValueFor("radius")
	local maimDuration = ability:GetLevelSpecialValueFor("maim_duration", ability:GetLevel() - 1)
	local stunDuration = ability:GetLevelSpecialValueFor("stun_duration", ability:GetLevel() - 1)
	local blindDuration = ability:GetLevelSpecialValueFor("blind_duration", ability:GetLevel() - 1)

	caster:RemoveModifierByName("modifier_battojutsu_attack")
	

	DamageTable = {}
	
	DamageTable.victim = target
	DamageTable.attacker = caster
	DamageTable.damage = caster:GetAverageTrueAttackDamage(target)
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
			units[1]:EmitSound("Hero_Invoker.SunStrike.Ignite")
			local particle = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf",PATTACH_ABSORIGIN_FOLLOW,units[1])
			ApplyDamage(DamageTable)
			if units[1]:GetHealthPercent() < 7.5 and units[1]:IsAlive() then
				units[1]:Kill(ability, caster)
			end
		else
			DamageTable.victim = caster
			DamageTable.damage_type = DAMAGE_TYPE_PURE
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_hirameki", {Duration = 0.1})
			caster:EmitSound("Hero_Invoker.SunStrike.Ignite")
			local particle = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
			ApplyDamage(DamageTable)

			if caster:GetHealthPercent() < 7.5 and caster:IsAlive() then
				caster:Kill(ability, caster)
			end
		end

	elseif slashOrder == "QEW" then
		caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_final_strike_b", {Duration = 0.1})
		local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + 
			DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

		if #units > 0 then
			local targets = FindUnitsInRadius(caster:GetTeam(), units[1]:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
			FindClearSpaceForUnit( caster, units[1]:GetAbsOrigin(), false )
			caster:SetForwardVector((units[1]:GetOrigin() - caster:GetOrigin()):Normalized())
			local casterAngles = caster:GetAngles()
			caster:SetAngles(0, casterAngles.y, casterAngles.z)
			local particle = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf",PATTACH_ABSORIGIN_FOLLOW,units[1])
			caster:PerformAttack(units[1], true, true, true, false, false)
			ability:ApplyDataDrivenModifier(caster, units[1], "modifier_ryukansen", {Duration = maimDuration})
			for i = 1, #targets do
				if targets[i] ~= units[1] then
					DamageTable.victim = targets[i]
					DamageTable.damage = caster:GetAverageTrueAttackDamage(targets[i])
					local particle = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf",PATTACH_ABSORIGIN_FOLLOW,targets[i])
					ApplyDamage(DamageTable)
					ability:ApplyDataDrivenModifier(caster, targets[i], "modifier_ryukansen", {Duration = maimDuration})
				end
			end
		else
			local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
			local particle = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
			caster:PerformAttack(caster, true, true, true, false, false)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_ryukansen", {Duration = maimDuration})
			for i = 1, #targets do
				if targets[i] ~= caster then
					DamageTable.victim = targets[i]
					local particle = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf",PATTACH_ABSORIGIN_FOLLOW,targets[i])
					ApplyDamage(DamageTable)
					ability:ApplyDataDrivenModifier(caster, targets[i], "modifier_ryukansen", {Duration = maimDuration})
				end
			end
		end

	elseif slashOrder == "WQE" then
		caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_final_strike_c", {Duration = 0.1})
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
		caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_final_strike_d", {Duration = 0.1})
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
		caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_final_strike_e", {Duration = 0.1})
		local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, highRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_FARTHEST, false)

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
		caster.battoAbility:ApplyDataDrivenModifier(caster, caster, "modifier_battojutsu_final_strike_f", {Duration = 0.1})
		local units = FindUnitsInRadius(caster:GetTeam(), casterLoc, nil, highRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_FARTHEST, false)

		if #units > 0 then
		local projectile = {
            Target = units[1],
            Source = caster,
            Ability = ability,
            EffectName = "particles/units/heroes/hero_visage/visage_soul_assumption_bolt6.vpcf",
            bDodgable = true,
            bProvidesVision = false,
            iMoveSpeed = 1400,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
        }
        ProjectileManager:CreateTrackingProjectile(projectile)
		caster:SetForwardVector((units[1]:GetOrigin() - caster:GetOrigin()):Normalized())
		local casterAngles = caster:GetAngles()
		caster:EmitSound("Hero_Visage.SoulAssumption.Cast")
		caster:SetAngles(0, casterAngles.y, casterAngles.z)
		--caster:PerformAttack(units[1], true, true, true, false, true)
		else
			caster:PerformAttack(caster, true, true, true, false, true)
		end
	end
	SwapUltimateAbilities( keys )
end

function HiryusenStrike( keys )
	local caster = keys.caster
	local unit = keys.target

	caster:PerformAttack(unit, true, true, true, false, false)
	caster:RemoveModifierByName("modifier_hiryusen")
end