local HVH = {
    Enabled = false,
    Stomping = false,
    LastHealth = nil,
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "Auto Heal",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then
            HVH.Stomping = false
            HVH.LastHealth = nil
        end
    end
})

CombatAutoKill:AddSlider('AutoHealThreshold', {
    Text = "Health %",
    Min = 1,
    Max = 100,
    Default = 50,
    Rounding = 0,
    Callback = function(Value)
        getgenv().HVHHealthThreshold = Value
    end
})

local mainevent = ReplicatedStorage:WaitForChild("MainEvent")

local function GetKOTarget()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local c = p.Character
            local b = c and c:FindFirstChild("BodyEffects")
            local ko = b and b:FindFirstChild("K.O")
            local dead = b and b:FindFirstChild("Dead")
            if ko and ko.Value and dead and not dead.Value then
                return p
            end
        end
    end
end

local function IsStillKOd(player)
    if not player or not player.Character then return false end
    local be = player.Character:FindFirstChild("BodyEffects")
    if not be then return false end
    local ko = be:FindFirstChild("K.O")
    local dead = be:FindFirstChild("Dead")
    return ko and ko.Value and (not dead or not dead.Value)
end

RunService.Heartbeat:Connect(function()
    if not HVH.Enabled or HVH.Stomping then return end
    if not AutoKill.Enabled then return end
    if AutoKill.GunMethod.StompRunning then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local hp = hum.Health
    local maxHp = hum.MaxHealth
    if maxHp <= 0 then return end

    local pct = (hp / maxHp) * 100
    local lastHp = HVH.LastHealth
    HVH.LastHealth = hp

    if pct >= (getgenv().HVHHealthThreshold or 75) then return end
    if not lastHp then return end
    if hp >= lastHp then return end
    if hp <= 0 then return end

    local target = GetKOTarget()
    if not target then return end

    HVH.Stomping = true

    task.spawn(function()
        -- AutoStomp cancels if AutoKill.Target ~= target, so set it temporarily
        local originalTarget = AutoKill.Target
        AutoKill.Target = target
        AutoKill.AutoStomp(target)

        -- wait for stomp to finish
        local timeout = tick() + 10
        while AutoKill.GunMethod.StompRunning and tick() < timeout do
            task.wait(0.05)
        end

        -- restore original target
        AutoKill.Target = originalTarget

        HVH.Stomping = false
        HVH.LastHealth = nil
    end)
end)
