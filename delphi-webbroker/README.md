# WebBroker ISAPI (Delphi 10.2)

Этот пример содержит базовый проект WebBroker Application (ISAPI) для работы с турами и заказами.

## Состав

- `WebBrokerApp.dpr` — проект библиотеки ISAPI.
- `WebModuleUnit1.pas/.dfm` — WebModule с тремя маршрутами:
  - `GET /tours` — список туров.
  - `GET /orders` — просмотр заказов.
  - `POST /orders/create` — создание заказа.
- `config.ini.example` — пример строки подключения для MS SQL Server.

## Подготовка базы данных

1. Создайте БД MS SQL Server и примените скрипт `tourism.sql` (лежит в корне репозитория).
2. Создайте `config.ini` рядом с DLL (в той же папке, где будет лежать `WebBrokerApp.dll`).

Пример `config.ini`:

```
[database]
ConnectionString=Server=localhost;Database=Tourism;User_Name=sa;Password=YourStrong!Passw0rd;Encrypt=False;
```

> В строке подключения можно задавать любые параметры FireDAC для MSSQL.

## Сборка ISAPI DLL

1. Откройте `WebBrokerApp.dpr` в Delphi 10.2.
2. Убедитесь, что в проекте подключены библиотеки FireDAC MSSQL (обычно автоматически).
3. Соберите проект (`Build`).
4. На выходе получите `WebBrokerApp.dll`.

## Регистрация в IIS

1. Скопируйте `WebBrokerApp.dll` и `config.ini` в папку, например `C:\inetpub\tourism`.
2. В IIS Manager:
   - Создайте новый сайт или виртуальный каталог, укажите путь `C:\inetpub\tourism`.
   - Превратите его в Application.
   - В **Handler Mappings** убедитесь, что ISAPI Extensions разрешены.
3. В **ISAPI and CGI Restrictions** разрешите `WebBrokerApp.dll`.

## Проверка

Откройте в браузере:

- `http://localhost/tourism/tours`
- `http://localhost/tourism/orders`

Для создания заказа (POST) можно использовать любой HTTP-клиент:

```
POST http://localhost/tourism/orders/create
Content-Type: application/x-www-form-urlencoded

customer_name=Ivan%20Petrov&tour_id=1
```

## Примечания

- В `WebModuleUnit1.pas` логика построена на FireDAC.
- Строка подключения читается из `config.ini` (ключ `database/ConnectionString`).
