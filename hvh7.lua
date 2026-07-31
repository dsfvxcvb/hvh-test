local HVH = { Enabled = false, Running = false, OriginalTarget = nil }

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then 
            HVH.Running = false
            HVH.OriginalTarget = nil
            -- Resume normal AutoKill if it was paused
            if AutoKill.Enabled and AutoKill.HVHPause then
                AutoKill.HVHPause = false
                AutoKill.StartCycle()
            end
        end
    end
})

-- Main HVH loop - checks health during auto-killing
task.spawn(function()
    while true do
        task.wait(0.1) -- Check more frequently
        
        -- Check if HVH is enabled and not already running
        if not HVH.Enabled or HVH.Running then 
            continue 
        end
        
        -- Check if AutoKill is enabled and actively killing
        if not AutoKill.Enabled or not AutoKill.CycleActive then 
            continue 
        end
        
        -- Get local player character
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if not char or not hrp or not hum then 
            continue 
        end
        
        -- Check if health is below 70%
        local healthPercent = (hum.Health / hum.MaxHealth) * 100
        if healthPercent > 70 then 
            continue 
        end
        
        -- Save current target before stopping
        if AutoKill.Target then
            HVH.OriginalTarget = AutoKill.Target
        end
        
        -- Find a random KO'd person (prefer someone different from current target)
        local koTargets = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local tc = p.Character
                if tc then
                    local b = tc:FindFirstChild("BodyEffects")
                    if b then
                        local ko = b:FindFirstChild("K.O")
                        local dead = b:FindFirstChild("Dead")
                        -- Check if KO'd but not dead
                        if ko and ko.Value and (not dead or not dead.Value) then
                            local ut = tc:FindFirstChild("UpperTorso")
                            if ut then 
                                table.insert(koTargets, {player = p, ut = ut, char = tc})
                            end
                        end
                    end
                end
            end
        end
        
        -- No KO'd targets available, skip HVH
        if #koTargets == 0 then 
            continue 
        end
        
        -- Pick random KO'd target (prefer not the current target)
        local koTarget = nil
        local currentTarget = AutoKill.Target
        
        -- Try to find a KO'd target that isn't our current target
        local filtered = {}
        for _, target in ipairs(koTargets) do
            if target.player ~= currentTarget then
                table.insert(filtered, target)
            end
        end
        
        if #filtered > 0 then
            koTarget = filtered[math.random(1, #filtered)]
        else
            koTarget = koTargets[math.random(1, #koTargets)]
        end
        
        if not koTarget then 
            continue 
        end
        
        -- Mark HVH as running
        HVH.Running = true
        
        -- Get MainEvent
        local me = ReplicatedStorage:FindFirstChild("MainEvent")
        if not me then 
            HVH.Running = false 
            continue 
        end
        
        -- Save current position
        local ret = hrp.CFrame
        local ut = koTarget.ut
        local targetName = koTarget.player.Name
        
        -- Stop AutoKill temporarily
        AutoKill.HVHPause = true
        
        -- Stop the current auto-kill cycle
        if AutoKill.CycleActive then
            AutoKill.StopCycle()
        end
        
        -- Wait for AutoKill to fully stop (very important)
        task.wait(0.15)
        
        -- Teleport and stomp the KO'd person
        local success, err = pcall(function()
            -- Reset humanoid state
            hum.Sit = false
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            
            -- Clear velocity
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            
            -- Teleport to KO'd person (position to stomp)
            hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
            
            -- Wait for teleport to register
            RunService.RenderStepped:Wait()
            task.wait(0.05)
            
            -- Stomp multiple times for maximum health regen
            for i = 1, 5 do
                me:FireServer("Stomp")
                task.wait(0.08)
            end
            
            -- Wait for health to register
            task.wait(0.1)
            
            -- Return to original position
            hrp.CFrame = ret
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
        
        if not success then
            warn("[HVH] Error during stomp: " .. tostring(err))
        end
        
        -- Small delay
        task.wait(0.2)
        
        -- Resume AutoKill with original target
        AutoKill.HVHPause = false
        
        -- Restore original target if it still exists and is valid
        if HVH.OriginalTarget then
            local target = HVH.OriginalTarget
            -- Check if target is still valid
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local humTarget = target.Character:FindFirstChildOfClass("Humanoid")
                if humTarget and humTarget.Health > 0 then
                    AutoKill.Target = target
                else
                    -- Target died, advance to next
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
        
        -- Restart AutoKill
        if AutoKill.Enabled then
            AutoKill.StartCycle()
        end
        
        -- Clear original target
        HVH.OriginalTarget = nil
        
        -- Cooldown before next HVH check
        task.wait(0.5)
        HVH.Running = false
    end
end)

print("[HVH] HVH feature loaded - will stomp KO'd players when health drops below 70%")
print("not a slave black boy")
