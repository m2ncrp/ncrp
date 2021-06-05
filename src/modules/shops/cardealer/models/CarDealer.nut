class CarDealer extends ORM.JsonEntity {

    static classname = "CarDealer";
    static table = "car_dealer";

    static fields = [
        ORM.Field.Integer({ name = "vehid" }),
        ORM.Field.String ({ name = "type" }),
        ORM.Field.Integer({ name = "seller_id" }),
        ORM.Field.Float  ({ name = "price", value = 0.0 }),
        ORM.Field.Integer({ name = "buyer_id" }),
        ORM.Field.Float  ({ name = "commission", value = 0.0 }),
        ORM.Field.Float  ({ name = "total", value = 0.0 }),
        ORM.Field.String ({ name = "status" }),
        ORM.Field.String ({ name = "reason", value = "" }),
        ORM.Field.Integer({ name = "created" }),
        ORM.Field.Integer({ name = "until" }),
    ];
}

/*
Status:
"sale" - автомобиль продаётся
"money_transfer" - автомобиль продан, но деньги не зачислены, тк продавец был в оффлайн
"await_owner" - дилеру не удалось продать авто, дилер ждёт владельца для возврата авто

"completed" - сделка завершена
"canceled" - отмена
"deleted" - автомобиль удалён тк игрок не забрал его после истчения срока продажи

reason:
seller refused - игрок отказался продавать (забрал)
time expired - истекло время продажи


sale -> canceled                   // reason: отмена игроком
sale -> completed                  // reason: продан онлайн игроку
sale -> sold        -> completed   // reason: продан оффлайн игроку
sale -> await_owner -> canceled    // reason: забрал владелец / отправлен на шс


три типа сделки:
покупка/purchase - дилер покупает
продажа/sale - дилер продаёт (либо отправляет на шс в убыток)
трансфер/transfer - дилер сводит покупателя с продавцом



*/
