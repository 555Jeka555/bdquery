# 3.1 INSERT
# Без указания списка полей
USE pharmaceuticals;

INSERT INTO address
VALUES (UNHEX(REPLACE('a54882b9-d798-11ee-bff2-088fc307f6ac', '-', '')),
        'Russia',
        'Mari El',
        'Yoshkar-Ola',
        'Krasnoarmeyskaya',
        '2',
        NOW(),
        NULL,
        NULL);

# С указанием списка полей
INSERT INTO pharmacy(pharmacy_id, title, address_id, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Paracetamol',
        UNHEX(REPLACE('a54882b9-d798-11ee-bff2-088fc307f6ac', '-', '')),
        '+79008007060',
        NOW());

# С чтением значения из другой таблицы (вставка с копированием)
INSERT INTO backup_pharmacy(backup_pharmacy_id, title, address_id, phone, created_at, updated_at, deleted_at)
SELECT pharmacy_id,
       title,
       address_id,
       phone,
       created_at,
       updated_at,
       deleted_at
FROM pharmacy;


# 3.2 DELETE
# Всех записей
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor1',
        '+1234567891',
        NOW()),
       (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor2',
        '+9876543210',
        NOW());
DELETE FROM vendor;

# По условию
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor1',
        '+1234567892',
        NOW()),
       (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor2',
        '+9876543213',
        NOW());
DELETE FROM vendor AS v WHERE v.phone = '+9876543213';


# 3.3 UPDATE
# Всех записей
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor2',
        '+1234567894',
        NOW()),
       (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor3',
        '+9876543215',
        NOW());
UPDATE vendor
SET
    name = 'Vendor0';

# По условию обновляя один атрибут
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor4',
        '+1234567896',
        NOW()),
       (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor5',
        '+9876543217',
        NOW());
UPDATE vendor
SET
    phone = '+1112223344'
WHERE
    name = 'Vendor4';

# По условию обновляя несколько атрибутов
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor8',
        '+1234567855',
        NOW());
UPDATE vendor
SET
    name = 'Vendor6',
    phone = '+11122233434'
WHERE
    name = 'Vendor8';


# 3.4 SELECT
# С набором извлекаемых атрибутов
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor9',
        '+1234567812',
        NOW());
SELECT name, created_at FROM vendor;

# Со всеми атрибутами
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor10',
        '+1234567111',
        NOW());
SELECT * FROM vendor;

# С условием по атрибуту
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor11',
        '+1234567333',
        NOW());
SELECT * FROM vendor WHERE name = 'Vendor11';


# 3.5 SELECT ORDER BY + TOP (LIMIT)
# С сортировкой по возрастанию ASC + ограничение вывода количества записей
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor12',
        '+2344567333',
        NOW());
SELECT * FROM vendor ORDER BY created_at ASC LIMIT 5;

# С сортировкой по убыванию DESC
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor13',
        '+2344223333',
        NOW());
SELECT * FROM vendor ORDER BY created_at DESC;

# С сортировкой по двум атрибутам + ограничение вывода количества записей
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor14',
        '+2343243433',
        NOW());
SELECT * FROM vendor ORDER BY created_at DESC, name ASC LIMIT 2,5;

# С сортировкой по первому атрибуту, из списка извлекаемых
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor15',
        '+233333433',
        NOW());
SELECT created_at, vendor_id FROM vendor ORDER BY 1;

# 3.6. Работа с датами
# WHERE по дате
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor16',
        '+233233433',
        CAST('2024-02-29 12:30:45' AS DATETIME));
SELECT * FROM vendor WHERE created_at = '2024-02-29 12:30:45';

# WHERE дата в диапазоне
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor17',
        '+232223433',
        CAST('2024-03-08 12:30:45' AS DATETIME)),
        (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor18',
        '+2000433',
        CAST('2024-04-29 12:30:45' AS DATETIME));
SELECT * FROM vendor WHERE created_at BETWEEN '2024-03-07 00:00:00' AND '2024-04-29 23:59:59';

# Извлечь из таблицы не всю дату, а только год
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor19',
        '+223123433',
        CAST('2024-02-29 12:30:45' AS DATETIME));
SELECT YEAR(created_at) AS year_created_at FROM vendor;


# 3.7 Функции агрегации
# Посчитать количество записей в таблице
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor20',
        '+200123433',
        NOW());
SELECT COUNT(*) AS amount_records FROM vendor;

# Посчитать количество уникальных записей в таблице
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor21',
        '+202323433',
        NOW());
SELECT COUNT(DISTINCT name, created_at) AS amount_unique_records FROM vendor;

# Вывести уникальные значения столбца
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor22',
        '+989323433',
        NOW());
SELECT DISTINCT name AS unuque_values FROM vendor;

# Найти максимальное значение столбца
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor23',
        '+999999999',
        NOW());
SELECT MAX(phone) AS max_phone FROM vendor;

# Найти минимальное значение столбца
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        'Vendor24',
        '+00000000',
        NOW());
SELECT MIN(phone) AS min_phone FROM vendor;

# Написать запрос COUNT() + GROUP BY
INSERT INTO address (address_id, country, city, street, building, created_at)
VALUES (UNHEX(REPLACE('1111-1111-1111-1111', '-', '')),
        'country',
        'city',
        'street',
        'building',
        Now());
INSERT INTO pharmacy (pharmacy_id, title, address_id, phone, created_at)
VALUES (UNHEX(REPLACE('1111-2222-4444-5555', '-', '')),
        'Apteka',
        UNHEX(REPLACE('1111-1111-1111-1111', '-', '')),
        '+12312321',
        NOW());
INSERT INTO employee (employee_id, pharmacy_id, first_name, second_name, phone, created_at)
VALUES (UNHEX(REPLACE('1111-3333-4444-5555', '-', '')),
        UNHEX(REPLACE('1111-2222-4444-5555', '-', '')),
        'First',
        'Second',
        '+12312444',
        NOW()),
        (UNHEX(REPLACE('1111-3333-0000-5555', '-', '')),
        UNHEX(REPLACE('1111-2222-4444-5555', '-', '')),
        'First2',
        'Second2',
        '+123212444',
        NOW());
INSERT INTO sale (sale_id, pharmacy_id, employee_id, discount, date_of_sale, created_at)
VALUES (UNHEX(REPLACE(UUID(), '-', '')),
        UNHEX(REPLACE('1111-2222-4444-5555', '-', '')),
        UNHEX(REPLACE('1111-3333-4444-5555', '-', '')),
        222,
        CAST('2025-02-28 12:21:12' AS DATETIME),
        NOW()),
        (UNHEX(REPLACE(UUID(), '-', '')),
        UNHEX(REPLACE('1111-2222-4444-5555', '-', '')),
        UNHEX(REPLACE('1111-3333-0000-5555', '-', '')),
        111,
        CAST('2025-02-28 12:21:12' AS DATETIME),
        NOW());
SELECT employee_id, COUNT(discount) AS employee_discount FROM sale GROUP BY employee_id;


# 3.8 SELECT GROUP BY + HAVING
INSERT INTO address (address_id, country, city, street, building, created_at)
VALUES (UNHEX(REPLACE('1111-1111-2222-3333', '-', '')),
        'country',
        'city',
        'street',
        'building',
        Now());
INSERT INTO pharmacy (pharmacy_id, title, address_id, phone, created_at)
VALUES (UNHEX(REPLACE('1111-2222-4444-9999', '-', '')),
        'Apteka',
        UNHEX(REPLACE('1111-1111-2222-3333', '-', '')),
        '+123123201',
        NOW());
INSERT INTO employee (employee_id, pharmacy_id, first_name, second_name, phone, created_at)
VALUES (UNHEX(REPLACE('2222-3333-4444-5555', '-', '')),
        UNHEX(REPLACE('1111-2222-4444-9999', '-', '')),
        'First',
        'Second',
        '+1232444',
        NOW()),
        (UNHEX(REPLACE('3333-3333-0000-5555', '-', '')),
        UNHEX(REPLACE('1111-2222-4444-9999', '-', '')),
        'First2',
        'Second2',
        '+1235444',
        NOW()),
        (UNHEX(REPLACE('3333-3333-2222-5555', '-', '')),
        UNHEX(REPLACE('1111-2222-4444-9999', '-', '')),
        'First3',
        'Second3',
        '+12364',
        NOW());
INSERT INTO sale (sale_id, pharmacy_id, employee_id, discount, date_of_sale, created_at)
VALUES (UNHEX(REPLACE('9090-1010-8080-7070', '-', '')),
        UNHEX(REPLACE('1111-2222-4444-9999', '-', '')),
        UNHEX(REPLACE('2222-3333-4444-5555', '-', '')),
        1000,
        CAST('2025-02-28 12:21:12' AS DATETIME),
        NOW()),
        (UNHEX(REPLACE('3030-5050-4040-2020', '-', '')),
        UNHEX(REPLACE('1111-2222-4444-9999', '-', '')),
        UNHEX(REPLACE('2222-3333-4444-5555', '-', '')),
        111,
        CAST('2025-02-28 12:21:12' AS DATETIME),
        NOW()),
        (UNHEX(REPLACE('3131-5151-4141-2121', '-', '')),
        UNHEX(REPLACE('1111-2222-4444-9999', '-', '')),
        UNHEX(REPLACE('3333-3333-0000-5555', '-', '')),
        555,
        CAST('2025-02-28 12:21:12' AS DATETIME),
        NOW()),
        (UNHEX(REPLACE('3232-5252-4242-2323', '-', '')),
        UNHEX(REPLACE('1111-2222-4444-9999', '-', '')),
        UNHEX(REPLACE('3333-3333-2222-5555', '-', '')),
        1000,
        CAST('2025-02-28 12:21:12' AS DATETIME),
        NOW());
INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE('9999-3333-4444-5555', '-', '')),
        'Vendor20',
        '+2233343433',
        NOW());
INSERT INTO medicine (medicine_id, vendor_id, title, manual, cost_of_one, is_by_prescription, amount, created_at)
VALUES (UNHEX(REPLACE('9549-3543-4434-5235', '-', '')),
        UNHEX(REPLACE('9999-3333-4444-5555', '-', '')),
        'Paracetamol',
        'Drink drink drink',
        3000,
        false,
        10,
        NOW()),
        (UNHEX(REPLACE('0000-3543-4434-5235', '-', '')),
        UNHEX(REPLACE('9999-3333-4444-5555', '-', '')),
        'Analgin',
        'Drink drink drink',
        170,
        false,
        20,
        NOW());
INSERT INTO sale_has_medicine (sale_id, medicine_id, amount, created_at)
VALUES (UNHEX(REPLACE('9090-1010-8080-7070', '-', '')),
        UNHEX(REPLACE('9549-3543-4434-5235', '-', '')),
        6,
        NOW()
       ),
        (UNHEX(REPLACE('9090-1010-8080-7070', '-', '')),
        UNHEX(REPLACE('0000-3543-4434-5235', '-', '')),
        5,
        NOW()),
        (UNHEX(REPLACE('3030-5050-4040-2020', '-', '')),
        UNHEX(REPLACE('9549-3543-4434-5235', '-', '')),
        4,
        NOW()
       ),
        (UNHEX(REPLACE('3131-5151-4141-2121', '-', '')),
        UNHEX(REPLACE('0000-3543-4434-5235', '-', '')),
        9,
        NOW());

# Найти всех таких продавоцов, чьи продажи имели сумму скидок больше 1000
SELECT
    employee_id,
    SUM(discount) AS total_discount
FROM sale
GROUP BY employee_id
HAVING total_discount > 1000;

# Найти все такие товары, которые по количеству были проданы больше 200
SELECT
    medicine_id,
    SUM(amount) AS total_amount
FROM sale_has_medicine
GROUP BY medicine_id
HAVING total_amount > 200;

# Найти все такие продажи, в которых было продано 2 и больше товара
SELECT
    sale_id,
    COUNT(medicine_id) AS count_medecine
FROM sale_has_medicine
GROUP BY sale_id
HAVING count_medecine >= 2;


# 3.9 SELECT JOIN
# LEFT JOIN двух таблиц и WHERE по одному из атрибутов
INSERT INTO address (address_id, country, city, street, building, created_at)
VALUES (UNHEX(REPLACE('1111-9090-2222-3333', '-', '')),
        'country',
        'city',
        'street',
        'building',
        Now()),
        (UNHEX(REPLACE('1111-7070-2222-3333', '-', '')),
        'country2',
        'city',
        'street',
        'building',
        Now());
INSERT INTO pharmacy (pharmacy_id, title, address_id, phone, created_at)
VALUES (UNHEX(REPLACE('1111-2222-4444-8080', '-', '')),
        'AptekaRU',
        UNHEX(REPLACE('1111-9090-2222-3333', '-', '')),
        '+1231290201',
        NOW()),
        (UNHEX(REPLACE('2222-2222-4444-8080', '-', '')),
        'AptekaEN',
        UNHEX(REPLACE('1111-7070-2222-3333', '-', '')),
        '+12999210201',
        NOW());
INSERT INTO employee (employee_id, pharmacy_id, first_name, second_name, phone, created_at)
VALUES (UNHEX(REPLACE('2222-2323-4444-5555', '-', '')),
        UNHEX(REPLACE('1111-2222-4444-8080', '-', '')),
        'OLEG',
        'Second',
        '+1298444',
        NOW()),
        (UNHEX(REPLACE('3333-9898-0000-5555', '-', '')),
        UNHEX(REPLACE('2222-2222-4444-8080', '-', '')),
        'GRISHA',
        'Second2',
        '+123599444',
        NOW()),
        (UNHEX(REPLACE('3333-0101-2222-5555', '-', '')),
        UNHEX(REPLACE('2222-2222-4444-8080', '-', '')),
        'VASY',
        'Second3',
        '+1002364',
        NOW()),
        (UNHEX(REPLACE('8888-0101-2222-5555', '-', '')),
        UNHEX(REPLACE('2222-2222-4444-8080', '-', '')),
        'GRISHA',
        'Second3',
        '+100122364',
        NOW());

# LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT *
FROM employee AS e
    LEFT JOIN pharmacy AS p ON p.pharmacy_id = e.pharmacy_id
WHERE e.first_name = 'GRISHA';

# RIGHT JOIN. Получить такую же выборку, как и в задании выше
SELECT *
FROM pharmacy AS p
    RIGHT JOIN employee AS e ON e.pharmacy_id = p.pharmacy_id
WHERE p.title = 'AptekaRU';

# LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT * FROM employee AS e
LEFT JOIN pharmacy AS p ON p.pharmacy_id = e.pharmacy_id
LEFT JOIN address AS a ON a.address_id = p.address_id
WHERE
    e.first_name = 'GRISHA'
AND
    p.title = 'AptekaEn'
AND
    a.country = 'country2';

# INNER JOIN двух таблиц
SELECT *
FROM address
    INNER JOIN pharmacy ON address.address_id = pharmacy.address_id;


# 3.10 Подзпросы
INSERT INTO address (address_id, country, city, street, building, created_at)
VALUES (UNHEX(REPLACE('1111-9393-2222-3333', '-', '')),
        'country',
        'city',
        'street',
        'building',
        Now()),
        (UNHEX(REPLACE('1111-7373-2222-3333', '-', '')),
        'country2',
        'city',
        'street',
        'building',
        Now());
INSERT INTO pharmacy (pharmacy_id, title, address_id, phone, created_at)
VALUES (UNHEX(REPLACE('1111-3333-4444-8080', '-', '')),
        'AptekaRU',
        UNHEX(REPLACE('1111-9393-2222-3333', '-', '')),
        '+1231023331',
        NOW()),
        (UNHEX(REPLACE('2222-3333-4444-8080', '-', '')),
        'AptekaEN',
        UNHEX(REPLACE('1111-7373-2222-3333', '-', '')),
        '+129933933201',
        NOW());
# Написать запрос с условием WHERE IN (подзапрос)
SELECT *
FROM address AS a
WHERE a.address_id IN (
    SElECT
        address_id
    FROM pharmacy AS p
    WHERE p.title = 'AptekaRU'
 );

INSERT INTO vendor (vendor_id, name, phone, created_at)
VALUES (UNHEX(REPLACE('0000-3333-4444-5555', '-', '')),
        'Vendor21',
        '+22330003433',
        NOW()),
        (UNHEX(REPLACE('0000-2222-4444-5555', '-', '')),
        'Vendor22',
        '+22222003433',
        NOW());
INSERT INTO medicine (medicine_id, vendor_id, title, manual, cost_of_one, is_by_prescription, amount, created_at)
VALUES (UNHEX(REPLACE('9239-1233-4434-5235', '-', '')),
        UNHEX(REPLACE('0000-3333-4444-5555', '-', '')),
        'Paracetamol',
        'Drink drink drink',
        3000,
        false,
        10,
        NOW()),
        (UNHEX(REPLACE('0230-1233-4434-5235', '-', '')),
        UNHEX(REPLACE('0000-3333-4444-5555', '-', '')),
        'Analgin',
        'Drink drink drink',
        170,
        false,
        20,
        NOW()),
        (UNHEX(REPLACE('9239-4322-4434-5235', '-', '')),
        UNHEX(REPLACE('0000-2222-4444-5555', '-', '')),
        'Mizim',
        'Drink drink drink',
        3000,
        false,
        10,
        NOW()),
        (UNHEX(REPLACE('3200-4324-4434-5235', '-', '')),
        UNHEX(REPLACE('0000-2222-4444-5555', '-', '')),
        'Puvorenin',
        'Drink drink drink',
        170,
        false,
        400,
        NOW());

# Написать запрос SELECT atr1, atr2, (подзапрос) FROM (найдёт вендоры с их максимальной поставкой лекарства)
SELECT
    name,
    phone,
    (SELECT
         MAX(amount)
     FROM medicine AS m
     WHERE
         m.vendor_id = v.vendor_id
    ) AS s
FROM vendor AS v
ORDER BY s DESC;

# Написать запрос вида SELECT * FROM (подзапрос)
SELECT * FROM(
    SELECT SUM(DISTINCT cost_of_one) AS total_cost
    FROM medicine
) AS subquery;

# Написать запрос вида SELECT * FROM table JOIN (подзапрос) ON
SELECT *
FROM vendor AS v
JOIN (
    SELECT
        vendor_id,
        title,
        amount
    FROM medicine
) AS subquery
ON subquery.vendor_id = v.vendor_id;

