# Flutter app for storing photos of your clothes and creating collages from them

Целью проекта является разработка мобильного приложения для формирования виртуального гардероба, призванного сократить физические и временные затраты на подбор одежды путем хранения фотографий вещей с краткой информацией о них в удобном месте и формате.
Практическая значимость: разработка мобильного приложения позволит пользователям вести учет элементов своего гардероба, составлять сочетания и делиться ими с другими пользователями.

В рамках проекта было разработано мобильное приложение, позволяющее пользователю добавлять, изменять и просматривать элементы гардероба, составлять из них сочетания, которые так же можно редактировать, просматривать и удалять. Кроме того, сохраненные сочетания можно публиковать для получения оценки других пользователей.

Мобильное приложение имеет простой, интуитивно понятный пользователю интерфейс и выполняет следующие функции:
- просмотр и редактирование профиля пользователя;
- добавление, просмотр, редактирование, удаление элемента;
- предоставление списка элементов по категории;
- поиск элемента по описанию;
- добавление, просмотр, редактирование, удаление, публикация сочетания;
- предоставление списка сочетаний по категории;
- предоставление списка сочетаний, включающих в себя выбранный элемент;
- поиск пользователя по имени;
- добавление пользователя в список друзей;
- удаление пользователя из списка друзей;
- отправка письма на почту с запросом на оценку сочетания;
- просмотр профиля друга;
- оценка опубликованного другом сочетания.


# Диаграмма вариантов использования
![image](https://user-images.githubusercontent.com/111181469/184532860-7b2b2809-15dd-47f7-b2a8-a529980cf153.png)

# Демонстрация проекта
https://user-images.githubusercontent.com/111181469/184540993-7338796a-84d4-4d1a-8bd9-4557bcf2a121.mp4

[Серверная часть](https://github.com/spvik02/your_perfect_look_b) для обработки запросов и доступа к сущностям в базе данных. 

![image](https://user-images.githubusercontent.com/111181469/184541896-c90bb747-c966-477e-b3a1-f0960a83bfe9.png)

Обмен данными между мобильным приложением и серверным будет происходить с помощью формата JSON. При обращении к  по заданному маршруту и определенному HTTP методу сервер будет определять с какой сущностью базы данных необхо-димо взаимодействовать и какие действия над данными необходимо произвести.
