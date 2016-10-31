modifier_static_charge = class({})

function modifier_static_charge:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, 
	}
	return funcs
end

function modifier_static_charge:OnAttackLanded(event)
	if not IsServer() then return end
    --PrintTable(event)
    local attacker = self:GetCaster()
    local target = event.target
    if event.attacker ~= attacker then return end
    --DeepPrintTable(event)
    
	local ability = self:GetCaster():FindAbilityByName("alpha_strider_static_charge_lua")
	local modifierName = "modifier_static_charge_slow"
	local stackCount = self:GetStackCount()
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)

	target:AddNewModifier(attacker, ability, modifierName, {Duration = duration})
	target:SetModifierStackCount(modifierName, attacker, stackCount)
	if stackCount >= 5 then 
		target:AddNewModifier(attacker, nil, "modifier_stunned", {Duration = duration})
	end
	CalculateDamage(attacker, target, math.floor(self:GetModifierProcAttack_BonusDamage_Magical(event)), DAMAGE_TYPE_MAGICAL)
	attacker:RemoveModifierByName("modifier_static_charge") 
	EmitSoundOn("Hero_Leshrac.Lightning_Storm", target)
	particle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
    --shared control points for all the different lightnings
    ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,1000)) -- height of the bolt
    ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- point landing
    ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin()) -- point origin  
	self:Destroy()
end

function modifier_static_charge:GetModifierProcAttack_BonusDamage_Magical(keys)
	local stacks = self:GetStackCount()
	local damage = self:GetParent():FindAbilityByName("alpha_strider_static_charge_lua"):GetAbilityDamage()
	if keys.target:IsBuilding() then
		damage = damage / 2
	end
	return stacks * damage
end

function modifier_static_charge:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function CalculateDamage( caster, target, amount, damageType )
	if damageType == DAMAGE_TYPE_MAGICAL then
        amount = amount - (amount * target:GetMagicalArmorValue())
    elseif damageType == DAMAGE_TYPE_PHYSICAL then
        amount = amount - (amount * target:GetPhysicalArmorValue())
    end


    local lens_count = 0
    for i=0,5 do
        local item = caster:GetItemInSlot(i)
        if item ~= nil and item:GetName() == "item_aether_lens" then
            lens_count = lens_count + 1
        end
    end
    amount = amount * (1 + (.05 * lens_count) + ( .01 * caster:GetIntellect() / 16 ))

    PopupNumbers(target, "damage", Vector(77, 200, 255), 2.0, math.floor(amount), nil, POPUP_SYMBOL_POST_LIGHTNING)
end