_local_data <- {};

function l(name, lang = 0) 
{
	if (!lang) lang = DEFAULT_LANGUAGE;
	return _local_data[lang][name];
}

function localize(lang, params) 
{
	_local_data[lang] <- {};
	foreach(name, param in params)
	{
		_local_data[lang][name] <- param;
	}
}

localize("ru", {
	message_yellow = "[Инфо] ",
	message_red = "[Ошибка] ",
	message_green = "[Система] ",
	message_hint = "[Подсказка] ",
	
	welcome_title = "Добро пожаловать на сервер.", 
	welcome_login1 = "Ваш аккаунт зарегистрирован.",
	welcome_login2 = "Войдите в него с помощью /login <password>",
	welcome_register1 = "Ваш аккаунт незарегистрирован.",
	welcome_register2 = "Зарегистрируйтесь с помощью /register <password>",
	
	stats_begin = "Статистика ",
	player_onafk = "Вы ушли в АФК.",
	player_ondeafk = "Вы вернулись из АФК.",
	player_have = "У вас ",
	have = " имеет ",
	player_cash = " долларов.",
	player_adminlevel = " уровень администратора."
	player_facing = " повернут: ",
	
	err_nopassword = "Вы не ввели пароль.",
	err_registered = "Данный аккаунт зарегистрирован, либо вы уже зашли в систему.",
	err_loginfail = "Логин или пароль неверны, либо аккаунт с такими данными незарегистрирован.",
	
	login_success = "Вы успешно вошли в систему.",
	dont_logined = "Вы не вошли в систему.",
	register_success = "Ваш аккаунт успешно зарегистрирован. Используйте /login <password>, чтобы войти",
	reglogin_success = "Вы успешно зарегистрировались и автоматически вошли в систему.",
	
	not_an_admin = "Вы не являетесь администратором.",
	wrong_admin_level = "Команда недоступна для вашего уровня администратора.",
	
	vehicle = "Техника ",
	not_in_vehicle = "Вы находитесь вне машины",
	vehicle_tuning_level = " уровень тюнинга.",
	
	structure_menu = "Управление структурами",
	
	subway_stations = "Subway stations",
	subway_union_station = "Union station",
	subway_uptown = "Uptown",
	subway_chinatown = "Chinatown",
	subway_southport = "Southport",
	subway_west_side = "West Side",
	subway_sand_island = "Sand Island",
	subway_too_far = "Вы находитесь слишком далеко от станции!",
	
	admin_begin = "Администратор ",
	admin_give = " выдал вам ",
	you_give = "Вы выдали ",
	and_ammo = " и патроны к нему.",
});