# База Данных
### Аккаунты (tbl_accounts)
id
_entity
login
password
email
ip
serial (или аналог, позволяющий идентифицировать устройство)
locale
layout
created
logined
accesslevel
warns
blocks

### Персонажи (tbl_characters)
id
_entity
accountid
nickname
x
y
z
xp
money (только наличка, депозит будет отдельно как счёт в банке, банков может быть несколько разных, следовательно и счета разные).
state (последнее состояние игрока, которое может ограничить его в действиях: например, в наручниках, парализован шокером, или паралич после инсульта)
eyes
skin (цвет кожи)( + надо узнать, что есть из вариантов одежды в гта5, вероятно тут нужно будет хранить json c перечнем ПРИМЕНЁННЫХ на персонажа элементов одежды и аксессуаров, или же выносить в отдельную таблицу где указывать предмет и на ком применён)
health
hunger
thirst



### Для паспорта
фото
firstname
lastname
национальность (американец, мексиканец, француз и тд)
место рождения
sex
birthday
birthmonth
birthyear

# Описание
(черновик)

1. Игроки
2. Автомобили
3. Фракции
4. Бизнесы (наследуют фракции)



## Игроки

Массив игроков:
Player players[]

Игрок:
Player {
    string firstname;
    string lastname;

    string money;
    string birthyear;
}


### Извлечение

players[N]
players[15]
players.get(15)

