local HVH = { Enabled = false, Running = false }

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then 
            HVH.Running = false
            -- Resume normal AutoKill if it was paused
            if AutoKill.Enabled and AutoKill.HVHPause then
                AutoKill.HVHPause = false
                AutoKill.StartCycle()
            end
        end
    end
})
print("no more cuss word guys")

-- Main HVH loop
task.spawn(function()
    while true do
        task.wait()
        
        -- Check if HVH is enabled and not already running
        if not HVH.Enabled or HVH.Running then 
            continue 
        end
        
        -- Check if AutoKill is enabled
        if not AutoKill.Enabled then 
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
        
        -- Find a KO'd person
        local koTarget = nil
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
                                koTarget = {player = p, ut = ut} 
                                break 
                            end
                        end
                    end
                end
            end
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
        
        -- Pause AutoKill
        AutoKill.HVHPause = true
        if AutoKill.CycleActive then
            AutoKill.StopCycle()
        end
        
        -- Wait for AutoKill to fully stop
        task.wait(0.1)
        
        -- Teleport and stomp
        local success, err = pcall(function()
            -- Set physics root
            sethiddenproperty(hrp, "PhysicsRepRootPart", hrp)
            
            -- Reset humanoid state
            hum.Sit = false
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            
            -- Clear velocity and teleport
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
            
            -- Wait for teleport to register
            RunService.RenderStepped:Wait()
            
            -- Stomp multiple times
            for i = 1, 5 do
                me:FireServer("Stomp")
                task.wait(0.05)
            end
            
            -- Return to original position
            hrp.CFrame = ret
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyLinearVelocity = Vector3.zero
        end)
        
        if not success then
            warn("HVH error: " .. tostring(err))
        end
        
        -- Small delay
        task.wait(0.2)
        
        -- Resume AutoKill
        AutoKill.HVHPause = false
        if AutoKill.Enabled then
            AutoKill.StartCycle()
        end
        
        -- Wait before allowing another HVH cycle
        task.wait(0.5)
        HVH.Running = false
    end
end)

print("HVH feature loaded")
