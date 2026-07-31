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

-- Directly inject a check into AutoKill's main loop
local function InjectHVHCheck()
    -- Get the original AutoKill loop function
    local originalStartCycle = AutoKill.StartCycle
    
    -- Override StartCycle to check HVH state
    AutoKill.StartCycle = function()
        if AutoKill.HVHPause then
            print("[HVH] AutoKill blocked by HVH pause")
            return
        end
        originalStartCycle()
    end
    
    -- Override StartCombatCycle to check HVH state
    local originalCombatCycle = AutoKill.StartCombatCycle
    AutoKill.StartCombatCycle = function()
        if AutoKill.HVHPause then
            print("[HVH] Combat cycle blocked by HVH pause")
            return
        end
        originalCombatCycle()
    end
    
    print("[HVH] AutoKill hooks installed")
end

InjectHVHCheck()

-- Force stop function
local function ForceStopAutoKill()
    print("[HVH] 🛑 FORCE STOPPING AutoKill...")
    
    -- Set the pause flag
    AutoKill.HVHPause = true
    
    -- Kill the active cycle
    if AutoKill.CycleActive then
        AutoKill.CycleActive = false
    end
    
    -- Stop auto stomp
    if AutoKill.StopAutoStomp then
        AutoKill.StopAutoStomp()
    end
    
    -- Clear target to stop any targeting
    AutoKill.Target = nil
    
    -- Wait for the loop to realize it's stopped
    task.wait(0.3)
    
    print("[HVH] ✅ AutoKill stopped")
end

local function ForceResumeAutoKill()
    print("[HVH] ▶️ RESUMING AutoKill...")
    
    -- Clear the pause
    AutoKill.HVHPause = false
    
    -- Wait a moment
    task.wait(0.1)
    
    if AutoKill.Enabled then
        -- Find a target
        if not AutoKill.Target then
            AutoKill.AdvanceTarget()
        end
        
        -- Start the cycle
        AutoKill.StartCycle()
        print("[HVH] ✅ AutoKill resumed")
    end
end

-- Main HVH loop
task.spawn(function()
    print("[HVH] Main loop started")
    
    while true do
        task.wait(0.15)
        
        -- Skip if not enabled or already running
        if not HVH.Enabled or HVH.Running then
            continue
        end
        
        -- Skip if AutoKill isn't enabled or already paused
        if not AutoKill.Enabled then
            continue
        end
        
        if AutoKill.HVHPause then
            continue
        end
        
        -- Get player health
        local char = LocalPlayer.Character
        if not char then continue end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        -- Check health below 70%
        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        if healthPercent > 70 then
            continue
        end
        
        print(string.format("[HVH] ⚠️ HEALTH %d%% - TRIGGERING HVH!", math.floor(healthPercent)))
        
        -- Find KO'd players
        local koTargets = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local pChar = player.Character
                if pChar then
                    local bodyEffects = pChar:FindFirstChild("BodyEffects")
                    if bodyEffects then
                        local ko = bodyEffects:FindFirstChild("K.O")
                        local dead = bodyEffects:FindFirstChild("Dead")
                        if ko and ko.Value == true and (not dead or dead.Value == false) then
                            local upperTorso = pChar:FindFirstChild("UpperTorso")
                            if upperTorso then
                                table.insert(koTargets, {
                                    player = player,
                                    upperTorso = upperTorso,
                                    character = pChar
                                })
                            end
                        end
                    end
                end
            end
        end
        
        if #koTargets == 0 then
            print("[HVH] No KO'd players found, skipping")
            continue
        end
        
        -- Pick random KO target
        local target = koTargets[math.random(1, #koTargets)]
        print(string.format("[HVH] 🎯 KO target: %s", target.player.Name))
        
        -- Mark as running
        HVH.Running = true
        
        -- Save original target
        HVH.OriginalTarget = AutoKill.Target
        
        -- ===== STOP AUTO KILL =====
        ForceStopAutoKill()
        
        -- ===== TELEPORT AND STOMP =====
        local mainEvent = ReplicatedStorage:FindFirstChild("MainEvent")
        
        if mainEvent and hrp and hum then
            local originalCFrame = hrp.CFrame
            
            print("[HVH] 📍 Teleporting to stomp position...")
            
            -- Reset humanoid
            hum.Sit = false
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            
            -- Clear velocity
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            
            -- Teleport to KO'd player
            local teleportPos = target.upperTorso.Position + Vector3.new(0, 3.5, 0)
            
            -- Force teleport multiple times
            hrp.CFrame = CFrame.new(teleportPos)
            task.wait(0.05)
            hrp.CFrame = CFrame.new(teleportPos)
            task.wait(0.05)
            hrp.CFrame = CFrame.new(teleportPos)
            RunService.RenderStepped:Wait()
            
            print("[HVH] 💀 Stomping...")
            
            -- Stomp 6 times
            for i = 1, 6 do
                mainEvent:FireServer("Stomp")
                print(string.format("[HVH] Stomp %d/6", i))
                task.wait(0.08)
            end
            
            print("[HVH] ✅ Stomped! Returning...")
            
            -- Return to original position
            hrp.CFrame = originalCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            
            task.wait(0.2)
        else
            print("[HVH] ❌ Failed to stomp!")
        end
        
        -- ===== RESUME AUTO KILL =====
        -- Restore original target
        if HVH.OriginalTarget then
            local target = HVH.OriginalTarget
            if target and target.Character then
                local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
                if targetHum and targetHum.Health > 0 then
                    AutoKill.Target = target
                    print(string.format("[HVH] Restored target: %s", target.Name))
                else
                    print("[HVH] Original target dead, finding new")
                    AutoKill.Target = nil
                    AutoKill.AdvanceTarget()
                end
            else
                print("[HVH] Original target invalid, finding new")
                AutoKill.Target = nil
                AutoKill.AdvanceTarget()
            end
        else
            print("[HVH] No original target, finding new")
            AutoKill.Target = nil
            AutoKill.AdvanceTarget()
        end
        
        -- Resume AutoKill
        ForceResumeAutoKill()
        
        -- Reset
        HVH.OriginalTarget = nil
        task.wait(0.5)
        HVH.Running = false
        
        print("[HVH] ✅ HVH cycle complete")
    end
end)

print("[HVH] ✅ Loaded - Will stop AutoKill and stomp when health < 70%")
print("past 12 bruh")
