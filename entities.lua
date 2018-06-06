--Entities creation

class = {

}

player = {
    hitbox = lobj_shape_rectangle:new(),
    weapon = {
        {
            name = "Chain"
        },
        {
            name = "Frost Gale"
        }
    },
    specie = {
        {
            name = "Human"
        },
        {
            name = "Human Cat"
        },
        {
            name = "Dragon Cat"
        }
    },
    clothes = {
        {
            name = "Magic School Uniform"
        },
        {
            name = "SPR Elite Clothes"
        }
    },
    jump = {

    },
    dash = {

    },
    front_attack = {

    },
    back_attack = {

    },
    up_attack = {

    },
    down_attack = {

    },
    air_attack = {

    },
    dash_attack = {

    },
    special_attack = {

    }
}

player.hitbox:setXYWH(20, 20, 50, 100)
