function ThrillInitialize( keys )
	local caster = keys.caster
	local ability = keys.ability
	if not caster:IsIllusion() then
		caster:RemoveModifierByName("modifier_thrill_camera_plus")
		caster:RemoveModifierByName("modifier_thrill_camera_minus")

		caster_altitude = 0
		camera_distance = 1200
		view_distance = ability:GetLevelSpecialValueFor("bonus_camera_view", (ability:GetLevel() - 1))
		day_vision = 1800
		night_vision = 800
		bonus_vision = ability:GetLevelSpecialValueFor("bonus_vision", (ability:GetLevel() - 1))
		GameRules:GetGameModeEntity():SetCameraDistanceOverride( camera_distance )
		caster:SetDayTimeVisionRange(day_vision)
		caster:SetNightTimeVisionRange(night_vision)
	end

end

function ThrillCameraCheck( keys )
	local caster = keys.caster
	local ability = keys.ability
	if not caster:IsIllusion() then
		local altitude = GetGroundHeight(caster:GetAbsOrigin(), caster)
	
		while altitude > caster_altitude and altitude % 128 == 0 do
			caster_altitude = caster_altitude + 128
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_thrill_camera_plus", {duration = 1.5})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_thrill_bonus_vision", {})
		end
		while altitude < caster_altitude and altitude % 128 == 0 do
			caster_altitude = caster_altitude - 128
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_thrill_camera_minus", {duration = 1.5})
			caster:RemoveModifierByName("modifier_thrill_bonus_vision")
		end
	end
end

function ThrillCameraPlus( keys )
	local caster = keys.caster
	camera_distance = camera_distance + (view_distance/50)
	GameRules:GetGameModeEntity():SetCameraDistanceOverride( camera_distance )
end

function ThrillCameraMinus( keys )
	local caster = keys.caster
	camera_distance = camera_distance - (view_distance/50)
	GameRules:GetGameModeEntity():SetCameraDistanceOverride( camera_distance )
end

function ThrillCastPointBonus( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability1 = caster:GetAbilityByIndex(0)
	local ability2 = caster:GetAbilityByIndex(1)
	
	ability1:SetOverrideCastPoint(0.075)
	ability2:SetOverrideCastPoint(0.075)

	EmitGlobalSound("Hero_Veera.Thrill.Drums")

	caster:AddNewModifier(caster, ability, 'modifier_movespeed_cap', {Duration = 20} )
end

function ThrillRemoveBonus( keys )
	local caster = keys.caster
	local ability1 = caster:GetAbilityByIndex(0)
	local ability2 = caster:GetAbilityByIndex(1)
	
	ability1:SetOverrideCastPoint(0.15)
	ability2:SetOverrideCastPoint(0.15)
end

modifier_movespeed_cap = class({})
LinkLuaModifier("modifier_movespeed_cap", "heroes/hero_veera/thrill_of_the_hunt", LUA_MODIFIER_MOTION_NONE)

function modifier_movespeed_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_movespeed_cap:GetModifierMoveSpeed_Max( params )
    return 2000
end

function modifier_movespeed_cap:GetModifierMoveSpeed_Limit( params )
    return 2000
end

function modifier_movespeed_cap:IsHidden()
    return true
end