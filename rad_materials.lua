--https://periodictable.com/Isotopes/093.239/index.full.dm.html

local nept = elements.allocate("RADI", "NEPT")
local prtc = elements.allocate("RADI", "PRTC")

--nept
elements.element(nept, elements.element(elem.DEFAULT_PT_PLUT))
elements.property(nept, "Name", "NEPT")
elements.property(nept, "Description", "Neptunium-239. Decays from U-239 and to Pu-239. 0.001% chance to decay per frame.")
elements.property(nept, "Colour", 0x71797E)
elements.property(nept, "MenuSection", elem.SC_NUCLEAR)
elements.property(nept, "Weight", 91)
elements.property(nept, "Temperature", 295.15)
elements.property(nept, "HighTemperature", 917.15)
elements.property(nept, "HighTemperatureTransition", elem.DEFAULT_PT_LAVA)

--prtc
elements.element(prtc, elements.element(elem.DEFAULT_PT_POLO))
elements.property(prtc, "Name", "PRTC")
elements.property(prtc, "Description", "Protactinium-239. Very Radioactive. 10% chance to decay from Np-239")
elements.property(prtc, "Colour", 0x81A488)
elements.property(prtc, "MenuSection", elem.SC_NUCLEAR)
elements.property(prtc, "Weight", 89)
elements.property(prtc, "Temperature", 295.15)
elements.property(prtc, "HighTemperature", 1841.15)
elements.property(prtc, "HighTemperatureTransition", elem.DEFAULT_PT_LAVA)

local function neptUpdate(i, x, y, s, nt)
    for r in sim.neighbors(x, y, 1, 1) do
        local elem_id = sim.partProperty(r,"type")

        function decay()
            if math.random(1,10) == 10 then
                sim.partChangeType(r, elem.RADI_PT_PRTC)
                sim.partKill(i)
            else
                sim.partChangeType(r, elem.DEFAULT_PT_PLUT)
                sim.partKill(i)
            end

            local rand1 = math.random(0,2)
            if rand1 == 0 or rand1 == 1 then
                sim.partCreate(-3, x+math.random(-1,1), y+math.random(-1,1), elem.DEFAULT_PT_PROT)
            end

            if rand1 == 2 then
                sim.partCreate(-3, x+math.random(-1,1), y+math.random(-1,1), elem.DEFAULT_PT_NEUT)
            end
        end

        if math.random(1,100000) == 1 then --chance
            decay()
        end

        if elem.property(elem_id,'Name') == 'NEUT' then
            decay()
        end
    end
end

local function prtcUpdate(i, x, y, s, nt)
    for r in sim.neighbors(x, y, 1, 1) do
        local elem_id = sim.partProperty(r,"type")
        
        function decay()
            sim.partCreate(-3, x+math.random(-1,1), y+math.random(-1,1), elem.DEFAULT_PT_NEUT)
            if math.random(1,25) == 1 then
                sim.partChangeType(r, elem.DEFAULT_PT_URAN)
                sim.partKill(i)
            end
        end
        
        if math.random(1,10000) == 1 then
            decay()
        end

        if elem.property(elem_id,'Name') == 'NEUT' then
            if math.random(1,1000) == 1 then
                decay()
            end
        end
    end
end

local function nepteffect(i, colr, colg, colb)
    return 1, ren.PMODE_GLOW, 150, colr, colg, colb
end
local function prtceffect(i, colr, colg, colb)
    return 1, ren.PMODE_GLOW, 150, colr, colg, colb
end



elem.property(nept, "Update", neptUpdate)
elem.property(nept,"Graphics", nepteffect)

elem.property(prtc, "Update", prtcUpdate)
elem.property(prtc,"Graphics", prtceffect)