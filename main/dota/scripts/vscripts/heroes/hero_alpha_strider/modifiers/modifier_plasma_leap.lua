modifier_plasma_leap = class({})

function modifier_plasma_leap:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true
    }

    return state
end