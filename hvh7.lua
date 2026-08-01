local HVH = { 
    Enabled = false, 
    Running = false,
    OriginalTarget = nil,
    Cooldown = 0,
    StompAttempts = 0
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then 
            HVH.Running = false
            HVH.OriginalTarget = nil
            HVH.StompAttempts = 0
        end
    end
})

local mainevent = ReplicatedStorage:WaitForChild("MainEvent")

local function GetKOTarget()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local c = p.Character
            if c then
                local b = c:FindFirstChild("BodyEffects")
                if b then
                    local ko = b:FindFirstChild("K.O")
                    local dead = b:FindFirstChild("Dead")
                    if ko and ko.Value and dead and not dead.Value then
                        return p
                    end
                end
            end
        end
    end
    return nil
end

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
                        table.insert(targets, {
                            player = p,
                            character = c,
                        })
                    end
                end
            end
        end
    end
    return targets
end

local function StompLanded(targetChar)
    if not targetChar or not targetChar.Parent then return true end
    local be = targetChar:FindFirstChild("BodyEffects")
    if not be then return true end
    local dead = be:FindFirstChild("Dead")
    local ko = be:FindFirstChild("K.O")
    if dead and dead.Value then return true end
    if ko and not ko.Value then return true end
    return false
end

local function IsStillKOd(targetChar)
    if not targetChar or not targetChar.Parent then return false end
    local be = targetChar:FindFirstChild("BodyEffects")
    if not be then return false end
    local ko = be:FindFirstChild("K.O")
    local dead = be:FindFirstChild("Dead")
    return ko and ko.Value and (not dead or not dead.Value)
end

-- Find the lowest BasePart in the ragdoll so we land on the actual body,
-- not floating above a tilted/sideways HRP
local function GetLowestPartPosition(targetChar)
    local lowestY = math.huge
    local lowestPos = nil

    for _, part in ipairs(targetChar:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local y = part.Position.Y
            if y < lowestY then
                lowestY = y
                lowestPos = part.Position
            end
        end
    end

    -- fallback to HRP if nothing else found
    if not lowestPos then
        local hrpTarget = targetChar:FindFirstChild("HumanoidRootPart")
        if hrpTarget then
            lowestPos = hrpTarget.Position
        end
    end

    return lowestPos
end

local function DoStompWithRetry(hrp, hum, target, maxRetries)
    if not target or not target.character then return false end

    local targetChar = target.character
    if not targetChar then return false end

    local originalCF = hrp.CFrame

    print(string.format("[HVH] Starting stomp on %s", target.player.Name))

    hum.Sit = false
    hum.PlatformStand = false
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.Physics)
    end)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    -- Build a stomp CFrame from the LOWEST part of their ragdoll.
    -- +2.5 Y puts us just above the lowest point so we're standing on the body,
    -- not floating above a sideways HRP or clipping inside the floor.
    local function GetStompCFrame()
        local pos = GetLowestPartPosition(targetChar)
        if not pos then return nil end
        return CFrame.new(pos + Vector3.new(0, 2.5, 0))
    end

    local initialCF = GetStompCFrame()
    if not initialCF then return false end

    hrp.CFrame = initialCF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    -- Give the server enough time to confirm the teleport before we fire
    task.wait(0.3)
    RunService.Heartbeat:Wait()

    -- Heartbeat lock: track their lowest part so we stay planted on the ragdoll
    -- even if it slides or shifts
    local lockConnection = RunService.Heartbeat:Connect(function()
        if not targetChar or not targetChar.Parent then return end
        local cf = GetStompCFrame()
        if cf then
            hrp.CFrame = cf
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)

    local stompCount = 0
    local stompSuccess = false

    for attempt = 1, maxRetries do
        if not IsStillKOd(targetChar) then
            print("[HVH] Target state changed, checking if stomp landed...")
            stompSuccess = StompLanded(targetChar)
            break
        end

        -- Hard re-confirm position every attempt
        local confirmCF = GetStompCFrame()
        if confirmCF then
            hrp.CFrame = confirmCF
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end

        -- Wait a full Heartbeat so the server gets the updated position
        RunService.Heartbeat:Wait()
        RunService.Heartbeat:Wait() -- two ticks to be safe

        -- Fire stomp remote - 2 fires per attempt with a gap between them
        -- (3 rapid fires was hammering too fast, server was ignoring them)
        pcall(function() mainevent:FireServer("Stomp") end)
        stompCount = stompCount + 1
        task.wait(0.1)
        pcall(function() mainevent:FireServer("Stomp") end)
        stompCount = stompCount + 1

        -- Give server time to process and replicate the result
        task.wait(0.2)

        if StompLanded(targetChar) then
            print(string.format("[HVH] ✅ Stomp confirmed on %s (attempt %d)", target.player.Name, attempt))
            stompSuccess = true
            break
        end

        print(string.format("[HVH] Attempt %d/%d - stomp not registered yet", attempt, maxRetries))
    end

    lockConnection:Disconnect()

    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end)

    hrp.CFrame = originalCF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    print(string.format("[HVH] Fired stomp %d times, Success: %s", stompCount, tostring(stompSuccess)))
    return stompSuccess
end

-- Main HVH loop
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

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        if healthPercent > 50 then continue end

        local koTargets = GetAllKOTargets()
        if #koTargets == 0 then continue end

        print(string.format("[HVH] HP: %d%%, Found %d KO targets", math.floor(healthPercent), #koTargets))

        HVH.Running = true
        HVH.OriginalTarget = AutoKill.Target
        HVH.StompAttempts = 0

        print("[HVH] Stopping AutoKill...")
        AutoKill.Enabled = false
        AutoKill.StopCycle()

        if getgenv().AutoStompState then
            getgenv().AutoStompState.autostomp = false
        end

        task.wait(0.3)

        -- Shuffle so we don't always try the same target first
        for i = #koTargets, 2, -1 do
            local j = math.random(1, i)
            koTargets[i], koTargets[j] = koTargets[j], koTargets[i]
        end

        local stompSucceeded = false

        for _, target in ipairs(koTargets) do
            if stompSucceeded then break end

            if not IsStillKOd(target.character) then
                print(string.format("[HVH] %s no longer KO'd, skipping", target.player.Name))
                continue
            end

            HVH.StompAttempts = HVH.StompAttempts + 1
            print(string.format("[HVH] Stomping %s (attempt #%d)", target.player.Name, HVH.StompAttempts))

            local success = DoStompWithRetry(hrp, hum, target, 5)

            if success then
                stompSucceeded = true
                print("[HVH] ✅ Stomp successful!")
            else
                print(string.format("[HVH] ❌ Stomp on %s failed, trying next", target.player.Name))
            end

            task.wait(0.15)
        end

        if not stompSucceeded then
            print("[HVH] ⚠️ All stomps failed, emergency attempt...")
            local anyTarget = GetKOTarget()
            if anyTarget and anyTarget.Character then
                DoStompWithRetry(hrp, hum, {
                    player = anyTarget,
                    character = anyTarget.Character,
                }, 3)
            end
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
        HVH.StompAttempts = 0
        HVH.Cooldown = tick() + 4

        print("[HVH] Done, 4s cooldown")
    end
end)

print("[HVH] Loaded - Health < 50%, stomps KO targets to recover")
print("dr house")
