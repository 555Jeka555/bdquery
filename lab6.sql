# 1 Добавить внешние ключи
ALTER TABLE booking
    ADD CONSTRAINT `booking_client_id_client_fk`
        FOREIGN KEY (`id_client`) REFERENCES `client` (`id_client`);

ALTER TABLE room
    ADD CONSTRAINT `room_hotel_id_hotel_fk`
        FOREIGN KEY (`id_hotel`) REFERENCES `hotel` (`id_hotel`);
ALTER TABLE room
    ADD CONSTRAINT `room_room_category_id_room_category_fk`
        FOREIGN KEY (`id_room_category`) REFERENCES `room_category` (`id_room_category`);

ALTER TABLE room_in_booking
    ADD CONSTRAINT `room_in_booking_room_id_room_fk`
        FOREIGN KEY (`id_room`) REFERENCES `room` (`id_room`);
ALTER TABLE room_in_booking
    ADD CONSTRAINT `room_in_booking_booking_id_booking_fk`
        FOREIGN KEY (`id_booking`) REFERENCES `booking` (`id_booking`);


# 2 Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах
# категории “Люкс” на 1 апреля 2019г.
SELECT c.id_client, c.name, c.phone
FROM client c
         JOIN booking b USING (id_client)
         JOIN room_in_booking rib USING (id_booking)
         JOIN room r USING (id_room)
         JOIN hotel h USING (id_hotel)
         JOIN room_category rc USING (id_room_category)
WHERE h.name = 'Космос'
  AND rc.name = 'Люкс'
  AND (rib.checkin_date <= '2019-04-01' AND rib.checkout_date > '2019-04-01');

# 3 Дать список свободных номеров всех гостиниц на 22 апреля
SELECT r.number
FROM room r
         JOIN room_in_booking rib USING (id_room)
WHERE NOT (rib.checkin_date <= '2019-04-22' AND rib.checkout_date > '2019-04-22');

# 4 Дать количество проживающих в гостинице “Космос” на 23 марта по каждой
# категории номеров
SELECT rc.name, COUNT(rib.id_room)
FROM hotel h
         JOIN room r USING (id_hotel)
         JOIN room_in_booking rib USING (id_room)
         JOIN room_category rc USING (id_room_category)
WHERE h.name = 'Космос'
  AND rib.checkin_date <= '2019-03-23'
  AND rib.checkout_date > '2019-03-23'
GROUP BY rc.name;

# 5 Дать список последних проживавших клиентов по всем комнатам гостиницы
# “Космос”, выехавшим в апреле с указанием даты выезда
SELECT c.id_client, c.name, rib.checkout_date
FROM client c
         JOIN booking b USING (id_client)
         JOIN room_in_booking rib USING (id_booking)
         JOIN room r USING (id_room)
         JOIN hotel h USING (id_hotel)
WHERE h.name = 'Космос'
  AND MONTH(rib.checkout_date) = 4
  AND rib.checkout_date = (SELECT MAX(rib2.checkout_date)
                           FROM room_in_booking rib2
                                    JOIN booking b2 USING (id_booking)
                                    JOIN client c2 USING (id_client)
                           WHERE c.id_client = c2.id_client
                             AND MONTH(rib2.checkout_date) = 4)
ORDER BY rib.checkout_date DESC;

# 6 Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам
# комнат категории “Бизнес”, которые заселились 10 мая.
UPDATE room_in_booking rib
    JOIN room r USING (id_room)
    JOIN hotel h USING (id_hotel)
    JOIN room_category rc USING (id_room_category)
SET rib.checkout_date = DATE_ADD(rib.checkout_date, INTERVAL 2 DAY)
WHERE h.name = 'Космос'
  AND rc.name = 'Бизнес'
  AND rib.checkin_date = '2019-05-10';

# 7 Найти все "пересекающиеся" варианты проживания. Правильное состояние:
# не может быть забронирован один номер на одну дату несколько раз, т.к. нельзя
# заселиться нескольким клиентам в один номер.
# Записи в таблице room_in_booking с id_room_in_booking = 5
# и 2154 являются примером неправильного состояния, которые необходимо найти.
# Результирующий кортеж выборки должен содержать информацию
# о двух конфликтующих номерах.
SELECT rib1.id_room_in_booking AS conflicting_booking_1,
       rib1.id_booking,
       rib1.id_room,
       rib1.checkin_date,
       rib1.checkout_date,
       rib2.id_room_in_booking AS conflicting_booking_2,
       rib2.id_booking,
       rib2.id_room,
       rib2.checkin_date,
       rib2.checkout_date
FROM room_in_booking rib1
         JOIN room_in_booking rib2 ON rib1.id_room = rib2.id_room
    AND
                                      rib1.id_room_in_booking != rib2.id_room_in_booking
WHERE rib1.checkin_date < rib2.checkout_date
  AND rib1.checkout_date > rib2.checkin_date;

# 8 Создать бронирование в транзакции
START TRANSACTION;

INSERT INTO client (name, phone)
VALUES ('Боба6', '123456789');

SET @client_id = LAST_INSERT_ID();

INSERT INTO booking (id_client, booking_date)
VALUES (@client_id, '2019-01-10');

SET @booking_id = 999999;

INSERT INTO room_in_booking (id_booking, id_room, checkin_date, checkout_date)
VALUES (@booking_id, @client_id, '2024-04-01', '2024-04-05');

COMMIT;
ROLLBACK;

#9 Добавить необходимые индексы для всех таблиц
CREATE INDEX hotel_name_idx ON hotel (name(50));

CREATE INDEX room_category_name_idx ON room_category (name(50));

CREATE INDEX booking_id_client_idx ON booking (id_client);

CREATE INDEX room_id_hotel_idx ON room (id_hotel);
CREATE INDEX room_id_room_category_idx ON room (id_room_category);

CREATE INDEX room_in_booking_id_room_idx ON room_in_booking (id_room);
CREATE INDEX room_in_booking_id_booking_idx ON room_in_booking (id_booking);
CREATE INDEX room_in_booking_checkin_date_checkout_date_idx ON room_in_booking (checkin_date, checkout_date);
CREATE INDEX room_in_booking_checkout_date_checkin_date_idx ON room_in_booking (checkout_date, checkin_date);

DROP INDEX hotel_name_idx ON hotel;

DROP INDEX room_category_name_idx ON room_category;

DROP INDEX booking_id_client_idx ON booking;

DROP INDEX room_id_hotel_idx ON room;
DROP INDEX room_id_room_category_idx ON room;

DROP INDEX room_in_booking_id_room_idx ON room_in_booking;
DROP INDEX room_in_booking_id_booking_idx ON room_in_booking;
DROP INDEX room_in_booking_checkin_date_checkout_date_idx ON room_in_booking;
DROP INDEX room_in_booking_checkout_date_checkin_date_idx ON room_in_booking;
