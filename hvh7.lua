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

local function DoStomp(target)
    local char = LocalPlayer.Character
    if not char then return end
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end

    -- Teleport directly onto target's HRP, same as ProtectPlayer.TeleportTo
    myHRP.CFrame = targetHRP.CFrame
    myHRP.AssemblyLinearVelocity = Vector3.zero
    myHRP.AssemblyAngularVelocity = Vector3.zero

    -- Wait one Heartbeat so position replicates before firing
    RunService.Heartbeat:Wait()
    RunService.Heartbeat:Wait()

    -- Fire the stomp remote directly, same as ProtectPlayer.Stomp()
    pcall(function()
        mainevent:FireServer("Stomp")
    end)
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
        task.wait(0.2)

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

            -- Teleport + fire stomp remote in a tight loop for up to 3 seconds
            local timeout = tick() + 3
            local lockConn = RunService.Heartbeat:Connect(function()
                if not target.Character then return end
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP and myHRP then
                    myHRP.CFrame = targetHRP.CFrame
                    myHRP.AssemblyLinearVelocity = Vector3.zero
                    myHRP.AssemblyAngularVelocity = Vector3.zero
                end
            end)

            while tick() < timeout do
                if not IsStillKOd(target) then
                    stompSucceeded = true
                    print(string.format("[HVH] ✅ Stomp confirmed on %s", target.Name))
                    break
                end

                -- Teleport snap + fire
                DoStomp(target)
                task.wait(0.15)
            end

            lockConn:Disconnect()

            if not stompSucceeded then
                print(string.format("[HVH] ❌ Stomp on %s timed out", target.Name))
            end

            task.wait(0.1)
        end

        if not stompSucceeded then
            print("[HVH] ⚠️ All stomps failed")
        end

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

print("[HVH] Loaded - fires Stomp remote directly while loop-locked onto target")
print("nigger")
