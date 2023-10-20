--https://periodictable.com/Isotopes/093.239/index.full.dm.html

local nept = elements.allocate("RADI", "NEPT")
local prtc = elements.allocate("RADI", "PRTC")
local bryl = elements.allocate("RADI", "BRYL")

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

--bryl
elements.element(bryl, elements.element(elem.DEFAULT_PT_GOLD))
elements.property(bryl, "Name", "BRYL")
elements.property(bryl, "Description", "Beryllium. ")
elements.property(bryl, "Colour", 0xDADBDD)
elements.property(bryl, "MenuSection", elem.SC_SOLIDS)

elements.property(bryl, "Hardness", 1)
elements.property(bryl, "Falldown", 0)
elements.property(bryl, "Weight", 55)
elements.property(bryl, "Temperature", 295.15)
elements.property(bryl, "HighTemperature", 1560.15)
elements.property(bryl, "HighTemperatureTransition", elem.DEFAULT_PT_LAVA)
elements.property(bryl, "HighPressure", 150)
elements.property(bryl, "HighTemperatureTransition", elem.DEFAULT_PT_BRMT)


local function neptUpdate(i, x, y, s, nt)
    for r in sim.neighbors(x, y, 1, 1) do
        local elem_id = tpt.get_property("type", r)

        function decay()
            if math.random(1,10) == 10 then
                tpt.set_property("type", "PRTC", r)
            else
                tpt.set_property("type", "PLUT", r)
            end

            local rand1 = math.random(0,2)
            if rand1 == 0 or rand1 == 1 then
                tpt.create(x+math.random(-1,1), y+math.random(-1,1), 'PROT')
            end

            if rand1 == 2 then
                tpt.create(x+math.random(-1,1), y+math.random(-1,1), 'NEUT')
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
tpt.element_func(neptUpdate, tpt.element("NEPT"))
local function neptEffect(i, colr, colg, colb)
    return 1, ren.PMODE_GLOW, 110, colr, colg, colb
end
elem.property(nept, "Graphics", neptEffect)



local function prtcUpdate(i, x, y, s, nt)
    for r in sim.neighbors(x, y, 1, 1) do
        local elem_id = tpt.get_property("type", r)
        
        function decay()
            tpt.create(x+math.random(-1,1), y+math.random(-1,1), 'NEUT')
            if math.random(1,50) == 1 then
                tpt.set_property('type', 'URAN', r)
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
tpt.element_func(prtcUpdate, tpt.element("PRTC"))
local function prtcEffect(i, colr, colg, colb)
    return 1, ren.PMODE_GLOW, 120, colr, colg, colb
end
elem.property(prtc, "Graphics", prtcEffect)



local function brylUpdate(i,x,y,s,nt)
    for r in sim.neighbors(x, y, 1, 1) do
        local elem_id = tpt.get_property("type", r)

        if elem.property(elem_id,'Name') == 'PROT' then
            if math.random(0,1) == 1 then
                tpt.set_property('type', 'NEUT', r)
            end
        end
    end
end
tpt.element_func(brylUpdate, tpt.element("BRYL"))
local function brylEffect(i, colr, colg, colb)
    return 1, ren.PMODE_GLOW, 120, colr, colg, colb
end
elem.property(bryl,"Graphics", brylEffect)
