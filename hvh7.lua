local HVH = { 
    Enabled = false, 
    Running = false
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then 
            HVH.Running = false
        end
    end
})

-- This will force AutoKill to stop by directly modifying the loop
local function BruteforceStopAutoKill()
    -- Disable AutoKill completely
    AutoKill.Enabled = false
    
    -- Stop the cycle
    if AutoKill.CycleActive then
        AutoKill.CycleActive = false
    end
    
    -- Clear target
    AutoKill.Target = nil
    
    -- Stop auto stomp
    if AutoKill.StopAutoStomp then
        AutoKill.StopAutoStomp()
    end
    
    -- Wait for everything to stop
    task.wait(0.2)
    
    print("[HVH] AutoKill force stopped")
end

local function BruteforceResumeAutoKill()
    -- Re-enable AutoKill
    AutoKill.Enabled = true
    
    -- Set pause flag off
    AutoKill.HVHPause = false
    
    -- Find a target
    if not AutoKill.Target then
        AutoKill.AdvanceTarget()
    end
    
    -- Start the cycle
    if AutoKill.Enabled and AutoKill.Target then
        AutoKill.StartCycle()
    end
    
    print("[HVH] AutoKill resumed")
end

-- Main loop - runs independently
task.spawn(function()
    while true do
        task.wait(0.2) -- Check every 0.2 seconds
        
        -- Skip if HVH not enabled
        if not HVH.Enabled then
            continue
        end
        
        -- Skip if already running
        if HVH.Running then
            continue
        end
        
        -- Check if AutoKill is actually running
        if not AutoKill.Enabled then
            continue
        end
        
        -- Get player health
        local char = LocalPlayer.Character
        if not char then continue end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        -- Check health
        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        if healthPercent > 70 then
            continue
        end
        
        print(string.format("[HVH] Health: %d%% - TRIGGERING!", math.floor(healthPercent)))
        
        -- Find KO'd players
        local koTarget = nil
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local pChar = player.Character
                if pChar then
                    local be = pChar:FindFirstChild("BodyEffects")
                    if be then
                        local ko = be:FindFirstChild("K.O")
                        local dead = be:FindFirstChild("Dead")
                        if ko and ko.Value == true and (not dead or dead.Value == false) then
                            local upperTorso = pChar:FindFirstChild("UpperTorso")
                            if upperTorso then
                                koTarget = {
                                    player = player,
                                    upperTorso = upperTorso
                                }
                                break
                            end
                        end
                    end
                end
            end
        end
        
        if not koTarget then
            print("[HVH] No KO'd players found")
            continue
        end
        
        print(string.format("[HVH] Found KO target: %s", koTarget.player.Name))
        
        -- Mark as running
        HVH.Running = true
        
        -- SAVE ORIGINAL TARGET
        local originalTarget = AutoKill.Target
        
        -- ===== FORCE STOP AUTO KILL =====
        print("[HVH] Stopping AutoKill...")
        
        -- Completely disable AutoKill
        AutoKill.Enabled = false
        if AutoKill.CycleActive then
            AutoKill.CycleActive = false
        end
        AutoKill.Target = nil
        
        -- Wait for it to fully stop
        task.wait(0.3)
        
        -- ===== TELEPORT AND STOMP =====
        local mainEvent = ReplicatedStorage:FindFirstChild("MainEvent")
        
        if mainEvent and hrp and hum then
            -- Save position
            local originalPos = hrp.CFrame
            
            print("[HVH] Teleporting to stomp...")
            
            -- Teleport
            local stompPos = koTarget.upperTorso.Position + Vector3.new(0, 3.5, 0)
            hrp.CFrame = CFrame.new(stompPos)
            task.wait(0.05)
            hrp.CFrame = CFrame.new(stompPos)
            task.wait(0.05)
            
            print("[HVH] Stomping...")
            
            -- Stomp 5 times
            for i = 1, 5 do
                mainEvent:FireServer("Stomp")
                task.wait(0.1)
            end
            
            print("[HVH] Stomp complete, returning...")
            
            -- Return to original position
            hrp.CFrame = originalPos
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            
            task.wait(0.2)
        end
        
        -- ===== RESUME AUTO KILL =====
        print("[HVH] Resuming AutoKill...")
        
        -- Restore original target if still valid
        if originalTarget and originalTarget.Character then
            local targetHum = originalTarget.Character:FindFirstChildOfClass("Humanoid")
            if targetHum and targetHum.Health > 0 then
                AutoKill.Target = originalTarget
                print(string.format("[HVH] Restored target: %s", originalTarget.Name))
            end
        end
        
        -- Re-enable AutoKill
        AutoKill.Enabled = true
        AutoKill.HVHPause = false
        
        -- Start the cycle if we have a target
        if AutoKill.Target then
            AutoKill.StartCycle()
        end
        
        -- Reset
        task.wait(0.5)
        HVH.Running = false
        
        print("[HVH] Cycle complete")
    end
end)

print("[HVH] Loaded - Will stomp KO players when health < 70%")
print("12.30 bro")
