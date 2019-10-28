include("controllers/chat/functions.nut");
include("controllers/chat/commands.nut");
include("controllers/chat/history.nut");



alternativeTranslate({

    "en|admin.oocEnabled.message"      : "General chat enabled by administrator!"
    "en|admin.oocDisabled.message"     : "General chat disabled by administrator!"



    "en|general.message.empty"         : "[INFO] You can't send an empty message",
    "ru|general.message.empty"         : "[INFO] Вы не можете отправить пустое сообщение."

    "en|general.playeroffline"         : "[INFO] There's no such person on server!",
    "ru|general.playeroffline"         : "[INFO] Данного игрока нет на сервере!"

    "en|general.noonearound"           : "There's noone around near you.",
    "ru|general.noonearound"           : "Рядом с вами никого нет."



    "en|chat.togoocEnabled"            : "Displaying OOC chat has been enabled!"
    "ru|chat.togoocEnabled"            : "Вы включили отображение ООС чата!"

    "en|chat.togoocDisabled"           : "Displaying OOC chat has been disabled!"
    "ru|chat.togoocDisabled"           : "Вы отключили отображение ООС чата!"

    "en|chat.togoocDisabledAlready"    : "You have disabled display of general chat! To enable: /togooc"
    "ru|chat.togoocDisabledAlready"    : "У вас отключено отображение ООС чата! Включить: /togooc"


    "en|chat.togpmEnabled"             : "Receiving private messages has been enabled!"
    "ru|chat.togpmEnabled"             : "Вы включили получение личных сообщений!"

    "en|chat.togpmDisabled"            : "Receiving private messages has been disabled!"
    "ru|chat.togpmDisabled"            : "Вы отключили получение личных сообщений!"

    "en|chat.togpmDisabledAlready"     : "You have disabled private message! To enable: /togpm"
    "ru|chat.togpmDisabledAlready"     : "У вас отключены личные сообщения! Включить: /togpm"

    "en|chat.playerTogPm"              : "Player has disabled a private message!"
    "ru|chat.playerTogPm"              : "Игрок отключил возможность отправлять ему личные сообщения!"

    "ru|antiflood.message"             : "Антифлуд: Для отправки сообщения подождите еще %i секунд"
    "en|antiflood.message"             : "Aniflood: wait a %i seconds."



    "en|chat.player.says"              : "%s: %s"
    "ru|chat.player.says"              : "%s: %s"

    "en|chat.player.me"                : "[ME] %s %s"
    "ru|chat.player.me"                : "[ME] %s %s"

    "en|chat.player.do"                : "[DO] %s (%s)"
    "ru|chat.player.do"                : "[DO] %s (%s)"

    "en|chat.player.todo.me"           : "[ME] %s"
    "ru|chat.player.todo.me"           : "[ME] %s"

    "en|chat.player.b"                 : "%s: %s"
    "ru|chat.player.b"                 : "%s: %s"

    "en|chat.player.shout"             : "%s shout: %s"
    "ru|chat.player.shout"             : "%s крикнул: %s"

    "en|chat.player.whisper"           : "%s whisper: %s"
    "ru|chat.player.whisper"           : "%s шепчет: %s"

    "en|chat.player.try.end.success"   : "[TRY] %s: %s (success)"
    "ru|chat.player.try.end.success"   : "[TRY] %s: %s (успех)"

    "en|chat.player.try.end.fail"      : "[TRY] %s: %s (failed)"
    "ru|chat.player.try.end.fail"      : "[TRY] %s: %s (провал)"

    "en|chat.player.todo.badformat1"   : "Invalid format message!"
    "ru|chat.player.todo.badformat1"   : "Неверный формат сообщения!"

    "en|chat.player.todo.badformat2"   : "Use: /todo words * action"
    "ru|chat.player.todo.badformat2"   : "Используй: /todo реплика персонажа * действие"

    "en|chat.player.message.error"     : "[PM] You should provide pm in a following format: /pm id text",
    "ru|chat.player.message.error"     : "[PM] Формат личного сообщения: /pm id текст",

    "en|chat.player.message.private"   : "[PM] %s to %s: %s",
    "ru|chat.player.message.private"   : "[PM] %s пишет %s: %s"

    "en|chat.player.message.noplayer"  : "[PM] Player is not connected",
    "ru|chat.player.message.noplayer"  : "[PM] Такого игрока нет на сервере.",



    "en|chat.bug.success"              : "[BUG] Your bug report is successfuly saved. Thank you!"
    "ru|chat.bug.success"              : "[BUG] Ваше сообщение об ошибке успешно отправлено. Спасибо! ;)"

    "en|chat.idea.success"             : "[IDEA] Your idea has been successfuly submitted!"
    "ru|chat.idea.success"             : "[IDEA] Ваша идея успешно отправлена!"

    "en|chat.report.success"           : "[REPORT] Your report has been successfuly submitted!"
    "ru|chat.report.success"           : "[REPORT] Ваш репорт успешно отправлен!"


    "en|chat.report.noplayer"          : "[REPORT] You can't report about player, which is not connected!"
    "ru|chat.report.noplayer"          : "[REPORT] Вы не можете создать репорт на игрока, который находится в оффлайн!"

    "en|chat.report.error"             : "[REPORT] You should provide report in a following format: /report ID TEXT"
    "ru|chat.report.error"             : "[REPORT] Вам необходимо отправить репорт в виде: /report id text"


// help

    "en|help.chat"              : "Show list of commands for chat"
    "ru|help.chat"              : "команды чата"

    "en|help.subway"            : "Show list of commands for subway"
    "ru|help.subway"            : "команды метро"

    "en|help.taxi"              : "Show list of commands for taxi"
    "ru|help.taxi"              : "команды такси"

    "en|help.rentcar"           : "Show list of commands for rent car"
    "ru|help.rentcar"           : "команды аренды авто"

    "en|help.job"               : "Show list of commands for job. Example: /help job"
    "ru|help.job"               : "команды работ"

    "en|help.bank"              : "Show list of commands for bank"
    "ru|help.bank"              : "команды банка"

    "en|help.donate"            : "Not available for english-speaking players"
    "ru|help.donate"            : "информация о донате"

    "en|help.cars"              : "Show list of commands for cars"
    "ru|help.cars"              : "команды для автомобилей"

    "en|help.fuel"              : "Show list of commands for fuel stations"
    "ru|help.fuel"              : "команд для автозаправок"

    "en|help.repair"            : "Show list of commands for repiair shop"
    "ru|help.repair"            : "Показать список команд для автомастерских"

    "en|help.report"            : "Report about player which is braking the rules"
    "ru|help.report"            : "Сообщить о читере или игроке, нарушающем правила"

    "en|help.idea"              : "Send your idea to developers"
    "ru|help.idea"              : "Отправить идею/сообщение разработчикам"


// /help chat

    "en|help.chat.ooc"         : "Global nonRP chat"
    "ru|help.chat.ooc"         : "Отправить сообщение в глобальный нон-РП чат"

    "en|help.chat.localooc"    : "Local nonRP chat"
    "ru|help.chat.localooc"    : "Отправить сообщение в локальный нон-РП чат"

    "en|help.chat.say"         : "Put your text in local RP chat (also use /i TEXT)"
    "ru|help.chat.say"         : "Сказать от имени персонажа."

    "en|help.chat.shout"       : "Your message could be heard far enough"
    "ru|help.chat.shout"       : "Крикнуть от имени персонажа."

    "en|help.chat.whisper"     : "Say something to nearest player very quiet"
    "ru|help.chat.whisper"     : "Прошептать от имени персонажа ближайшему игроку."

    "en|help.chat.me"          : "Some action of your person"
    "ru|help.chat.me"          : "Сообщить о действии вашего персонажа"

    "en|help.chat.do"          : "Some action of the game world at now"
    "ru|help.chat.do"          : "Сообщить о подробностях игрового мира в данный момент"

    "en|help.chat.todo"        : "Combination of /ic and /me"
    "ru|help.chat.todo"        : "Совмещение /ic и /me"

    "en|help.chat.try"         : "Any action simulation that could be failed"
    "ru|help.chat.try"         : "Сообщить о попытке выполнения действия со случайным результатом"

    "en|help.chat.privatemsg"  : "Send private message to other player with ID. Example: /pm 3 Hello!"
    "ru|help.chat.privatemsg"  : "Отправить личное сообщение другому игроку. Образец: /pm 3 Привет!"

    "en|help.chat.reply"       : "Reply to private message. Example: /re Hello!"
    "ru|help.chat.reply"       : "Ответить на личное сообщение. Образец: /re Привет!"


});















// settings
const NORMAL_RADIUS = 20.0;
const WHISPER_RADIUS = 4.0;
const SHOUT_RADIUS = 35.0;


const ANTIFLOOD_GLOBAL_OOC_CHAT = 5; // Anti-flood 5 seconds

local inputRequests = {};

// event handlers
event("native:onPlayerChat", function(playerid, message) {
    if (!isPlayerLogined(playerid)) {
        return false;
    }

    if (message.len() >= 3) {
        if(message[0] == '-' && message[1] == ' ' && message[2] == ' ') {
            dbg("admin", "kicked", getPlayerName(playerid));
            kickPlayer( playerid );
            return false;
        }
    }

    if (message.len() < 1 || message[0] == '.') {
        return false;
    }

    // reroute input to callbacks
    if (playerid in inputRequests) {
        if (inputRequests[playerid].timeout > getTimestamp()) {
            inputRequests[playerid].callback(playerid, message);
            delete inputRequests[playerid];
            return false;
        }

        delete inputRequests[playerid];
    }

    // NOTE(inlife): make sure array looks exactly like the one in the client/screen.nut
    local chatslots = ["ooc", "ic", "b", "s", "w", "me", "todo", "do", "try"];
    local slot = getPlayerChatSlot(playerid);

    /**
     * убираем пробелы в начале и конце сообщения
     * пытаемся определить слот поиском " me" и "do" в конце сообщения
     * если находим - определяем номер слота и обрезаем тип слота
     */
    local message = strip(message);
    local match = regexp(@"\s(ooc|ic|b|s|w|me|todo|do|try)$").search(message);

    if (match) {
        local slotText = message.slice(match.begin, match.end);
        local slotNumber = chatslots.find(strip(slotText));
        if (slotNumber != null) {
            slot = slotNumber;
            message = message.slice(0, match.begin);
        }
    }

    /**  end  */

    // push to selected chat
    if (slot in chatslots) {
        __commands[chatslots[slot]][COMMANDS_DEFAULT](playerid, message);
    }

    setPlayerAfk(playerid, false);

    return false;
});

/**
 * Use this method for forcing user to
 * input some information into the chat
 *
 * @param  {Integer}  playerid
 * @param  {Function} callback
 * @return {Boolean}
 */
function requestUserInput(playerid, callback, timeout = 30) {
    return inputRequests[playerid] <- { callback = callback, timeout = (getTimestamp() + timeout) };
}

/**
 * Return true if there's timer in
 * inputRequest for given player
 * @param  {Integer}  playerid
 * @return {Boolean}
 */
function isWaitingUserInput(playerid) {
    return (playerid in inputRequests);
}

/**
 * Delete waiting for player input timer
 * @param  {Integer} playerid
 * @return {void}
 */
function clearUserInput(playerid) {
    if ( isWaitingUserInput(playerid) ) {
        delete inputRequests[playerid];
    }
}
