local HVH = { Enabled = false, Running = false }

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(v)
        HVH.Enabled = v
        if not v then HVH.Running = false end
    end
})

task.spawn(function()
    while true do
        task.wait(0.1)
        
        if not HVH.Enabled or HVH.Running or not AutoKill.Enabled then
            continue
        end
        
        local char = LocalPlayer.Character
        if not char then continue end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then continue end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        if (hum.Health / hum.MaxHealth) * 100 > 70 then
            continue
        end
        
        -- Find KO
        local koTarget = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local c = p.Character
                if c then
                    local be = c:FindFirstChild("BodyEffects")
                    if be and be:FindFirstChild("K.O") and be.K.O.Value == true then
                        local dead = be:FindFirstChild("Dead")
                        if (not dead or dead.Value == false) and c:FindFirstChild("UpperTorso") then
                            koTarget = c.UpperTorso
                            break
                        end
                    end
                end
            end
        end
        
        if not koTarget then continue end
        
        HVH.Running = true
        local originalTarget = AutoKill.Target
        local mainEvent = ReplicatedStorage:FindFirstChild("MainEvent")
        
        if mainEvent and hrp and hum then
            -- Stop AutoKill
            AutoKill.Enabled = false
            AutoKill.CycleActive = false
            AutoKill.Target = nil
            task.wait(0.1)
            
            -- Teleport
            local origPos = hrp.CFrame
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            local pos = koTarget.Position + Vector3.new(0, 3.5, 0)
            hrp.CFrame = CFrame.new(pos)
            task.wait()
            hrp.CFrame = CFrame.new(pos)
            
            -- Stomp
            for i = 1, 5 do
                mainEvent:FireServer("Stomp")
                task.wait(0.05)
            end
            
            -- Return
            hrp.CFrame = origPos
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            task.wait(0.1)
            
            -- Resume
            AutoKill.Enabled = true
            if originalTarget and originalTarget.Character then
                local h = originalTarget.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then
                    AutoKill.Target = originalTarget
                else
                    AutoKill.AdvanceTarget()
                end
            else
                AutoKill.AdvanceTarget()
            end
            if AutoKill.Target then
                AutoKill.StartCycle()
            end
        end
        
        task.wait(0.2)
        HVH.Running = false
    end
end)

print("[HVH] Ultra-fast HVH loaded")
print("OPITMIZE")
