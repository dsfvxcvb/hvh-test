local HVH = {
    Enabled = false,
    Running = false,
    ReturnCF = nil,
}

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then
            HVH.Running = false
            HVH.ReturnCF = nil
        end
    end
})

task.spawn(function()
    while true do
        task.wait()
        if not HVH.Enabled or HVH.Running then continue end
        if not AutoKill.Enabled then continue end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hrp or not hum then continue end
        if hum.Health <= 0 then continue end
        if (hum.Health / hum.MaxHealth) * 100 > 70 then continue end

        -- find KO'd target
        local koTarget = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local tc = p.Character
                if tc then
                    local b = tc:FindFirstChild("BodyEffects")
                    local ko = b and b:FindFirstChild("K.O")
                    local dead = b and b:FindFirstChild("Dead")
                    if ko and ko.Value and dead and not dead.Value then
                        local ut = tc:FindFirstChild("UpperTorso")
                        if ut then
                            koTarget = {player = p, ut = ut}
                            break
                        end
                    end
                end
            end
        end

        if not koTarget then continue end

        HVH.Running = true
        AutoKill.Enabled = false
        AutoKill.CycleActive = false
        task.wait(0.1)

        local me = ReplicatedStorage:FindFirstChild("MainEvent")
        if not me then
            AutoKill.Enabled = true
            AutoKill.StartCycle()
            HVH.Running = false
            continue
        end

        if not HVH.ReturnCF then HVH.ReturnCF = hrp.CFrame end

        -- exact working stomp pattern
        local ut = koTarget.ut
        if ut and ut.Parent then
            hum.Sit = false
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hrp.Velocity = Vector3.zero
            hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
            RunService.RenderStepped:Wait()
            for _ = 1, 5 do me:FireServer("Stomp") end
            hrp.CFrame = HVH.ReturnCF
        end

        task.wait()

        -- check if still KO'd, if not then done
        local tc = koTarget.player.Character
        local b = tc and tc:FindFirstChild("BodyEffects")
        local ko = b and b:FindFirstChild("K.O")
        if not ko or not ko.Value then
            HVH.ReturnCF = nil
            HVH.Running = false
            AutoKill.Enabled = true
            AutoKill.StartCycle()
        end
        -- if still KO'd, loop will run again next tick automatically
        -- since HVH.Running is still true it won't double-trigger
        HVH.Running = false
    end
end)
