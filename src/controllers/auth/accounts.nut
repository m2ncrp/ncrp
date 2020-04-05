/**
 * Storage for accounts
 * no direct acess
 */
local accounts = {};
local accountsData = {};

/**
 * Return true if player is authed
 * @param  {Integer}  playerid
 * @return {Boolean}
 */
function isPlayerAuthed(playerid) {
    local username = getAccountName(playerid);

    return (username in accounts && accounts[username] && accounts[username] instanceof Account);
}

/**
 * Set player email
 * @param  {Integer} playerid
 * @param  {String} email
 * @return {String}
 */
function setAccountIsExist(username, status) {
    if(!("exist" in accountsData[username])) accountsData[username].exist <- status;
    accountsData[username].exist = status;
}
/**
 * Return current player locale
 *
 * @param  {Integer} playerid
 * @return {String}
 */
 function getPlayerLocale(playerid) {
    local username = getAccountName(playerid);

    if (isPlayerAuthed(playerid)) {
        return accounts[username].locale;
    }

    if (username in accountsData) {
        return accountsData[username].locale;
    }

    return "ru";
}


/**
 * Set current player locale
 *
 * @param  {Integer} playerid
 * @return {String}
 */
function setPlayerLocale(playerid, locale = "ru") {
    local username = getAccountName(playerid);

    if (isPlayerAuthed(playerid)) {
        accounts[username].locale = locale;
        accounts[username].save();
        return true;
    }

    if (!(username in accountsData)) {
        accountsData[username] <- { locale = locale, account = account }
        return true;
    }

    if (username in accountsData) {
        accountsData[username].locale = locale;
        return true;
    }

    return false;
}

/**
 * Get player ip
 * @param  {Integer} playerid
 * @return {String}
 */
function getPlayerIp(username) {
    return (username in accountsData && "ip" in accountsData[username]) ? accountsData[username].ip : "0.0.0.0";
}

/**
 * Get player email
 * @param  {Integer} playerid
 * @return {String}
 */
function getPlayerEmail(playerid) {
    local username = getAccountName(playerid);
    return (isPlayerAuthed(playerid) ? accounts[username].email : "-");
}

/**
 * Set player email
 * @param  {Integer} playerid
 * @param  {String} email
 * @return {String}
 */
function setPlayerEmail(playerid, email) {
    local username = getAccountName(playerid);

    if (isPlayerAuthed(playerid)) {
        accounts[username].email = email;
        accounts[username].save();
        return true;
    }

    return false;
}

/**
 * Add account to session
 * @param {Integer} playerid
 * @param {Account} account
 */
function addAccount(username, account) {
    return accounts[username] <- account;
}

/**
 * Get account object
 * @param  {String} username
 * @return {Account}
 */
function getAccount(identificator) {
    if(typeof identificator == "string") {
      return identificator in accounts ? accounts[identificator] : null;
    }
    // backward compatibility
    if (typeof identificator == "integer") {
      foreach(username, accountData in accountsData) {
        if(accountData.playerid == identificator) {
            return accounts[username];
        }
      }
      return null;
    }
}

/**
 * Get player account id (if logined, or 0)
 * @param  {Integer} playerid
 * @return {Integer}
 */
function getAccountId(playerid) {
    local username = getAccountName(playerid);
    return (isPlayerAuthed(playerid) ? accounts[username].id : 0);
}

/**
 * Add account to session
 * @param {Integer} playerid
 * @param {Account} account
 */
function addAccountData(username, account) {
    return accountsData[username] <- account;
}

/**
 * Get account data object
 * @param  {String} username
 * @return {Account}
 */
function getAccountData(username) {
  return username in accountsData ? accountsData[username] : null;
}

/**
 * Get players accounts object
 * @return {Account}
 */
function getAccounts() {
    return accounts;
}