local __translations = {};

/**
 * Register transaltion table
 * Can me used for multiple languages
 * Can be used multiple times for signle language
 *
 * @param  {String} language - 2 letter code representing language ["en", "ru"]
 * @param  {Table}  data - table containint pairs of key : value,
 *          where key is string value that should be replaced,
 *          and value is result of replacing
 *
 * @return {Boolean} true
 */
function translation(language, data) {
    if (!(language in __translations)) {
        __translations[language] <- {};
    }

    // maybe its a function, then call it !
    if (typeof data == "function") {
        data = data();
    }

    // save new translation data
    foreach (idx, value in data) {
        __translations[language][idx] <- value;
    }

    return true;
}

/**
 * Try to localize passed value
 * First of all, check if provided language exists
 * And then check if value is registered via `translation` functions
 * If value is found, `format` function will be applied, taking `params` as argument
 *
 * @param  {String} value
 * @param  {Array}  params - array of parameters that will be passed to `format` function
 * @param  {String} langauge - language to try translate to
 * @return {String} translated (or not) value
 */
function localize(value, params = [], langauge = "en") {
    if (langauge in __translations && value in __translations[langauge]) {
        // insert params
        params.insert(0, getroottable());
        params.insert(1, __translations[langauge][value]);

        // format and return
        try {
            return format.acall(params);
        } catch (e) {
            ::print("[error][translation] cannot format output value by tag: " + value + "\n");
            return value;
        }
    }

    // return `value` if replaces are not found
    return value;
}

/**
 * Testing
 */
// translation("en", {
//     "bus.entry" : "Enter the bus",
//     "only.eng"  : "Only english"
// });

// translation("en", {
//     "say.hello" : "Say hello to my little fried %s!",
//     "say.elllo2"  : "U %d's motherfucker for today, jezuz %s, shut the fuck up!"
// });

// translation("ru", {
//     "bus.entry" : "Войти в автобус"
// });

// print( localize("test") + "\n" );
// print( localize("bus.entry")+ "\n" );
// print( localize("only.eng")+ "\n" );
// print( localize("bus.entry", [], "ru")+ "\n" );

// print( localize("say.hello", ["Inlife"])+ "\n" );
// print( localize("say.elllo2", [4, "BITCH"])+ "\n" );
