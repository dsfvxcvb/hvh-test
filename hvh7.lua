local HVH = {
    Enabled = false,
    Stomping = false,
    LastHealth = nil,
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then
            HVH.Stomping = false
            HVH.LastHealth = nil
        end
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

local function RunStomp(target)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local tc = target.Character
    if not tc then return end
    local ut = tc:FindFirstChild("UpperTorso")
    if not ut then return end

    local returnCF = hrp.CFrame

    -- Pause AutoKill briefly
    local wasEnabled = AutoKill.Enabled
    AutoKill.Enabled = false
    AutoKill.StopCycle()
    if getgenv().AutoStompState then
        getgenv().AutoStompState.autostomp = false
    end

    -- Exact same method as the working autostomp, looped until confirmed or 8s timeout
    local timeout = tick() + 8
    while tick() < timeout and IsStillKOd(target) do
        hum.Sit = false
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hrp.Velocity = Vector3.zero
        hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
        RunService.RenderStepped:Wait()
        for _ = 1, 5 do
            pcall(function() mainevent:FireServer("Stomp") end)
        end
        hrp.CFrame = returnCF
    end

    local success = not IsStillKOd(target)
    print(string.format("[HVH] Stomp on %s: %s", target.Name, success and "✅" or "❌ timed out"))

    -- Return to position
    hrp.CFrame = returnCF

    -- Resume AutoKill
    if wasEnabled then
        AutoKill.Enabled = true
        if AutoKill.Target or AutoKill.HasSelectedTargets() then
            AutoKill.StartCycle()
        end
    end
end

-- Watch for health drops and stomp immediately each time
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

    -- Trigger whenever health drops below 75 (catches every hit)
    local lastHp = HVH.LastHealth
    HVH.LastHealth = hp

    if pct >= 75 then return end          -- above threshold, do nothing
    if not lastHp then return end          -- no previous reading
    if hp >= lastHp then return end        -- health went up or stayed same, not a hit
    if hp <= 0 then return end             -- already dead

    -- Health dropped below 75 — stomp immediately
    local target = GetKOTarget()
    if not target then return end

    HVH.Stomping = true
    print(string.format("[HVH] HP dropped to %d%%, stomping %s", math.floor(pct), target.Name))

    task.spawn(function()
        RunStomp(target)
        HVH.Stomping = false
        -- Reset so next hit triggers again
        HVH.LastHealth = nil
    end)
end)

print("[HVH] Loaded - triggers on every health drop below 75%, stomps immediately")
print("niccer")
