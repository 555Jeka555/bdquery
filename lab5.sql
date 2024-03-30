USE medicines;

# 1 Добавить внешнии ключи
ALTER TABLE dealer
    ADD CONSTRAINT `dealer_company_id_company_fk`
        FOREIGN KEY (`id_company`) REFERENCES `company` (`id_company`);

ALTER TABLE production
    ADD CONSTRAINT `production_company_id_company_fk`
        FOREIGN KEY (`id_company`) REFERENCES `company` (`id_company`),
    ADD CONSTRAINT `production_medicine_id_medicine_fk`
        FOREIGN KEY (`id_medicine`) REFERENCES `medicine` (`id_medicine`);

ALTER TABLE `order`
    ADD CONSTRAINT `order_dealer_id_dealer_fk`
        FOREIGN KEY (`id_dealer`) REFERENCES `dealer` (`id_dealer`),
    ADD CONSTRAINT `order_pharmacy_id_pharmacy_fk`
        FOREIGN KEY (`id_pharmacy`) REFERENCES `pharmacy` (`id_pharmacy`),
    ADD CONSTRAINT `order_production_id_production_fk`
        FOREIGN KEY (`id_production`) REFERENCES `production` (`id_production`);

# 2 Выдать информацию по всем заказам лекарствам “Кордерон”
# компании “Аргус” с указанием названий аптек, дат, объема заказов.
SELECT m.name, c.name, ph.name, o.date, o.quantity
FROM `order` o
         JOIN production pr USING (id_production)
         JOIN medicine m USING (id_medicine)
         JOIN company c USING (id_company)
         JOIN pharmacy ph USING (id_pharmacy)
WHERE m.name = 'Кордерон'
  AND c.name = 'Аргус';

# 3 Дать список лекарств компании “Фарма”,
# на которые не были сделаны заказы до 25 января
SELECT medicine.name
FROM medicine
WHERE medicine.id_medicine NOT IN (SELECT m.id_medicine
                            FROM medicine AS m
                                     JOIN production pr USING (id_medicine)
                                     JOIN company c USING (id_company)
                                     JOIN `order` o USING (id_production)
                            WHERE c.name = 'Фарма'
                              AND (o.date IS NULL OR o.date < '2019-01-25')
                            );

SELECT medicine.name, o.date
FROM medicine
         JOIN production pr USING (id_medicine)
         JOIN company c USING (id_company)
         JOIN `order` o USING (id_production)
WHERE c.name = 'Фарма'
  AND o.date >= '2019-01-25';

# 4 Дать минимальный и максимальный баллы лекарств каждой фирмы, которая
# оформила не менее 120 заказов
SELECT c.name, c.id_company, MIN(p.rating), MAX(p.rating), COUNT(o.id_order)
FROM company c
         JOIN production p USING (id_company)
         JOIN `order` o USING (id_production)
GROUP BY c.id_company
HAVING COUNT(o.id_order) >= 120;

# 5 Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”.
# Если у дилера нет заказов, в названии аптеки проставить NULL.
SELECT c.name, p.name
FROM dealer d
         LEFT JOIN company c USING (id_company)
         LEFT JOIN `order` o USING (id_dealer)
         LEFT JOIN pharmacy p USING (id_pharmacy)
WHERE c.name = 'AstraZeneca'
GROUP BY p.name;

# 6 Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а
# длительность лечения не более 7 дней.
UPDATE production p
SET p.price = p.price * 0.8
WHERE p.price > 3000
AND p.id_medicine IN (SELECT m.id_medicine
                    FROM medicine m
                    WHERE m.cure_duration <= 7);

# 7 Добавить необходимые индексы.
CREATE INDEX medicine_name_asc_idx ON medicine(name(100));
CREATE INDEX medicine_name_idx ON medicine(cure_duration);

CREATE INDEX company_name_asc_idx ON company(name(100));
CREATE INDEX company_name_desc_idx ON company(name(100) DESC);

CREATE INDEX order_name_asc_idx ON `order`(date(6));
CREATE INDEX order_name_desc_idx ON `order`(date(6) DESC);

CREATE INDEX production_rating_asc_idx ON production(rating);
CREATE INDEX production_rating_desc_idx ON production(rating DESC);
# CREATE INDEX production_price_idx ON production(price(100) DESC);

DROP INDEX medicine_name_asc_idx ON medicine;
DROP INDEX medicine_name_idx ON medicine;

DROP INDEX company_name_asc_idx ON company;
DROP INDEX company_name_desc_idx ON company;

DROP INDEX order_name_asc_idx ON `order`;
DROP INDEX order_name_desc_idx ON `order`;

DROP INDEX production_rating_asc_idx ON production;
DROP INDEX production_rating_desc_idx ON production;
# DROP INDEX production_price_idx ON production;
