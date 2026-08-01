local HVH = { 
    Enabled = false, 
    Running = false,
    OriginalTarget = nil,
    Cooldown = 0,
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then 
            HVH.Running = false
            HVH.OriginalTarget = nil
        end
    end
})

local mainevent = ReplicatedStorage:WaitForChild("MainEvent")

local function GetAllKOTargets()
    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local c = p.Character
            local b = c and c:FindFirstChild("BodyEffects")
            local ko = b and b:FindFirstChild("K.O")
            local dead = b and b:FindFirstChild("Dead")
            if ko and ko.Value and dead and not dead.Value then
                table.insert(targets, p)
            end
        end
    end
    return targets
end

local function IsStillKOd(player)
    if not player or not player.Character then return false end
    local be = player.Character:FindFirstChild("BodyEffects")
    if not be then return false end
    local ko = be:FindFirstChild("K.O")
    local dead = be:FindFirstChild("Dead")
    return ko and ko.Value and (not dead or not dead.Value)
end

-- Mirrors the working autostomp exactly:
-- teleport to UpperTorso+3.5, wait RenderStepped, fire 5 stomps, return
local function DoStompCycle(hrp, hum, target, returnCFrame)
    local tc = target.Character
    if not tc then return end
    local ut = tc:FindFirstChild("UpperTorso")
    if not ut then return end

    hum.Sit = false
    hum.PlatformStand = false
    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    hrp.Velocity = Vector3.zero
    hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))

    RunService.RenderStepped:Wait()

    for _ = 1, 5 do
        pcall(function() mainevent:FireServer("Stomp") end)
    end

    hrp.CFrame = returnCFrame
end

task.spawn(function()
    while true do
        task.wait(0.1)

        if tick() < HVH.Cooldown then continue end
        if not HVH.Enabled or HVH.Running then continue end
        if not AutoKill.Enabled then continue end

        local char = LocalPlayer.Character
        if not char then continue end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then continue end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        if healthPercent > 75 then continue end

        local koTargets = GetAllKOTargets()
        if #koTargets == 0 then continue end

        print(string.format("[HVH] HP: %d%%, Found %d KO targets", math.floor(healthPercent), #koTargets))

        HVH.Running = true
        HVH.OriginalTarget = AutoKill.Target

        -- Stop AutoKill cleanly
        AutoKill.Enabled = false
        AutoKill.StopCycle()
        if getgenv().AutoStompState then
            getgenv().AutoStompState.autostomp = false
        end
        task.wait(0.2)

        -- Save return position
        local returnCFrame = hrp.CFrame

        -- Shuffle targets
        for i = #koTargets, 2, -1 do
            local j = math.random(1, i)
            koTargets[i], koTargets[j] = koTargets[j], koTargets[i]
        end

        local stompSucceeded = false

        for _, target in ipairs(koTargets) do
            if stompSucceeded then break end
            if not IsStillKOd(target) then
                print(string.format("[HVH] %s no longer KO'd, skipping", target.Name))
                continue
            end

            print(string.format("[HVH] Stomping %s", target.Name))

            -- Run the same cycle as the working autostomp until target is done or timeout
            local timeout = tick() + 8
            while tick() < timeout and IsStillKOd(target) do
                DoStompCycle(hrp, hum, target, returnCFrame)
                -- no task.wait() here - run as fast as possible just like the working script
            end

            if not IsStillKOd(target) then
                stompSucceeded = true
                print(string.format("[HVH] ✅ Stomp confirmed on %s", target.Name))
            else
                print(string.format("[HVH] ❌ Stomp on %s timed out", target.Name))
            end

            -- Return to saved position between targets
            hrp.CFrame = returnCFrame
            task.wait(0.1)
        end

        if not stompSucceeded then
            print("[HVH] ⚠️ All stomps failed")
        end

        -- Make sure we're back
        hrp.CFrame = returnCFrame

        task.wait(0.1)

        -- Resume AutoKill
        print("[HVH] Resuming AutoKill...")

        if HVH.OriginalTarget then
            local t = HVH.OriginalTarget
            if t and t.Character then
                local targetHum = t.Character:FindFirstChildOfClass("Humanoid")
                if targetHum and targetHum.Health > 0 then
                    AutoKill.Target = t
                else
                    AutoKill.Target = nil
                    AutoKill.AdvanceTarget()
                end
            else
                AutoKill.Target = nil
                AutoKill.AdvanceTarget()
            end
        else
            AutoKill.Target = nil
            AutoKill.AdvanceTarget()
        end

        AutoKill.Enabled = true
        if AutoKill.Target or AutoKill.HasSelectedTargets() then
            AutoKill.StartCycle()
        end

        HVH.OriginalTarget = nil
        HVH.Running = false
        HVH.Cooldown = tick() + 4

        print("[HVH] Done, 4s cooldown")
    end
end)

print("[HVH] Loaded - mirrors working autostomp: UpperTorso+3.5, RenderStepped, 5x stomp, return")
print("blerd")
