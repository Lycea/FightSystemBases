local list ={}

local object ={}
function object:new(o)
 o = o or {}
 o.name=o.name or ""
 o.id = o.id or 0
 o.type = o.type or "none"
 o.click =function() end
 o.release=function() end
end



--new crops are always in the odd indexes(even are the wet tiles
list.crops={
  flow_blue=1,
  tunip =3,
  tomatoe=5
}

list.objects={
  seed_bag = 5 -- seeds are always on the 5 state ... 1-4 are different frame stats
}



---------------------------------------
--tools and info
--item indexes
list.tools={
    hoe=1,
    water_can=2,
    axe =3
    }

list.tools.max={
hoe=1,
water_can=1,
axe=1
}





-------------------------



list.ids =
{
    tools={
        "hoe",
        "water_can",
        "axe"},
    crops={
        "flow_blue",
        "tunip",
        "tomatoe"},
    items={
        }
}

return list