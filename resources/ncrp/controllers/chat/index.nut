include("controllers/chat/functions.nut");
include("controllers/chat/commands.nut");

translation("en", {
    "general.message.empty"         : "[INFO] You can't send an empty message",
    "general.noonearound"           : "There's noone around near you.",

    "chat.player.says"              : "%s says: %s",
    "chat.player.shout"             : "%s shout: %s",
    "chat.player.whisper"           : "%s whisper: %s",
    "chat.player.message.private"   : "[PM] %s: %s",
    "chat.player.message.error"     : "[PM] You should provide pm in a following format: /pm ID TEXT",
    "chat.player.message.noplayer"  : "[PM] Player is not connected",
    "chat.player.try.end.success"   : "[TRY] %s try %s (success).",
    "chat.player.try.end.fail"      : "[TRY] %s try %s (failed)."

    "chat.idea.success"             : "[IDEA] Your idea has been successfuly submitted!"
    "chat.report.success"           : "[REPORT] Your report has been successfuly submitted!"
    "chat.report.noplayer"          : "[REPORT] You can't report about player, which is not connected!"
    "chat.report.error"             : "[REPORT] You should provide report in a following format: /report ID TEXT"
});

// help
translation("en", {
    "help.chat"        : "Show list of commands for chat"
    "help.subway"      : "Show list of commands for subway"
    "help.taxi"        : "Show list of commands for taxi"
    "help.rentcar"     : "Show list of commands for rent car"
    "help.job"         : "Show list of commands for job. Example: /help job taxi"
    "help.ban"         : "Show list of commands for bank"
    "help.cars"        : "Show list of commands for cars"
    "help.fuel"        : "Show list of commands for fuel stations"
    "help.repair"      : "Show list of commands for repiair shop"
    "help.report"      : "Report about player which is braking the rules"
    "help.idea"        : "Send your idea to developers"
});

translation("en", {
    "help.chat.say"         : "Put your text in local RP chat (also use /i TEXT)"
    "help.chat.shout"       : "Your message could be heard far enough :) (also use /s TEXT)"
    "help.chat.whisper"     : "Say something to nearest player very quiet (also use /w TEXT)"
    "help.chat.localooc"    : "Local nonRP chat"
    "help.chat.ooc"         : "Global nonRP chat"
    "help.chat.privatemsg"  : "Send private message to other player with ID. Example: /pm 3 hello!"
    "help.chat.me"          : "Some action of your person"
    "help.chat.try"         : "Any action simulation that could be failed"
});

// settings
const NORMAL_RADIUS = 20.0;
const WHISPER_RADIUS = 4.0;
const SHOUT_RADIUS = 35.0;

// event handlers
event("native:onPlayerChat", function(playerid, message) {
    if (!isPlayerLogined(playerid)) {
        return false;
    }

    __commands["ooc"][COMMANDS_DEFAULT](playerid, message);
    return false;
});
