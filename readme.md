# ncrp

Night City Role-Play official documentation.

## snippets

Iterate over all current players:

```js
playerList.each(function(playerid) {
    sendPlayerMessage(playerid, "Hello world!");
});
```

Create a command:

```js
cmd(["longname", "shrtnm"], function(playerid) {
    sendPlayerMessage(playerid, "Hello from command!");
});
```


## functions

```java
/**
 * Get current weather name
 */
string getWeatherName();

/**
 * Set current weather id
 * Possible values [0, 1, 2]
 * 0 = normal
 * 1 = foggy
 * 2 = rainy
 */
bool setCurrentWeather(int id);
```

## events

### Server events
* `onAutosave` - on Each autosave

### Client events

* `onServerWeatherSync`
* `onServerTimeSync`

## changes

* players -> playerList [chaging plain players array to playerList object]