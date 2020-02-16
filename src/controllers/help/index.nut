function msgt(playerid, text) {
    msg(playerid, "");
    msg(playerid, ".:: %s ::.", text, CL_HELP);
}

function msgo(playerid, text) {
    msg(playerid, text, CL_JORDYBLUE);
}
function msge(playerid, text) {
    msg(playerid, text, CL_SILVERSAND);
}

cmd(["help", "h", "halp", "info"], function(playerid) {
    msgt(playerid, "Помощь");
    msgo(playerid, "/general - основная информация");
    msge(playerid, "/chat - чат");
    msgo(playerid, "/places - места");
    msge(playerid, "/char - персонаж");
    msgo(playerid, "/money - деньги");
    msge(playerid, "/transport - транспорт");
    msgo(playerid, "/job - работа");
    msge(playerid, "/biz - бизнес");
    msgo(playerid, "/donate - донат");
});

cmd("general", function(playerid) {
    msgt(playerid, "Основная информация");
    msgo(playerid, "Открыть карту: латинская M");
    msge(playerid, "Открыть инвентарь: Tab");
    msgo(playerid, "Открыть чат: Enter или латинская T");
    msgo(playerid, "Показать/скрыть курсор: F4");
    msgo(playerid, "Показать/скрыть окно чата: F5");
    msgo(playerid, "Сделать скриншот: F12");
    msge(playerid, "Нашёл баг? Пиши /bug");
    msgo(playerid, "Есть идея? Пиши /idea");
});

cmd("chat", function(playerid) {
    msgt(playerid, "Чаты");
    msgo(playerid, "Команды чата: /chat cmd");
    msge(playerid, "F1 - общий чат (нонрп)");
    msgo(playerid, "F2 - слова персонажа");
    msge(playerid, "F3 - локальный чат (нонрп)");
});

cmd("chat", "cmd", function(playerid) {
    local title = "Команды чата";
    local commands = [
        { name = "/ic текст",     desc = "help.chat.say"},
        { name = "/s текст",      desc = "help.chat.shout"},
        { name = "/w текст",      desc = "help.chat.whisper"},
        { name = "/b текст",      desc = "help.chat.localooc"},
        { name = "/ooc текст",    desc = "help.chat.ooc"},
        { name = "/pm id текст",  desc = "help.chat.privatemsg"},
        { name = "/re текст",        desc = "help.chat.reply"},
        { name = "/me текст",     desc = "help.chat.me"},
        { name = "/do текст",     desc = "help.chat.do"},
        { name = "/todo текст",   desc = "help.chat.todo"},
        { name = "/try текст",    desc = "help.chat.try"}
    ];
    msg_help(playerid, title, commands);
});

cmd("money", function(playerid) {
    msgt(playerid, "Деньги");
    msgo(playerid, "Наличные деньги показываются внизу справа под мини-картой.");
    msge(playerid, "Заработать деньги можно:");
    msgo(playerid, "- на работах: /job");
    msge(playerid, "- занимаясь бизнесом: /biz");
    msgo(playerid, "- другими способами, какие сами придумаете.");
    msge(playerid, "Передать деньги другому человеку: /pay или /send");
    msgo(playerid, "Также можно хранить деньги на счёте в банке: /bank");
});

cmd("places", function(playerid) {
    msgt(playerid, "Места");
    msgo(playerid, "Здание мэрии - красный пятиугольник с белой звездой");
    msgo(playerid, "Полицейский участок - оранжевый пятиугольник");
    msge(playerid, "Дилер - розовый пятиугольник");
    msgo(playerid, "Банк - значок доллара");
    msge(playerid, "Автосалон - бирюзовый пятугольник с автомобилем");
    msgo(playerid, "Штрафстоянка - белый круг с красным крестиком");
});

cmd("transport", function(playerid) {
    msgt(playerid, "Передвижение по городу");
    msgo(playerid, "1. На арендованном автомобиле: /rentcar");
    msge(playerid, "2. На метро: /subway");
    msgo(playerid, "3. На автобусе: /bus");
    msge(playerid, "4. На личном автомобиле: /car");
    msgo(playerid, "Такси на данный момент нет, к сожалению.");
});

cmd("rentcar", function(playerid) {
    msgt(playerid, "Аренда автомобиля");
    msgo(playerid, "Автомобили для аренды доступны в разных частях города.");
    msge(playerid, "Их отличительная черта - жёлтый цвет.");
    msgo(playerid, "Они находятся около мест работ и важных мест города (вокзал, порт, госпиталь).");
    msge(playerid, "Стоимость аренды автомобиля можно узнать, если сесть в него.");
    msgo(playerid, "Оплата производится за каждые 10 минут игрового времени.");
    msge(playerid, "Отказаться от аренды: /unrent");
});

cmd("subway", function(playerid) {
    msgt(playerid, "Метро");
    msgo(playerid, "В Empire-Bay есть кольцевая линия метро из 7 станций, проходящая через весь город.");
    msge(playerid, "Чтобы воспользоваться метро, следует найти ближайшую станцию: /find subway");
    msgo(playerid, "Стоимость проезда $0.15");
});

cmd("bus", function(playerid) {
    msgt(playerid, "Автобус");
    msgo(playerid, "В Empire-Bay есть несколько автобусных маршрутов, охватывающих весь город.");
    msge(playerid, "Отличительной особенностью является то, что автобусы водят реальные игроки по заранее заданному маршруту.");
    msgo(playerid, "Чтобы поехать на автобусе, следует найти ближайшую остановку.");
    msge(playerid, "Когда автобус подъедет и остановится, нажмите латинскую E.");
    msgo(playerid, "Если вы доехали до нужного места, нажмите латинскую E, чтобы выйти.");
    msge(playerid, "Стоимость проезда $0.40");
});

cmd("car", function(playerid) {
    msgt(playerid, "Личный автомобиль");
    msgo(playerid, "В таком городе, как Эмпайр-Бэй, без автомобиля сложно.");
    msge(playerid, "На ваш выбор представлено несколько десятков автомобилей разного класса и стоимости.");
    msgo(playerid, "Не забывайте заправлять топливо на автозаправках.");
    msge(playerid, "Перекрасить личный автомобиль можно в мастерской Чарли.");
    msgo(playerid, "Как обзавестись личным автомобилем: /car buy");
    msge(playerid, "Клавишы управления автомобилем: /car controls");
});

cmd("car", "buy", function(playerid) {
    msgt(playerid, "Купить личный автомобиль");
    msgo(playerid, "Вы можете приобрести автомобиль:");
    msge(playerid, "- в автосалоне Diamond Motors в Маленькой Италии;");
    msgo(playerid, "- у автодилера на северо-западе Кингстона;");
    msge(playerid, "- напрямую у владельца продаваемого автомобиля путём обмена ключей на деньги.");
});

cmd("car", "controls", function(playerid) {
    msgt(playerid, "Клавиши управления автомобилем");
    msgo(playerid, "W, S, A, D - клавиши движения")
    msge(playerid, "Q - завести/заглушить двигатель")
    msgo(playerid, "R - включить/выключить фары")
    msge(playerid, "E - подать звуковой сигнал (гудок)")
    msgo(playerid, "X - левый поворотник");
    msge(playerid, "C - правый поворотник")
    msgo(playerid, "H - аварийная сигнализация (аварийка)")
    msge(playerid, "L - ограничитель скорости")
    msgo(playerid, "< и > - смена радиостанции")
    msge(playerid, "Z, находясь в автомобиле - инвентарь салона")
    msgo(playerid, "E, находясь у багажника - открыть/закрыть багажник")
    msge(playerid, "Q, находясь у багажника - отпереть/запереть багажник")
    msgo(playerid, "Z, находясь у багажника - инвентарь багажника")
});

cmd("char", function(playerid) {
    msgt(playerid, "Персонаж");
    msgo(playerid, "Здоровье: /health");
    msge(playerid, "Питание: /food");
    msgo(playerid, "Одежда: /clothes");
});

cmd("health", function(playerid) {
    msgt(playerid, "Здоровье (хп)");
    msgo(playerid, "Самый важный показатель персонажа.");
    msge(playerid, "Здоровье уменьшается:");
    msgo(playerid, "- при нехватке питания;");
    msge(playerid, "- при травмах и огнестрельных ранениях;");
    msgo(playerid, "- при паденях с высоты;");
    msge(playerid, "- при автомобильных авариях и ДТП;");
    msgo(playerid, "Если здоровье заканчивается, персонаж погибает.");
    msge(playerid, "Здоровье постепенно увеличивается автоматически при заполненности шкал сытости и достатка влаги больше 3/4 части.");

});

cmd("food", function(playerid) {
    msgt(playerid, "Питание и еда");
    msgo(playerid, "Чтобы не умереть, персонажу нужно питаться.");
    msge(playerid, "Шкалы в правом нижнем углу - сытость и достаток влаги.");
    msgo(playerid, "Купить еду и напитки можно в закусочных, барах и ресторанах,");
    msge(playerid, "либо у жителей города в обмен на деньги или другие товары.");
    msgo(playerid, "После покупки, товар попадает в инвентарь.");
    msge(playerid, "Чтобы скушать еду или выпить напиток нужно выбрать предмет в инвентаре и нажать кнопку Использовать.");
    msgo(playerid, "Один предмет можно применить только один раз.");
    msge(playerid, "Каждый продукт питания оказывает разное влияние.");
});

cmd("clothes", function(playerid) {
    msgt(playerid, "Одежда");
    msgo(playerid, "Приобрести одежду вы можете:");
    msge(playerid, "- в магазинах сети Dipton Apparel;");
    msgo(playerid, "- в ателье Венджела в Мидтауне;");
    msge(playerid, "- у жителей города путём обмена одежды на деньги.");
});

cmd("job", function(playerid) {
    msgt(playerid, "Работа");
    msgo(playerid, "В Эмпайр-Бэй найти работу не сложно.");
    msge(playerid, "Места работ отмечены на карте серыми звёздами.");
    msgo(playerid, "Текущая работа указана справа внизу под деньгами.");
    msge(playerid, "Если на карте только одна серая звезда - вы там работаете.");
    msgo(playerid, "/job docker - грузчик в порту");
    msge(playerid, "/job porter - грузчик на вокзале");
    msgo(playerid, "/job bus - водитель автобуса");
    msge(playerid, "/job fish - развозчик рыбы");
    msgo(playerid, "/job truck - развозчик грузов");
    msge(playerid, "/job fuel - развозчик топлива");
    msgo(playerid, "/job milk - развозчик молока");

});

cmd("job", "docker", function(playerid) {
    msgt(playerid, "Грузчик в порту");
    msgo(playerid, "Одна из низкооплачивамых работ.");
    msge(playerid, "Позволяет заработать первые деньги.");
    msgo(playerid, "Не требует навыков.");
});

cmd("job", "porter", function(playerid) {
    msgt(playerid, "Грузчик на вокзале");
    msgo(playerid, "Одна из низкооплачивамых работ.");
    msge(playerid, "Позволяет заработать первые деньги.");
    msgo(playerid, "Не требует навыков.");
});

cmd("job", "bus", function(playerid) {
    msgt(playerid, "Водитель автобуса");
    msgo(playerid, "Государственная хорошо оплачиваемая работа.");
    msge(playerid, "Место трудоустройства: автобусное депо в Аптаун.");
});

cmd("job", "fish", function(playerid) {
    msgt(playerid, "Развозчик рыбы");
    msgo(playerid, "Средне оплачиваемая работа на китайскую диаспору.");
    msge(playerid, "Место трудоустройства: склад Дары моря (Seagift) в Чайнатаун.");
    msgo(playerid, "Можно работать коллективно.");
});

cmd("job", "truck", function(playerid) {
    msgt(playerid, "Развозчик грузов");
    msgo(playerid, "Средне оплачиваемая работа.");
    msge(playerid, "Место трудоустройства: площадка около моста в Диптоне.");
});

cmd("job", "fuel", function(playerid) {
    msgt(playerid, "Развозчик топлива");
    msgo(playerid, "Хорошо оплачиваемая работа.");
    msge(playerid, "Место трудоустройства: штаб-квартира Trago Oil в Ойстер-Бэй.");
    msgo(playerid, "Проверить загруженность бензовоза: /fuel check");
    msge(playerid, "Посмотреть маршрутный лист: /fuel list");

});

cmd("job", "milk", function(playerid) {
    msgt(playerid, "Развозчик молока");
    msgo(playerid, "Хорошо оплачиваемая работа.");
    msge(playerid, "Место трудоустройства: молочный завод в Чайнатаун.");
    msgo(playerid, "job.milkdriver.help.check" );
    msge(playerid, "job.milkdriver.help.list" );
});

cmd("job", "snow", function(playerid) {
    msgt(playerid, "Водитель снегоуборочной машины");
    msgo(playerid, "Государственная средне оплачиваемая работа.");
    msge(playerid, "Место трудоустройства: Аптаун (напротив ПД).");
    msgo(playerid, "Доступна только в зимнее время года." );
});


cmd("biz", function(playerid) {
    msgt(playerid, "Бизнес");
    msgo(playerid, "Вы можете заниматься бизнесом:");
    msge(playerid, "- сдавать свой автомобиль в аренду: /lease");
})

cmd("bank", function(playerid) {
    msgt(playerid, "Grand Imperial Bank");
    msgo(playerid, "bank.letsgo1", CL_SILVERSAND);
    msge(playerid, "bank.letsgo2", CL_SILVERSAND);
});
