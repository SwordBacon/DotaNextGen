function aura( keys )
  local target = keys.target
  if target:GetMaxMana() == 0 then return end 
  local ability = keys.ability
  local targetmana = 100 - target:GetManaPercent()
  local resistance_loss = keys.resistance_loss
  local stacks = math.floor(targetmana/10) - 1
 
  if not target:HasModifier(resistance_loss) then 
    ability:ApplyDataDrivenModifier(target, target, resistance_loss, {})
  end
  target:SetModifierStackCount(resistance_loss, ability, stacks)

end