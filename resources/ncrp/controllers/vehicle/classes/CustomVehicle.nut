// NOTE: предусмотреть синхронизацию состояния компонент авто для всех игроков.
// Возможно хватит просто вызова корректировки состояний, когда какой-либо игрок в определенном радиусе от авто.

// Вынести автобусы в отдельный класс с собственным контейнеров ввиду их комплексности.
local vehicleFuelTankData = {
    model_0  = 52.0  , // ascot_baileys200_pha
    model_1  = 78.0  , // berkley_kingfisher_pha
    model_2  = 0.0   , // fuel_tank
    model_3  = 180.0 , // gai_353_military_truck
    model_4  = 180.0 , // hank_b
    model_5  = 180.0 , // hank_fueltank
    model_6  = 64.0  , // hot_rod_1
    model_7  = 64.0  , // hot_rod_2
    model_8  = 64.0  , // hot_rod_3
    model_9  = 65.0  , // houston_wasp_pha
    model_10 = 65.0  , // isw_508
    model_11 = 54.0  , // jeep
    model_12 = 54.0  , // jeep_civil
    model_13 = 83.0  , // jefferson_futura_pha
    model_14 = 65.0  , // jefferson_provincial
    model_15 = 84.0  , // lassiter_69
    model_16 = 84.0  , // lassiter_69_destr
    model_17 = 85.0  , // lassiter_75_fmv
    model_18 = 85.0  , // lassiter_75_pha
    model_19 = 75.0  , // milk_truck
    model_20 = 142.0 , // parry_bus
    model_21 = 142.0 , // parry_prison
    model_22 = 50.0  , // potomac_indian
    model_23 = 55.0  , // quicksilver_windsor_pha
    model_24 = 55.0  , // quicksilver_windsor_taxi_pha
    model_25 = 60.0  , // shubert_38
    model_26 = 60.0  , // shubert_38_destr
    model_27 = 0.0   , // shubert_armoured
    model_28 = 75.0  , // shubert_beverly
    model_29 = 65.0  , // shubert_frigate_pha
    model_30 = 60.0  , // shubert_hearse
    model_31 = 60.0  , // shubert_panel
    model_32 = 60.0  , // shubert_panel_m14
    model_33 = 60.0  , // shubert_taxi
    model_34 = 93.0  , // shubert_truck_cc
    model_35 = 93.0  , // shubert_truck_ct
    model_36 = 93.0  , // shubert_truck_ct_cigar
    model_37 = 93.0  , // shubert_truck_qd
    model_38 = 93.0  , // shubert_truck_sg
    model_39 = 93.0  , // shubert_truck_sp
    model_40 = 75.0  , // sicily_military_truck
    model_41 = 75.0  , // smith_200_pha
    model_42 = 75.0  , // smith_200_p_pha
    model_43 = 47.0  , // smith_coupe
    model_44 = 63.0  , // smith_mainline_pha
    model_45 = 65.0  , // smith_stingray_pha
    model_46 = 75.0  , // smith_truck
    model_47 = 60.0  , // smith_v8
    model_48 = 47.0  , // smith_wagon_pha
    model_49 = 0.0   , // trailer
    model_50 = 65.0  , // ulver_newyorker
    model_51 = 65.0  , // ulver_newyorker_p
    model_52 = 75.0  , // walker_rocket
    model_53 = 38.0  , // walter_coupe
};

class CustomVehicle extends SaveableVehicle
{
    static classname = "CustomVehicle";
    /**
     * Get fuel level for vehicle by vehicleid
     * @param  {Integer} vehicleid
     * @return {Float} level
     */
    function getDefaultVehicleFuel(vehicleid) {
        return getDefaultVehicleModelFuel(getVehicleModel(vehicleid));
    }

    /**
     * Get default fuel level by model id
     * @param  {Integer} modelid
     * @return {Float}
     */
    function getDefaultVehicleModelFuel(modelid) {
        return (("model_" + modelid) in vehicleFuelTankData) ? vehicleFuelTankData["model_" + modelid] : VEHICLE_FUEL_DEFAULT;
    }

    // function getDistance() {
    //     return distance;
    // }

    // // Check every minute
    // function calculateDistance(startPoint, endPoint) {
    //     local x = endPoint[0] - startPoint[0];
    //     local y = endPoint[1] - startPoint[1];
    //     local z = endPoint[2] - startPoint[2];
    //     distance += sqrt( x*x + y*y + z*z );
    // }

}
