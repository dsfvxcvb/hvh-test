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

-- Main HVH loop
task.spawn(function()
    while true do
        task.wait(0.2)
        
        -- Skip if not enabled or already running
        if not HVH.Enabled or HVH.Running then
            continue
        end
        
        -- Skip if AutoKill isn't enabled
        if not AutoKill.Enabled then
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
        
        print(string.format("[HVH] Health below 70%%! (%d HP)", math.floor(hum.Health)))
        
        -- Find a KO'd player
        local koTarget = nil
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
        
        -- Save original target
        HVH.OriginalTarget = AutoKill.Target
        
        -- ===== STOP AUTO KILL =====
        print("[HVH] Stopping AutoKill...")
        
        -- Disable AutoKill completely
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
            local originalCFrame = hrp.CFrame
            
            print("[HVH] Teleporting to stomp...")
            
            -- Reset humanoid
            hum.Sit = false
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            
            -- Clear velocity
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            
            -- Teleport to KO'd player
            local teleportPos = koTarget.upperTorso.Position + Vector3.new(0, 3.5, 0)
            
            -- Force teleport
            hrp.CFrame = CFrame.new(teleportPos)
            task.wait(0.1)
            hrp.CFrame = CFrame.new(teleportPos)
            RunService.RenderStepped:Wait()
            
            print("[HVH] Stomping...")
            
            -- Stomp 5 times
            for i = 1, 5 do
                mainEvent:FireServer("Stomp")
                task.wait(0.1)
            end
            
            print("[HVH] Stomp complete, returning...")
            
            -- Return to original position
            hrp.CFrame = originalCFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            
            task.wait(0.2)
        else
            print("[HVH] Failed to stomp!")
        end
        
        -- ===== RESUME AUTO KILL =====
        print("[HVH] Resuming AutoKill...")
        
        -- Restore original target if still valid
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
        
        -- Re-enable AutoKill
        AutoKill.Enabled = true
        AutoKill.HVHPause = false
        
        -- Start AutoKill if we have a target
        if AutoKill.Target then
            AutoKill.StartCycle()
        end
        
        -- Reset
        HVH.OriginalTarget = nil
        task.wait(0.5)
        HVH.Running = false
        
        print("[HVH] HVH cycle complete")
    end
end)

print("[HVH] Loaded - Will stomp KO'd players when health drops below 70%")
print("re opt\ttttt")
