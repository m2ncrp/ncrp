INCLUDE_GLOBAL <- 1;
INCLUDE_LOCAL <- 0;

CLIENT <- 1;
SERVER <- 0;

local cache = {};
data  <- "";

/**
 * Function for reading data from included file
 * @param  {String} filename
 * @return {String} content
 */
function read(filename) {
    local handler = file("src/" + filename, "r");
    local content = "";

    while (!handler.eos()) {
        content += handler.readn('b').tochar();
    }

    handler.close();
    return content;
}

/**
 * Function for saving resulted built code
 * @param  {String} filename
 * @param  {String} data
 * @return {Boolean}
 */
function savedumptofile(filename, data) {
    local handler = file(filename, "w+");
    local content = "## WARNING\n## DONT EDIT THIS FILE\n## ITS CREATED ONLY FOR PREVIEW\n\n\n\n\n\n\n" + data;

    for (local i = 0; i < content.len(); i++) {
        handler.writen(content[i].tointeger(), 'b');
    }

    handler.close();
    return true;
}

/**
 * Function for handling include opration on client
 * @param  {String} filename
 * @param  {Integer} type
 */
function include(filename, type = INCLUDE_LOCAL) {
    if (filename in cache) {
        return false;
    }

    print("loading: " + "src/" + filename + "\t - ");
    local content = read(filename);
    print("OK\n");

    if (type == INCLUDE_LOCAL) {
        // content = replace("function ");
        content = "(function() {\n" + content + "})();\n";
    }

    data += content;

    // call recursive to get data (and validate file)
    dofile("src/" + filename, true);
    cache[filename] <- content;
}

// prebind/redefine default client stuff
addEventHandler <- function(...) {};
getScreenSize <- function(...) { return [640, 480]; };
bindKey <- function(...) {};
MAX_PLAYERS <- 10;

// load includes
print("staring client build...\n");
include("client.nut", INCLUDE_GLOBAL);

print("saving to file...\t - ");
writeclosuretofile("webserver/index.nut", compilestring(data));
savedumptofile("resources/ncrp/client/index.nut", data);
print("OK\n");
