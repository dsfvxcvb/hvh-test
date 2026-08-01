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
                        local ut = c:FindFirstChild("UpperTorso")
                        local tHRP = c:FindFirstChild("HumanoidRootPart")
                        if ut or tHRP then
                            table.insert(targets, {
                                player = p,
                                character = c,
                                upperTorso = ut,
                                hrp = tHRP
                            })
                        end
                    end
                end
            end
        end
    end
    return targets
end

-- FIX #3: Check if stomp landed by watching Dead value, not health gain
-- Health replication is delayed and unreliable as a success signal
local function StompLanded(targetChar)
    if not targetChar or not targetChar.Parent then return true end -- target gone = success
    local be = targetChar:FindFirstChild("BodyEffects")
    if not be then return true end
    local dead = be:FindFirstChild("Dead")
    local ko = be:FindFirstChild("K.O")
    -- Stomp succeeded if target is now dead OR no longer KO'd (got back up = we stomped them out)
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

local function DoStompWithRetry(hrp, hum, target, maxRetries)
    if not target or not target.character then return false end
    
    local targetChar = target.character
    if not targetChar then return false end

    local originalCF = hrp.CFrame

    print(string.format("[HVH] Starting stomp on %s", target.player.Name))
    
    -- Set humanoid to Physics state so it stops fighting our teleport
    hum.Sit = false
    hum.PlatformStand = false
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.Physics)
    end)

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    -- Lock directly onto the target's HRP instead of floating above UpperTorso.
    -- A downed player's HRP is on or near the ground - matching it puts us
    -- on top of them, not floating, so the server sees a valid stomp position.
    local function GetTargetHRP()
        return targetChar:FindFirstChild("HumanoidRootPart")
    end

    local function GetStompCFrame()
        local targetHRP = GetTargetHRP()
        if targetHRP then
            -- Sit exactly on top of their HRP (same XZ, just slightly above so we're standing on them)
            return CFrame.new(targetHRP.Position + Vector3.new(0, 1, 0))
        end
        -- Fallback to UpperTorso if HRP somehow missing
        local ut = targetChar:FindFirstChild("UpperTorso")
        if ut then
            return CFrame.new(ut.Position + Vector3.new(0, 1, 0))
        end
        return nil
    end

    local initialCF = GetStompCFrame()
    if not initialCF then return false end

    hrp.CFrame = initialCF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    -- Wait for server to confirm position before firing
    task.wait(0.25)
    RunService.Heartbeat:Wait()

    -- Use Heartbeat to keep us locked on their HRP (runs with physics, not after it)
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
        -- Bail if target is no longer KO'd
        if not IsStillKOd(targetChar) then
            print("[HVH] Target state changed, checking if stomp landed...")
            stompSuccess = StompLanded(targetChar)
            break
        end
        
        -- Re-confirm position right before firing
        local confirmCF = GetStompCFrame()
        if confirmCF then
            hrp.CFrame = confirmCF
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
        RunService.Heartbeat:Wait()

        -- Fire stomp remote 3 times per attempt for reliability
        for i = 1, 3 do
            pcall(function()
                mainevent:FireServer("Stomp")
                stompCount = stompCount + 1
            end)
            task.wait(0.05)
        end

        -- FIX #3: Check Dead/KO values, not health
        if StompLanded(targetChar) then
            print(string.format("[HVH] ✅ Stomp confirmed on %s (attempt %d)", target.player.Name, attempt))
            stompSuccess = true
            break
        end
        
        print(string.format("[HVH] Attempt %d/%d - still waiting for stomp to register", attempt, maxRetries))
        task.wait(0.1)
    end
    
    lockConnection:Disconnect()

    -- Restore humanoid state
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end)

    -- Return to original position
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
        
        if tick() < HVH.Cooldown then
            continue
        end
        
        if not HVH.Enabled or HVH.Running then
            continue
        end
        
        if not AutoKill.Enabled then
            continue
        end
        
        local char = LocalPlayer.Character
        if not char then continue end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        if healthPercent > 50 then
            continue
        end
        
        local koTargets = GetAllKOTargets()
        if #koTargets == 0 then
            continue
        end
        
        print(string.format("[HVH] HP: %d%%, Found %d KO targets", math.floor(healthPercent), #koTargets))
        
        HVH.Running = true
        HVH.OriginalTarget = AutoKill.Target
        HVH.StompAttempts = 0
        
        -- FIX #4: Use StopCycle() instead of manually toggling flags
        -- This properly clears IsKilling, IsHiding, StompRunning, etc.
        print("[HVH] Stopping AutoKill...")
        AutoKill.Enabled = false
        AutoKill.StopCycle()

        -- FIX #5: Only kill autostomp flag, don't touch .running
        -- Killing .running externally causes AutoStompLoop to crash mid-execution
        if getgenv().AutoStompState then
            getgenv().AutoStompState.autostomp = false
        end
        
        task.wait(0.3) -- give StopCycle time to fully unwind
        
        -- Shuffle targets
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
                print(string.format("[HVH] ✅ Stomp successful!"))
            else
                print(string.format("[HVH] ❌ Stomp on %s failed, trying next", target.player.Name))
            end
            
            task.wait(0.15)
        end
        
        if not stompSucceeded then
            print("[HVH] ⚠️ All stomps failed, emergency attempt...")
            local anyTarget = GetKOTarget()
            if anyTarget then
                local ut = anyTarget.Character and anyTarget.Character:FindFirstChild("UpperTorso")
                if ut then
                    DoStompWithRetry(hrp, hum, {
                        player = anyTarget,
                        character = anyTarget.Character,
                        upperTorso = ut
                    }, 3)
                end
            end
        end
        
        task.wait(0.2)
        
        -- ===== RESUME AUTO KILL =====
        print("[HVH] Resuming AutoKill...")
        
        -- Restore target
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
print("jynxzi")
