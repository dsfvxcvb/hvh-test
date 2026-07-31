local HVH = { 
    Enabled = false, 
    Running = false, 
    OriginalTarget = nil,
    OriginalMethod = nil
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

-- Forcefully stop AutoKill by breaking its loop
local function ForceStopAutoKill()
    print("[HVH] FORCE STOPPING AutoKill...")
    AutoKill.HVHPause = true
    
    -- Kill the cycle by setting it to false
    AutoKill.CycleActive = false
    
    -- Stop the auto-stomp if running
    if AutoKill.StopAutoStomp then
        AutoKill.StopAutoStomp()
    end
    
    -- Clear the target to stop targeting
    AutoKill.Target = nil
    
    -- Wait for the loop to exit
    task.wait(0.2)
    print("[HVH] AutoKill force stopped")
end

local function ForceResumeAutoKill()
    print("[HVH] RESUMING AutoKill...")
    AutoKill.HVHPause = false
    
    -- Wait a moment
    task.wait(0.1)
    
    if AutoKill.Enabled then
        -- Find a target if we don't have one
        if not AutoKill.Target then
            AutoKill.AdvanceTarget()
        end
        
        -- Start the cycle
        AutoKill.StartCycle()
        print("[HVH] AutoKill resumed")
    end
end

-- Simplified HVH loop
task.spawn(function()
    while true do
        task.wait(0.2)
        
        -- Skip if not enabled or already running
        if not HVH.Enabled or HVH.Running then
            continue
        end
        
        -- Skip if AutoKill isn't enabled or active
        if not AutoKill.Enabled then
            continue
        end
        
        -- Check if AutoKill is actually running (not paused)
        if AutoKill.HVHPause then
            continue
        end
        
        -- Get player character and health
        local char = LocalPlayer.Character
        if not char then continue end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        -- Check health (below 70%)
        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        if healthPercent > 70 then
            continue
        end
        
        print(string.format("[HVH] ⚠️ HEALTH BELOW 70%%! (%d HP) - TRIGGERING HVH", math.floor(hum.Health)))
        
        -- Find a KO'd player
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
            print("[HVH] No KO'd players found")
            continue
        end
        
        -- Pick random KO'd target
        local target = koTargets[math.random(1, #koTargets)]
        print(string.format("[HVH] 🎯 Selected KO target: %s", target.player.Name))
        
        -- Mark as running
        HVH.Running = true
        
        -- Save original target
        HVH.OriginalTarget = AutoKill.Target
        if HVH.OriginalTarget then
            print(string.format("[HVH] Saved original target: %s", HVH.OriginalTarget.Name))
        end
        
        -- ===== FORCE STOP AUTO KILL =====
        ForceStopAutoKill()
        
        -- ===== TELEPORT AND STOMP =====
        local mainEvent = ReplicatedStorage:FindFirstChild("MainEvent")
        
        if mainEvent and hrp and hum then
            local originalCFrame = hrp.CFrame
            
            -- Prepare for teleport
            hum.Sit = false
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            
            -- Clear velocity
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            
            -- Teleport to KO'd player
            local teleportPos = target.upperTorso.Position + Vector3.new(0, 3.5, 0)
            print(string.format("[HVH] 📍 Teleporting to: %s", tostring(teleportPos)))
            
            -- Force teleport
            hrp.CFrame = CFrame.new(teleportPos)
            task.wait(0.05)
            
            -- Second force teleport
            hrp.CFrame = CFrame.new(teleportPos)
            RunService.RenderStepped:Wait()
            
            print("[HVH] 💀 Stomping...")
            
            -- Stomp 5 times with delay
            for i = 1, 5 do
                mainEvent:FireServer("Stomp")
                print(string.format("[HVH] Stomp %d/5", i))
                task.wait(0.1)
            end
            
            print("[HVH] ✅ Stomped!")
            
            -- Return to original position
            hrp.CFrame = originalCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            
            task.wait(0.2)
        else
            print("[HVH] ❌ Failed: Missing MainEvent or character parts")
        end
        
        -- ===== RESUME AUTO KILL =====
        print("[HVH] Resuming AutoKill...")
        
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

print("[HVH] ✅ Loaded - Will stomp KO'd players when health drops below 70%")
