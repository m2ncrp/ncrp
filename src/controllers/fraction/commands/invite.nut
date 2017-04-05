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

/**
 * Invite player to join fraction
 * @param  {Integer} playerid
 * @param  {Integer} targetid
 * @param  {Mixed} rolenum
 */
cmd("f", "invite", function(playerid, targetid = -1, rolenum = -1) {
    local fracs = fractions.getManaged(playerid, FRACTION_INVITE_PERMISSION);
    rolenum = rolenum.tointeger();

    if (!fracs.len()) {
        return msg(playerid, "fraction.invite.cannotinvite", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];
    targetid = targetid.tointeger();

    if (!isPlayerLoaded(targetid)) {
        return msg(playerid, "fraction.invite.notconnected", CL_ERROR);
    }

    if (fractions.getContaining(targetid).len() > 0) {
        return msg(playerid, "fraction.invite.inanotherfraction", CL_ERROR);
    }

    // get the lowest role (TODO: change to default role)
    if (rolenum == -1) {
        rolenum = fraction.roles.len() - 1;
    }

    if (!fraction.roles.has(rolenum)) {
        return msg(playerid, "fraction.rolenotexist", CL_WARNING);
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

    msg(playerid, "fraction.invite.invited", [getPlayerName(targetid), fraction.title, role.title], CL_SUCCESS);
    // msg(playerid, format("If you want to cancel invite, write /f cancel %d", (invites[targetid].len() - 1)), CL_INFO);

    msg(targetid, "fraction.invite.hasinvited", [ getPlayerName(playerid), fraction.title, role.title ], CL_SUCCESS);
    msg(targetid, "fraction.invite.toaccept", [ (invites[targetid].len() - 1) ], CL_INFO);
    msg(targetid, "fraction.invite.showallinvites", CL_INFO);
});

/**
 * List all current invites to fractions for that player
 */
cmd("f", "invites", function (playerid) {
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
cmd("f", "accept", function(playerid, invitation = -1) {
    clearInvitations(playerid);
    invitation = invitation.tointeger();

    if (!(playerid in invites) || invites[playerid].len() < 1) {
        return msg(playerid, "fraction.invite.noinvites", CL_WARNING);
    }

    if (!(invitation in invites[playerid])) {
        return msg(playerid, "fraction.accept.donthaveinvitations", CL_WARNING);
    }

    local invite = invites[playerid][invitation];

    if (!fractions.has(invite.fraction.id)) {
        invites[playerid].remove(invitation);
        return msg(playerid, "fraction.accept.fractionnotexist", CL_ERROR);
    }

    if (!invite.fraction.hasRole(invite.role)) {
        invites[playerid].remove(invitation);
        return msg(playerid, "fraction.accept.donthaverole", CL_ERROR);
    }

    if (fractions.getContaining(playerid).len() > 0) {
        return msg(playerid, "fraction.accept.cannotjoin", CL_ERROR);
    }

    invite.fraction.add(playerid, invite.role);

    msg(playerid, "fraction.accept.complete", [ invite.fraction.title, invite.role.title ], CL_SUCCESS);

    if (isPlayerLoaded(invite.invitor)) {
        msg(invite.invitor, "fraction.accept.joined", [ getPlayerName(playerid), invite.fraction.title, invite.role.title ], CL_SUCCESS);
    }

    invites[playerid].remove(invitation);
});

// cmd("f", "cancel", function(playerid, invitation) {
//     // todo
// });
