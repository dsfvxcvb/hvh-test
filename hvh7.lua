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
    print(string.format("[HVH] HP dropped to %d%%, stomping %s", math.floor(pct), target.Name))

    task.spawn(function()
        -- use the exact same spoofed autostomp that autokill uses
        local state = getgenv().AutoStompState
        if state and not state.running then
            local originalTarget = Targeting.Target
            Targeting.Target = target
            state.autostomp = true
            getgenv().AutoStompLoop()
            -- wait for stomp to complete or target to no longer be KO'd
            local timeout = tick() + 8
            while state.running and tick() < timeout do
                if not IsStillKOd(target) then
                    state.autostomp = false
                end
                task.wait(0.05)
            end
            state.autostomp = false
            Targeting.Target = originalTarget
        end
        HVH.Stomping = false
        HVH.LastHealth = nil
        print(string.format("[HVH] Stomp on %s: %s", target.Name, not IsStillKOd(target) and "✅" or "❌ timed out"))
    end)
end)

print("[HVH] Loaded - triggers on every health drop below 75%, stomps immediately")
print("niccer")
print("Clav rhinoplasty")
