/**
 * @param  {[type]}   names    [description]
 * @param  {Function} callback [description]
 * @return {[type]}            [description]
 */
function policecmd(names, callback)  {
    cmd(names, function(playerid, ...) {

        local character = players[playerid];

        if(!fractions["police"].exists(character)) {
            return;
        }

        if(!fractions["police"].exists(playerid)) {
            return;
        }


        local text = concat(vargv);

        if (!text || text.len() < 1) {
            return msg(playerid, "general.message.empty", CL_YELLOW);
        }

        // call registered callback
        return callback(playerid, text);
    });
}


function newPoliceGetPermissionByRank(rank) {
    return police_rank[rank];
}


/*
"wanted_read"       // смотреть розыск
"wanted_add"        // подавать в розыск
"wanted_delete"     // убирать из розыска
"ticket"            // выписывать штраф
"park"              // отправлять автомобиль на штрафстоянку
"jail"              // сажать в тюрьму
"amnesty"           // амнистировать
"give_key"          // давать ключи от служебных автомобилей
"civilian_clothes"  // быть на службе в гражданской одежде

"weapons"           // доступ к оружию

"car40"             // пользоваться полицейским автомобилем 40х годов
"car50"             // пользоваться полицейским автомобилем 50х годов
"bus"               // пользоваться полицейским автобусом
"detective_car"     // пользоваться машиной детектива
*/
