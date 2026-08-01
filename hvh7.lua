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

local function GetAllKOTargets()
    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local c = p.Character
            if c then
                local b = c:FindFirstChild("BodyEffects")
                if b then
                    local ko = b:FindFirstChild("K.O")
                    local dead = b:FindFirstChild("Dead")
                    if ko and ko.Value and dead and not dead.Value then
                        table.insert(targets, p)
                    end
                end
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

task.spawn(function()
    while true do
        task.wait(0.2)

        if tick() < HVH.Cooldown then continue end
        if not HVH.Enabled or HVH.Running then continue end
        if not AutoKill.Enabled then continue end

        local char = LocalPlayer.Character
        if not char then continue end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then continue end

        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        if healthPercent > 50 then continue end

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
        task.wait(0.3)

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

            print(string.format("[HVH] Stomping %s using AutoStompLoop", target.Name))

            -- Use the exact same AutoStomp system the main script uses
            -- Just point Targeting.Target at the KO'd player and let it run
            local state = getgenv().AutoStompState
            if not state then
                print("[HVH] AutoStompState not found, skipping")
                continue
            end

            local prevTargetingTarget = Targeting.Target
            Targeting.Target = target
            state.autostomp = true
            getgenv().AutoStompLoop()

            -- Wait for stomp to land (watch for Dead or KO going false)
            local timeout = tick() + 3
            while tick() < timeout do
                if not IsStillKOd(target) then
                    stompSucceeded = true
                    print(string.format("[HVH] ✅ Stomp confirmed on %s", target.Name))
                    break
                end
                task.wait(0.05)
            end

            -- Stop the stomp loop
            state.autostomp = false
            Targeting.Target = prevTargetingTarget

            if not stompSucceeded then
                print(string.format("[HVH] ❌ Stomp on %s timed out", target.Name))
            end

            task.wait(0.1)
        end

        if not stompSucceeded then
            print("[HVH] ⚠️ All stomps failed")
        end

        task.wait(0.2)

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

print("[HVH] Loaded - uses AutoStompLoop to stomp KO targets when HP < 50%")
print("crayola")
