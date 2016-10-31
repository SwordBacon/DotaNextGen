LinkLuaModifier( "modifier_pocket_xarax", "heroes/hero_xarax/modifiers/modifier_pocket_xarax.lua" ,LUA_MODIFIER_MOTION_NONE )

function ShareTricks( keys )
	local caster = keys.caster
	ability = keys.ability
	local player = caster:GetPlayerOwner()
	local pID = caster:GetPlayerOwnerID()

	if not caster:HasScepter() then
		for i=0, 4 do
			local ability = caster:GetAbilityByIndex(i)
			local ability_name = ability:GetName()
			local ability_level = ability:GetLevel()
			if ability_level > 0 then
				local item_name = "item_" .. ability_name
				local position = caster:GetAbsOrigin()
				local newItem = CreateItem( item_name, caster, caster )
				newItem:SetPurchaseTime( 0 )
				newItem:SetLevel(ability_level)
				local drop = CreateItemOnPositionSync( position , newItem)
				if drop then
					drop:SetContainedItem( newItem )
					newItem:LaunchLoot( false, 200, 0.35, position + RandomVector( RandomFloat( 30, 300 ) ) )
					Timers:CreateTimer(60, function()
						if not newItem:IsNull() then
							newItem:Kill()
							if not drop:IsNull() then drop:Kill() end
						end
					end)
				end
			end
		end
	else
		local item_name = "item_xarax_pocket"
		local position = caster:GetAbsOrigin()
		local newItem = CreateItem( item_name, caster, caster )

		owner = newItem:GetOwner()
		newItem:SetPurchaseTime( 0 )
		local drop = CreateItemOnPositionSync( position, newItem)
		if drop then
			drop:SetContainedItem( newItem )
			newItem:LaunchLoot( false, 200, 0.35, position + RandomVector( RandomFloat( 30, 300 ) ) )
			Timers:CreateTimer(60, function()
				if not newItem:IsNull() then
					newItem:Kill()
					if drop then drop:Kill() end
				end
			end)
		end
	end
end

function PocketXarax(keys)
	local caster = keys.caster
	local target = keys.target
	local item = keys.ability
	local ability = owner:FindAbilityByName("xarax_share_tricks")
	print(owner:GetName())

	caster.xarax_table = {}
	caster.pocket_xarax = CreateUnitByName( owner:GetUnitName(), caster:GetAbsOrigin(), false, caster, caster:GetOwner(), caster:GetTeamNumber())
	table.insert(caster.pocket_xarax, caster.xarax_table)
	caster.pocket_xarax:AddNewModifier(caster, ability, "modifier_pocket_xarax", {duration = -1})
	ability:ApplyDataDrivenModifier(caster, caster.pocket_xarax, "modifier_pocket_xarax_expire", {duration = 60})
	--ability:ApplyDataDrivenModifier(caster, target, "Nexus_Sync_Casts", {duration = -1})
	caster.pocket_xarax:SetControllableByPlayer(caster:GetPlayerID(), false)
	caster.pocket_xarax:SetModelScale(0.4)
	--caster.pocket_xarax:MakeIllusion()

	local caster_level = caster:GetLevel()
	for i = 2, caster_level do
		caster.pocket_xarax:HeroLevelUp(false)
	end
	for ability_id = 0, 15 do
		local ability = caster.pocket_xarax:GetAbilityByIndex(ability_id)
		if ability and ability:GetName() ~= "attribute_bonus" then
			caster.pocket_xarax:RemoveAbility(ability:GetName())
		end
	end
	for item_id = 0, 4 do
		local ability = owner:GetAbilityByIndex(item_id)
		local ability_name = ability:GetName()
		local ability_level = ability:GetLevel()
		if ability_level > 0 then
			local item_name = "item_" .. ability_name
			local newItem = CreateItem( item_name, caster, caster )
			newItem:SetPurchaseTime( 0 )
			newItem:SetLevel(ability_level)
			caster.pocket_xarax:AddItem(newItem)
		end
	end
	caster.pocket_xarax:SetAbilityPoints(0)
	caster.pocket_xarax:SetHasInventory(true)

end

function PocketXaraxDamage( keys )
	local target = keys.unit
	if target:GetHealth() < 0.6 then
		target:MakeIllusion()
		target:ForceKill(false)
	end
end

function PocketXaraxExpire( keys )
	local target = keys.target
	target:MakeIllusion()
	target:ForceKill(false)
end