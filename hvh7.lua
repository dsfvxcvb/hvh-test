local HVH = { 
    Enabled = false, 
    Running = false,
    OriginalTarget = nil
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then 
            HVH.Running = false
            HVH.OriginalTarget = nil
            if AutoKill.HVHPause then
                AutoKill.HVHPause = false
                if AutoKill.Enabled then
                    AutoKill.StartCycle()
                end
            end
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

-- Stomp function that disables all auto-stomp interference
local function StompTarget(hrp, hum, target, mainevent)
    if not target or not target.Character then return 0 end
    
    local targetChar = target.Character
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return 0 end
    
    -- SAVE ORIGINAL POSITION
    local originalCF = hrp.CFrame
    
    -- TEMPORARILY KILL AUTO-STOMP STATE
    local autoStompState = getgenv().AutoStompState
    local wasAutostompRunning = false
    
    if autoStompState then
        wasAutostompRunning = autoStompState.autostomp
        autoStompState.autostomp = false
        autoStompState.running = false
        autoStompState.ret = nil
    end
    
    -- Also stop AutoKill's stomp if running
    if AutoKill.StopAutoStomp then
        AutoKill.StopAutoStomp()
    end
    AutoKill.GunMethod.StompRunning = false
    
    print("[HVH] Starting stomp on: " .. target.Name)
    
    local stompCount = 0
    local maxAttempts = 15
    
    for attempt = 1, maxAttempts do
        -- Check if target is still KO'd
        if not targetChar or not targetChar.Parent then
            print("[HVH] Target lost")
            break
        end
        
        local koBody = targetChar:FindFirstChild("BodyEffects")
        if koBody then
            local ko = koBody:FindFirstChild("K.O")
            local dead = koBody:FindFirstChild("Dead")
            if not ko or not ko.Value or (dead and dead.Value) then
                print("[HVH] Target no longer KO'd or dead")
                break
            end
        end
        
        -- Get UpperTorso position
        local ut = targetChar:FindFirstChild("UpperTorso")
        if not ut then
            print("[HVH] No UpperTorso found")
            break
        end
        
        -- Reset humanoid (prevents ragdoll interference)
        hum.Sit = false
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        
        -- Clear velocity
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        
        -- Teleport above target
        local stompPos = ut.Position + Vector3.new(0, 3.5, 0)
        hrp.CFrame = CFrame.new(stompPos)
        
        -- Wait for teleport to register
        task.wait(0.03)
        RunService.RenderStepped:Wait()
        
        -- Fire stomp multiple times rapidly
        for i = 1, 5 do
            mainevent:FireServer("Stomp")
            task.wait(0.02)
        end
        
        stompCount = stompCount + 5
        
        -- Small delay before next attempt
        task.wait(0.05)
    end
    
    print("[HVH] Stomped " .. stompCount .. " times")
    
    -- Return to original position
    hrp.CFrame = originalCF
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    -- Restore auto-stomp state
    if autoStompState then
        autoStompState.autostomp = wasAutostompRunning
        if wasAutostompRunning then
            task.spawn(function()
                getgenv().AutoStompLoop()
            end)
        end
    end
    
    return stompCount
end

-- Main HVH loop
task.spawn(function()
    while true do
        task.wait(0.15)
        
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
        if healthPercent > 70 then
            continue
        end
        
        local koTarget = GetKOTarget()
        if not koTarget then continue end
        
        print(string.format("[HVH] Health %d%%, Stomping: %s", math.floor(healthPercent), koTarget.Name))
        
        HVH.Running = true
        HVH.OriginalTarget = AutoKill.Target
        
        -- ===== STOP AUTO KILL COMPLETELY =====
        print("[HVH] Stopping AutoKill...")
        AutoKill.Enabled = false
        if AutoKill.CycleActive then
            AutoKill.CycleActive = false
        end
        AutoKill.Target = nil
        
        -- Disable auto-stomp states
        if AutoKill.StopAutoStomp then
            AutoKill.StopAutoStomp()
        end
        AutoKill.GunMethod.StompRunning = false
        
        if getgenv().AutoStompState then
            getgenv().AutoStompState.autostomp = false
            getgenv().AutoStompState.running = false
            getgenv().AutoStompState.ret = nil
        end
        
        task.wait(0.2)
        
        -- ===== PERFORM STOMP =====
        local stompCount = StompTarget(hrp, hum, koTarget, mainevent)
        
        if stompCount == 0 then
            print("[HVH] WARNING: No stomps performed!")
            -- Try one more time with direct approach
            local ut = koTarget.Character and koTarget.Character:FindFirstChild("UpperTorso")
            if ut then
                print("[HVH] Emergency stomp attempt...")
                hum.Sit = false
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
                task.wait(0.1)
                for i = 1, 10 do
                    mainevent:FireServer("Stomp")
                    task.wait(0.03)
                end
                hrp.CFrame = originalPos or hrp.CFrame
            end
        end
        
        -- ===== RESUME AUTO KILL =====
        print("[HVH] Resuming AutoKill...")
        
        if HVH.OriginalTarget then
            local target = HVH.OriginalTarget
            if target and target.Character then
                local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
                if targetHum and targetHum.Health > 0 then
                    AutoKill.Target = target
                    print(string.format("[HVH] Restored target: %s", target.Name))
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
        AutoKill.HVHPause = false
        
        if AutoKill.Target then
            AutoKill.StartCycle()
        end
        
        HVH.OriginalTarget = nil
        task.wait(0.3)
        HVH.Running = false
        
        print("[HVH] HVH cycle complete")
    end
end)

print("[HVH] Loaded - Fixed auto-stomp interference")
print("gruge")
