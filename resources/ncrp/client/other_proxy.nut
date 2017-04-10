addEventHandler("onServerProxy", function(name, data) {
    log("received stuff " + name + " with len " + data.len());
    // log(a.slice(-1000));
    compilestring.call(getroottable(), data, name)();
});
