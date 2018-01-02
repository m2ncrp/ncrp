local INVITATION_TIMEOUT = 5 * 60; // 5 minutes
local invites = {};

/**
 * Clear all outdated invitations
 * @param  {Integer} playerid
 */
local function clearInvitations(playerid) {
    if (!(playerid in invites)) return;

    local cinvites = clone(invites[playerid]);

    foreach (idx, value in cinvites) {
        if (value.created + INVITATION_TIMEOUT < getTimestamp()) {
            invites[playerid].remove(idx);
        }
    }
}

event("onPlayerDisconnect", function(playerid, reason = null) {
    clearInvitations(playerid);
});

/**
 * Invite player to join fraction
 * @param  {Integer} playerid
 * @param  {Integer} targetid
 * @param  {Mixed} role_shortcut
 */
fmd("*", ["members.invite"], ["$f invite"], function(fraction, character, targetid = -1, role_shortcut = -1) {
    targetid = targetid.tointeger();
    local playerid = character.playerid;

    if (!isPlayerLoaded(targetid)) {
        return msg(playerid, "fraction.invite.notconnected", CL_ERROR);
    }

    if (fraction.members.has(players[targetid].id)) {
        return msg(playerid, "fraction.invite.alreadyinfraction", CL_ERROR);
    }

    // get the lowest role (TODO: change to default role)
    if (role_shortcut == -1) {
        return msg(playerid, "fraction.rolenotexist", [fraction.shortcut], CL_WARNING);
    }

    if (!fraction.roles.has(role_shortcut)) {
        return msg(playerid, "fraction.rolenotexist", [fraction.shortcut], CL_WARNING);
    }

    local role = fraction.roles[role_shortcut];

    if (!(targetid in invites)) {
        invites[targetid] <- [];
    }

    invites[targetid].push({
        invitorName = getPlayerName(playerid),
        invitor  = playerid,
        invetee  = targetid,
        role     = role,
        fraction = fraction,
        created  = getTimestamp(),
    });

    msg(playerid, "fraction.invite.invited", [getPlayerName(targetid), fraction.title, role.title], CL_SUCCESS);
    // msg(playerid, format("If you want to cancel invite, write /f cancel %d", (invites[targetid].len() - 1)), CL_INFO);

    msg(targetid, "fraction.invite.hasinvited", [ getPlayerName(playerid), fraction.title, role.title ], CL_SUCCESS);
    msg(targetid, "fraction.invite.toaccept", [ (invites[targetid].len() - 1) ], CL_INFO);
    msg(targetid, "fraction.invite.showallinvites", CL_INFO);
});

/**
 * List all current invites to fractions for that player
 */
cmd("invites", "list", function (playerid) {
    clearInvitations(playerid);

    if (!(playerid in invites) || invites[playerid].len() < 1) {
        return msg(playerid, "fraction.invite.noinvites", CL_WARNING);
    }

    msg(playerid, "fraction.invitations.title", CL_INFO);

    foreach (idx, invite in invites[playerid]) {
        msg(playerid, "fraction.invitations.item", [ idx, invite.fraction.title, invite.role.title, invite.invitorName ]);
        msg(playerid, "fraction.invitations.toaccept", [ idx ], CL_INFO);
    }
});

/**
 * Accept created invite
 * @param  {Integer} playerid
 * @param  {Integer} invitation
 */
cmd("invites", "accept", function(playerid, invitation = -1) {
    clearInvitations(playerid);
    invitation = invitation.tointeger();

    if (!(playerid in invites) || invites[playerid].len() < 1) {
        return msg(playerid, "fraction.invite.noinvites", CL_WARNING);
    }

    if (!(invitation in invites[playerid])) {
        return msg(playerid, "fraction.accept.donthaveinvitations", CL_WARNING);
    }

    local invite = invites[playerid][invitation];

    //if (!fractions.has(invite.fraction.shortcut)) {
    //    invites[playerid].remove(invitation);
    //    return msg(playerid, "fraction.accept.fractionnotexist", CL_ERROR);
    //}

    if (!invite.fraction.roles.has(invite.role.shortcut)) {
        invites[playerid].remove(invitation);
        return msg(playerid, "fraction.accept.donthaverole", CL_ERROR);
    }

    if (invite.fraction.members.has(players[invite.invetee].id)) {
        return msg(playerid, "fraction.accept.alreadyinfraction", CL_ERROR);
    }

    invite.fraction.members.add(players[invite.invetee].id, invite.role);

    msg(playerid, "fraction.accept.complete", [ invite.fraction.title, invite.role.title ], CL_SUCCESS);

    if (isPlayerLoaded(invite.invitor)) {
        msg(invite.invitor, "fraction.accept.joined", [ getPlayerName(playerid), invite.fraction.title, invite.role.title ], CL_SUCCESS);
    }

    invites[playerid].remove(invitation);
});

// cmd("f", "cancel", function(playerid, invitation) {
//     // todo
// });



fmd(["police"], ["police.ticket"], ["$f ticket"], function(fraction, character, targetId = -1) {
    msg(character.playerid, "Test msg about police ticket "+targetId);
});
