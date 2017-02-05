local carnames = {
    Smith_V8                 = 47,
    Ulver_NewYorker          = 50,
    Walter_Coupe             = 53,
    Jefferson_provincial     = 14,
    Shubert_38               = 25,
    Shubert_Panel            = 31,
    Lassiter_69              = 15,
    Potomac_Indian           = 22,
    Berkley_Kingfisher_pha   = 01,
    Smith_Wagon_pha          = 48,
    Hot_Rod_1                = 06,
    Hot_Rod_2                = 07,
    Smith_Mainline_pha       = 44,
    Shubert_Frigate_pha      = 29,
    Smith_200_pha            = 41,
    Quicksilver_Windsor_pha  = 23,
    Lassiter_75_pha          = 18,
    Ascot_BaileyS200_pha     = 00,
    Houston_Wasp_pha         = 09,
    Shubert_Beverly          = 28,
    Walker_Rocket            = 52,
    Jefferson_Futura_pha     = 13,
    Smith_Stingray_pha       = 45,
    ISW_508                  = 10,
    Jeep_civil               = 12,
    Shubert_Hearse           = 30,
    Smith_Truck              = 46,
    Hot_Rod_3                = 08,
    Smith_coupe              = 43,
    Milk_Truck               = 19,
    Shubert_Truck_CC         = 34,
    Shubert_Truck_CT         = 35,
    Shubert_Truck_CT_cigar   = 36,
    Shubert_Truck_SG         = 38,
    Shubert_Truck_SP         = 39,
    Shubert_Truck_QD         = 37,
    Hank_B                   = 04,
};

function getVehicleModelNameFromId(modelid) {
    foreach (idx, value in carnames) {
        if (value == modelid) {
            return idx;
        }
    }

    return "";
}

function getVehicleModelIdFromName(modelname) {
    return (modelname in carnames) ? carnames[modelname] : -1;
}
