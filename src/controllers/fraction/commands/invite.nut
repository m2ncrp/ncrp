local INVITATION_TIMEOUT = 10 * 60; // 10 minutes
local invites = {};

/**
 * Clear all outdated invitations
 * @param  {Integer} playerid
 */
local function clearInvitations(playerid) {
    if (!(playerid in invites)) return;

    local cinvites = clone(invites);

    foreach (idx, value in cinvites) {
        if (value.crated + INVITATION_TIMEOUT < getTimestamp()) {
            invites.remove(idx);
        }
    }
}

/**
 * Invite player to join fraction
 * @param  {Integer} playerid
 * @param  {Integer} targetid
 * @param  {Mixed} rolenum
 */
cmd("f", "invite", function(playerid, targetid = -1, rolenum = -1) {
    local fracs = fractions.getManaged(playerid);

    if (!fracs.len()) {
        return msg(playerid, "You dont have permission to invite players to this fraction", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];
    targetid = targetid.tointeger();

    if (!isPlayerLoaded(targetid)) {
        return msg(playerid, "You cannot invite player which is not connected!", CL_ERROR);
    }

    if (fractions.getContaining(targetid).len() > 0) {
        return msg(playerid, "You cannot invite player into fraction while he is in another fraction!", CL_ERROR);
    }

    if (!fraction.roles.has(rolenum)) {
        return msg(playerid, "There is no such role. You can see fraction roles via: /f roles", CL_WARNING);
    }

    local role = fraction.roles[rolenum];

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

    msg(playerid, format("You've invited %s, to join your fraction %s with role %s", getPlayerName(targetid), fraction.title, role.title), CL_SUCCESS);
    msg(playerid, format("If you want to cancel invite, write /f cancel %d", (invites[targetid].len() - 1)), CL_INFO);

    msg(targetid, format("%s has invited you to join fraction %s with role %s", getPlayerName(playerid), fraction.title, role.title), CL_SUCCESS);
    msg(targetid, format("If you want to join, write /f accept %d", (invites[targetid].len() - 1)), CL_INFO);
    msg(targetid, "If you want to see all your invites, write /f invites", CL_INFO);
});

/**
 * List all current invites to fractions for that player
 */
cmd("f", "invites", function (playerid) {
    clearInvitations(playerid);

    if (!(playerid in invites) || invites[playerid].len() < 1) {
        return msg(playerid, "You dont have any fraction invites at the moment", CL_WARNING);
    }

    msg(playerid, "Here is list of your current fraction invitations:", CL_INFO);

    foreach (idx, invite in invites) {
        msg(playerid, format("#%d Fraction: %s, Role: %s, By: %s. To accept: /f accept %d", idx, invite.fraction.title, invite.role.title, invite.invitorName, idx));
    }
});


cmd("f", "accept", function(playerid, invitation = -1) {
    clearInvitations(playerid);
    invitation = invitation.tointeger();

    if (!(playerid in invites) || invites[playerid].len() < 1) {
        return msg(playerid, "You dont have any fraction invites at the moment", CL_WARNING);
    }

    if (!(invitation in invites)) {
        return msg(playerid, "You dont have invitation with provided id. To see full list, write: /f invites", CL_WARNING);
    }

    local invite = invites[invitation];

    if (!fractions.has(invite.fraction.id)) {
        invites.remove(invitation);
        return msg(playerid, "You cannot accept invitation to fraction which doesnt exists.", CL_ERROR);
    }

    if (!invite.fraction.roles.has(invite.role.id)) {
        invites.remove(invitation);
        return msg(playerid, "You cannot accept invitation to fraction with role which doesnt exists.", CL_ERROR);
    }

    if (fractions.getContaining(playerid).len() > 0) {
        return msg(playerid, "You cannot join this fraction while you are a member of other fraction. To leave current fraction write: /f leave", CL_ERROR);
    }

    invite.fraction.add(playerid, invite.role);

    msg(playerid, format("You've successfuly joined fraction %s as %s", invite.fraction.title, invite.role.title), CL_SUCCESS);

    if (isPlayerLoaded(invite.invitor)) {
        msg(invite.invitor, format("%s successfuly joined fraction %s as %s", getPlayerName(playerid), invite.fraction.title, invite.role.title), CL_SUCCESS);
    }
});
