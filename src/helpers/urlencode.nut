local R = regexp("[A-Za-z0-9]");

function isalnum(value) {
    return R.match(value.tochar());
}

function url_encode(value) {
    local escaped = "";

    for (local i = 0; i < value.len(); i++) {
        local c = value[i].tointeger();

        // Keep alphanumeric and other accepted characters intact
        if (isalnum(c) || c == '-' || c == '_' || c == '.' || c == '~') {
            escaped += c.tochar();
            continue;
        }

        if (c == ' ') {
            escaped += "+";
            continue;
        }

        // Any other characters are percent-encoded
        escaped += "%" + format("%02X", c);
    }

    return escaped;
}
