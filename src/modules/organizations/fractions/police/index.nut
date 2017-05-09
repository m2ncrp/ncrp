


local police_rank = {
    "police.cadet"            : [true, false, true],
    "police.patrol"           : [],
    "police.sergeant"         : [],
    "police.lieutenant"       : [],
    "police.сaptain"          : [],
    "police.detective"        : [],
    "police.assistantchief"   : [],
    "police.chief"            : [],
};

function newPoliceGetPermissionByRank(rank) {
    return police_rank[rank];
}
