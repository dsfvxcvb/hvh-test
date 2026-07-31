local HVH = { Enabled = false, Running = false, OriginalTarget = nil }

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then 
            HVH.Running = false
            HVH.OriginalTarget = nil
            if AutoKill.Enabled and AutoKill.HVHPause then
                AutoKill.HVHPause = false
                AutoKill.StartCycle()
            end
        end
    end
})

-- Main HVH loop with debug
task.spawn(function()
    print("[HVH] HVH loop started")
    while true do
        task.wait(0.1)
        
        -- Debug: print state occasionally
        if tick() % 5 < 0.1 then
            print(string.format("[HVH] State - Enabled: %s, Running: %s, AutoKill Enabled: %s, CycleActive: %s", 
                HVH.Enabled, HVH.Running, AutoKill.Enabled, AutoKill.CycleActive))
        end
        
        if not HVH.Enabled then 
            continue 
        end
        
        if HVH.Running then 
            continue 
        end
        
        if not AutoKill.Enabled then 
            continue 
        end
        
        if not AutoKill.CycleActive then 
            continue 
        end
        
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if not char or not hrp or not hum then 
            continue 
        end
        
        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        local currentHP = math.floor(hum.Health)
        
        -- Debug: print health when checking
        if healthPercent <= 75 then
            print(string.format("[HVH] Health check: %d HP (%.1f%%) - Threshold: 70%%", currentHP, healthPercent))
        end
        
        if healthPercent > 70 then 
            continue 
        end
        
        print(string.format("[HVH] ⚠️ HEALTH BELOW 70%%! Current HP: %d", currentHP))
        
        -- Find KO'd person
        local koTargets = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local tc = p.Character
                if tc then
                    local b = tc:FindFirstChild("BodyEffects")
                    if b then
                        local ko = b:FindFirstChild("K.O")
                        local dead = b:FindFirstChild("Dead")
                        if ko and ko.Value and (not dead or not dead.Value) then
                            local ut = tc:FindFirstChild("UpperTorso")
                            if ut then 
                                table.insert(koTargets, {player = p, ut = ut, char = tc, name = p.Name})
                            end
                        end
                    end
                end
            end
        end
        
        print(string.format("[HVH] Found %d KO'd players", #koTargets))
        
        if #koTargets == 0 then 
            print("[HVH] No KO'd players found, skipping")
            continue 
        end
        
        -- Pick random KO'd target
        local koTarget = koTargets[math.random(1, #koTargets)]
        if not koTarget then 
            continue 
        end
        
        print(string.format("[HVH] 🎯 Selected KO target: %s", koTarget.name))
        
        -- Mark HVH as running
        HVH.Running = true
        
        -- Save current target
        if AutoKill.Target then
            HVH.OriginalTarget = AutoKill.Target
            print(string.format("[HVH] Saved original target: %s", HVH.OriginalTarget.Name))
        end
        
        -- Get MainEvent
        local me = ReplicatedStorage:FindFirstChild("MainEvent")
        if not me then 
            print("[HVH] ❌ MainEvent not found!")
            HVH.Running = false 
            continue 
        end
        
        -- Stop AutoKill
        print("[HVH] Stopping AutoKill...")
        AutoKill.HVHPause = true
        if AutoKill.CycleActive then
            AutoKill.StopCycle()
        end
        
        task.wait(0.2)
        
        -- Save current position
        local ret = hrp.CFrame
        local ut = koTarget.ut
        local stompPosition = ut.Position + Vector3.new(0, 3.5, 0)
        
        print(string.format("[HVH] 📍 Teleporting to stomp position: %s", tostring(stompPosition)))
        
        -- Teleport and stomp with retry
        local stompSuccess = false
        for attempt = 1, 3 do
            pcall(function()
                -- Reset humanoid state
                hum.Sit = false
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                
                -- Clear velocity
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                
                -- Set network ownership
                pcall(function()
                    hrp:SetNetworkOwner(LocalPlayer)
                end)
                
                -- Teleport
                hrp.CFrame = CFrame.new(stompPosition)
                
                -- Force position update
                task.wait(0.05)
                hrp.CFrame = CFrame.new(stompPosition)
                
                -- Wait for teleport to register
                RunService.RenderStepped:Wait()
                task.wait(0.05)
                
                print(string.format("[HVH] Attempt %d: Stomping %s", attempt, koTarget.name))
                
                -- Stomp multiple times
                for i = 1, 5 do
                    me:FireServer("Stomp")
                    task.wait(0.08)
                end
                
                stompSuccess = true
                print("[HVH] ✅ Stomp completed!")
            end)
            
            if stompSuccess then break end
            print(string.format("[HVH] ⚠️ Stomp attempt %d failed, retrying...", attempt))
            task.wait(0.1)
        end
        
        if not stompSuccess then
            print("[HVH] ❌ All stomp attempts failed!")
        end
        
        -- Return to original position
        print("[HVH] 📍 Returning to original position")
        pcall(function()
            hrp.CFrame = ret
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
        
        task.wait(0.2)
        
        -- Resume AutoKill
        print("[HVH] Resuming AutoKill...")
        AutoKill.HVHPause = false
        
        -- Restore original target
        if HVH.OriginalTarget then
            local target = HVH.OriginalTarget
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local humTarget = target.Character:FindFirstChildOfClass("Humanoid")
                if humTarget and humTarget.Health > 0 then
                    AutoKill.Target = target
                    print(string.format("[HVH] Restored original target: %s", target.Name))
                else
                    print("[HVH] Original target is dead, finding new target")
                    AutoKill.Target = nil
                    AutoKill.AdvanceTarget()
                end
            else
                print("[HVH] Original target invalid, finding new target")
                AutoKill.Target = nil
                AutoKill.AdvanceTarget()
            end
        else
            print("[HVH] No original target, finding new target")
            AutoKill.Target = nil
            AutoKill.AdvanceTarget()
        end
        
        -- Restart AutoKill
        if AutoKill.Enabled then
            print("[HVH] Restarting AutoKill cycle")
            AutoKill.StartCycle()
        end
        
        HVH.OriginalTarget = nil
        
        -- Cooldown
        task.wait(0.5)
        HVH.Running = false
        print("[HVH] HVH cycle complete, ready for next trigger")
    end
end)

print("[HVH] ✅ HVH feature loaded - Check console for debug output")
print("trevor larp")
