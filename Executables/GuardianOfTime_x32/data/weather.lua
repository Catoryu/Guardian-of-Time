--[[
0 : Rien
1 : Pluie
2 : Forte pluie
3 : Neigeux
4 : Brumeux
5 : Orage
]]--

--Table contenant toutes les informations concernant la météo
weather = {
    {--Rain
        windRefreshCooldown = 100,
        maxWindSpeed = 300,
        minThick = 1,
        maxThick = 2,
        minLenght = 5,
        maxLenght = 13,
        dropSpeedRatio = 100,
        density = 0.01,
        windChangeForce = 15,
        colors = {122, 202, 247, 210}
    },
    
    {--Heavy rain
        windRefreshCooldown = 20,
        maxWindSpeed = 400,
        minThick = 1,
        maxThick = 2,
        minLenght = 8,
        maxLenght = 15,
        dropSpeedRatio = 150,
        density = 0.05,
        windChangeForce = 20,
        colors = {72, 152, 197, 210}
    },
    
    {--Snow
        windRefreshCooldown = 100,
        maxWindSpeed = 300,
        minThick = 4,
        maxThick = 6,
        minLenght = 4,
        maxLenght = 6,
        dropSpeedRatio = 50,
        density = 0.03,
        windChangeForce = 15,
        colors = {220, 242, 255, 210}
    }
}