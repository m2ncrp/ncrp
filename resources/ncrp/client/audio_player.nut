local rTimer;
local audio_library = {
    track = Audio(true, true, "http://at5am.ru/ncrp/audio/sound21s.mp3"), //"https://wav-library.net/effect/pack-13/Povorotnik_tikaet.mp3"
    objectid = null
};

addEventHandler("indicator_check", function(vehicleid, indicator_state) {
    if (audio_library.objectid == null) {
        // audio_library.track = Audio(true, true, "http://at5am.ru/ncrp/audio/sound21s.mp3");
        audio_library.objectid = vehicleid;
        rTimer = timer( indicator_check, audio_library.track.getLength(), -1, audio_library.track);
    }

    if (indicator_state != 0) {
        update_indicators(0.0);
        audio_library.track.play();
    } else {
        update_indicators(70.0);
        audio_library.track.pause();
        // audio_library.objectid = null;
    }
});

function update_indicators(distance) {
    local max_volume = 65.0;
    local min_volume = 0.0;
    local max_distance = 2.5;

    if (distance > max_distance) {
        return audio_library.track.setVolume(0.0);
    }

    local actual_volume = max_volume - distance * (max_volume / max_distance);
    actual_volume = ceil(actual_volume);

    audio_library.track.setVolume(actual_volume);
    // log( "Audio playing at volume " + actual_volume );
}

function getDistance(vehicleid) {
    local plaPos = getPlayerPosition( getLocalPlayer() );
    local vehPos = getVehiclePosition( vehicleid.tointeger() );
    return getDistanceBetweenPoints3D( plaPos[0], plaPos[1], plaPos[2], vehPos[0], vehPos[1], vehPos[2] );
}


addEventHandler( "onClientFrameRender", function( post ) {
    if (audio_library.objectid != null) {
        update_indicators( getDistance( audio_library.objectid ) );
    }
    return 1;
});



// local audio;
// local rTimer;
//  addEventHandler("playAudio", function(url, onlineStream = true, replay = false) {
//     audio = Audio(true, false, url);
//     playAudio(audio);
//     rTimer = timer( playAudio, 20918, -1, audio);
//  });

//  function playAudio(audio) {
//     audio.play();
//     sendMessage("Send"+audio);
//  }

//  function testText(text) {
//     sendMessage("Send"+text);
//  }


//  addEventHandler("stopAudio", function() {
//     audio.stop();
//  });
