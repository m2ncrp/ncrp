cmd("stats", function(playerid) {

    local char = players[playerid];

    msgh(playerid, "Информация о персонаже", [
        format("Имя и фамилия: %s", getPlayerName(playerid)),
        format("Дата рождения: %s", char.birthdate),
        format("Национальная принадлежность: %s", plocalize(playerid, "nationality."+char.nationality)),
        format("Наличных денег: $ %.2f", char.money),
        format("Текущая работа: %s", getLocalizedPlayerJob(playerid)),
        format("Суммарное время в игре: %s", convertMinutesToFormattedString(char.xp)),
        "Статистика по работам: /stats job"
    ]);
});


cmd("stats", "job", function(playerid) {

    local jobs = players[playerid].data.jobs;

    local lines = []
    foreach(idx, job in jobs) {
        local count = "";
        if(idx == "police") {
            count = convertMinutesToFormattedString(job.count);
        }
        else if(idx == "porter" || idx == "docker") {
            count = format("%d %s", job.count, declOfNum(job.count, ["ящик", "ящика", "ящиков"]));
        }
        else {
            count = format("%d %s", job.count, declOfNum(job.count, ["рейс", "рейса", "рейсов"]));
        }
        lines.push(format("%s: %s", plocalize(playerid, "job."+idx), count));
    }
    msgh(playerid, "Статистика по работам", lines);
});


function convertMinutesToFormattedString(xp) {
    local hours = round(xp / 60, 1);
    local mins = xp % 60;
    local str = "";

    if(hours > 0) {
        str += format("%d %s ", hours, declOfNum(hours, ["час", "часа", "часов"]));
    }
    if(mins != 0) {
        str += format("%d %s", mins, declOfNum(mins, ["минута", "минуты", "минут"]));
    }

    return trim(str);
}