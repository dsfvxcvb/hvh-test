local HVH = {
    Enabled = false,
    Running = false,
}
print("Nica boo test")

CombatAutoKill:AddToggle('HVHEnabled', {
    Text = "HVH",
    Default = false,
    Callback = function(Value)
        HVH.Enabled = Value
        if not Value then HVH.Running = false end
    end
})

task.spawn(function()
    while true do
        task.wait()
        if not HVH.Enabled then continue end
        if HVH.Running then continue end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hrp or not hum then continue end

        local hp = (hum.Health / hum.MaxHealth) * 100
        if hp > 70 then continue end

        print("[HVH] health low:", hp, "- scanning for KO target")

        local koTarget = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local tc = p.Character
                if tc then
                    local b = tc:FindFirstChild("BodyEffects")
                    local ko = b and b:FindFirstChild("K.O")
                    local dead = b and b:FindFirstChild("Dead")
                    print("[HVH] checking", p.Name, "ko:", ko and ko.Value, "dead:", dead and dead.Value)
                    if ko and ko.Value and dead and not dead.Value then
                        local ut = tc:FindFirstChild("UpperTorso")
                        if ut then
                            koTarget = {player = p, ut = ut}
                            print("[HVH] found target:", p.Name)
                            break
                        end
                    end
                end
            end
        end

        if not koTarget then print("[HVH] no KO target found") continue end

        HVH.Running = true
        print("[HVH] stomping:", koTarget.player.Name)

        local me = ReplicatedStorage:FindFirstChild("MainEvent")
        if not me then print("[HVH] no MainEvent") HVH.Running = false continue end

        local ret = hrp.CFrame
        local ut = koTarget.ut

        pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)

        hum.Sit = false
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hrp.Velocity = Vector3.zero
        hrp.CFrame = CFrame.new(ut.Position + Vector3.new(0, 3.5, 0))
        RunService.RenderStepped:Wait()
        for _ = 1, 5 do me:FireServer("Stomp") end
        hrp.CFrame = ret
        hrp.Velocity = Vector3.zero
        print("[HVH] done stomping, returning")

        task.wait(0.5)
        HVH.Running = false
    end
end)
