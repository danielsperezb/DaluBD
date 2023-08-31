-- Desactivar claves foráneas para permitir la eliminación de tablas
SET FOREIGN_KEY_CHECKS = 0;

DROP PROCEDURE IF EXISTS UpdateSubcategoryBalances;
DROP PROCEDURE IF EXISTS ConvertCurrency;
DROP PROCEDURE IF EXISTS UpdateCategoryBalances ;
DROP PROCEDURE IF EXISTS UpdateAccountBalance ;
DROP PROCEDURE IF EXISTS UpdateUserBalance ;

  
-- Eliminar todas las tablas
DROP TABLE IF EXISTS `transactions`;
DROP TABLE IF EXISTS `subcategories`;
DROP TABLE IF EXISTS `categories`;
DROP TABLE IF EXISTS `accounts`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `types`;
DROP TABLE IF EXISTS `currency_conversion`;

-- Reactivar claves foráneas después de eliminar tablas
SET FOREIGN_KEY_CHECKS = 1;






--
-- Base de datos: `u314379653_dalugestorfin`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `accountname` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `currency` varchar(4) NOT NULL,
  `balance` double NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;



-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `categoriename` varchar(255) NOT NULL,
  `balance` double NOT NULL,
  `currency` varchar(4) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `account_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;



-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `currency_conversion`
--

CREATE TABLE `currency_conversion` (
  `id` int(11) NOT NULL,
  `currency` varchar(4) NOT NULL,
  `equivalence1dolar` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subcategories`
--

CREATE TABLE `subcategories` (
  `id` int(11) NOT NULL,
  `subcategoryname` varchar(255) NOT NULL,
  `balance` double NOT NULL,
  `currency` varchar(4) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `categorie_id` int(11) NOT NULL,
  `type_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `currency` varchar(4) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `amount` double NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `subcategorie_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;



-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `types`
--

CREATE TABLE `types` (
  `id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `action` varchar(20) NOT NULL DEFAULT 'Ingreso'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `types`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `country` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `currency` varchar(5) NOT NULL,
  `balance` double NOT NULL,
  `password` varchar(255) NOT NULL,
  `authorization` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;


--
-- Disparadores `users`
--
DELIMITER $$
CREATE TRIGGER `check_valid_email` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    IF NEW.email NOT LIKE '%@%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El formato del correo electrónico no es válido';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `set_random_authorization` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    SET NEW.authorization = FLOOR(RAND() * 9000) + 1000; -- Genera un número aleatorio de 4 dígitos
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_accounts_user_id` (`user_id`);

--
-- Indices de la tabla `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_categories_accounts_id` (`account_id`),
  ADD KEY `fk_categories_currency` (`currency`);

--
-- Indices de la tabla `currency_conversion`
--
ALTER TABLE `currency_conversion`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `currency` (`currency`);

--
-- Indices de la tabla `subcategories`
--
ALTER TABLE `subcategories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_subcategories_categories_id` (`categorie_id`),
  ADD KEY `fk_subcategories_type_id` (`type_id`),
  ADD KEY `fk_subcategories_currency` (`currency`);

--
-- Indices de la tabla `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_transactions_subcategorie_id` (`subcategorie_id`),
  ADD KEY `fk_transactions_currency` (`currency`);

--
-- Indices de la tabla `types`
--
ALTER TABLE `types`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_users_currency` (`currency`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `currency_conversion`
--
ALTER TABLE `currency_conversion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `subcategories`
--
ALTER TABLE `subcategories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `types`
--
ALTER TABLE `types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `fk_accounts_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `fk_categories_accounts_id` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_categories_currency` FOREIGN KEY (`currency`) REFERENCES `currency_conversion` (`currency`) ON DELETE CASCADE;

--
-- Filtros para la tabla `subcategories`
--
ALTER TABLE `subcategories`
  ADD CONSTRAINT `fk_subcategories_categories_id` FOREIGN KEY (`categorie_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_subcategories_currency` FOREIGN KEY (`currency`) REFERENCES `currency_conversion` (`currency`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_subcategories_type_id` FOREIGN KEY (`type_id`) REFERENCES `types` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `fk_transactions_currency` FOREIGN KEY (`currency`) REFERENCES `currency_conversion` (`currency`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_transactions_subcategorie_id` FOREIGN KEY (`subcategorie_id`) REFERENCES `subcategories` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_currency` FOREIGN KEY (`currency`) REFERENCES `currency_conversion` (`currency`) ON DELETE CASCADE;
COMMIT;






-- ------------------------------------------------------------------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE ConvertCurrency(
    IN amount_to_convert DOUBLE,
    IN source_currency VARCHAR(4),
    IN target_currency VARCHAR(4),
    OUT converted_amount DOUBLE
)
BEGIN
    DECLARE source_equivalence DOUBLE;
    DECLARE target_equivalence DOUBLE;

    -- Obtener las equivalencias de las divisas
    SELECT equivalence1dolar INTO source_equivalence
    FROM currency_conversion
    WHERE currency = source_currency;

    SELECT equivalence1dolar INTO target_equivalence
    FROM currency_conversion
    WHERE currency = target_currency;

    -- Realizar la conversión
    SET converted_amount = (amount_to_convert / source_equivalence) * target_equivalence;
END;

$$

DELIMITER ;

-- ------------------------------------------------------------------------------------------------------------------


-- ------------------------------------------------------------------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE UpdateSubcategoryBalances(IN subcategory_id INT)
BEGIN
    -- Update subcategory balance for income transactions
    UPDATE subcategories s
    SET s.balance = (
        SELECT SUM(
            t.amount / (SELECT equivalence1dolar FROM currency_conversion WHERE currency = t.currency) 
        )
        FROM transactions t
        WHERE t.subcategorie_id = s.id AND s.type_id = 1
    )
    WHERE s.id = subcategory_id AND s.type_id = 1;

    -- Update subcategory balance for expenditure transactions
    UPDATE subcategories s
    SET s.balance = (
        SELECT -SUM(
            t.amount / (SELECT equivalence1dolar FROM currency_conversion WHERE currency = t.currency) 
        )
        FROM transactions t
        WHERE t.subcategorie_id = s.id AND s.type_id = 2
    )
    WHERE s.id = subcategory_id AND s.type_id = 2;
    
END;

$$

DELIMITER ;



-- ------------------------------------------------------------------------------------------------------------------

DELIMITER $$

CREATE TRIGGER BeforeUpdateSubcategoryCurrency
BEFORE UPDATE ON subcategories
FOR EACH ROW
BEGIN
    DECLARE new_balance DOUBLE;
    DECLARE converted_balance DOUBLE;

    IF NEW.currency != OLD.currency THEN
        SET new_balance = NEW.balance;

        CALL ConvertCurrency(new_balance, OLD.currency, NEW.currency, converted_balance);

        -- Actualizar el nuevo balance en la fila NEW antes de la actualización
        SET NEW.balance = converted_balance;
    END IF;
END$$

DELIMITER ;











DELIMITER $$

CREATE PROCEDURE UpdateCategoryBalances(IN category_id INT)
BEGIN
    DECLARE cat_currency VARCHAR(4);
    
    -- Get the currency of the category
    SELECT currency INTO cat_currency
    FROM categories
    WHERE id = category_id;
    
    -- Update category balance
    UPDATE categories c
    SET c.balance = (
        SELECT SUM(
            (s.balance / (SELECT equivalence1dolar FROM currency_conversion WHERE currency = s.currency)) * (SELECT equivalence1dolar FROM currency_conversion WHERE currency = cat_currency)
        )
        FROM subcategories s
        WHERE s.categorie_id = c.id
    )
    WHERE c.id = category_id;
    
END;

$$

DELIMITER ;





DELIMITER $$

CREATE PROCEDURE UpdateAccountBalance(IN account_id INT)
BEGIN
    DECLARE acc_balance DOUBLE;
    DECLARE acc_currency VARCHAR(4);
    
    -- Get the currency of the account
    SELECT currency INTO acc_currency
    FROM accounts
    WHERE id = account_id;

    -- Calculate account balance
    SELECT SUM((c.balance / (SELECT equivalence1dolar FROM currency_conversion WHERE currency = c.currency)) * (SELECT equivalence1dolar FROM currency_conversion WHERE currency = acc_currency)) INTO acc_balance
    FROM categories c
    WHERE c.account_id = account_id;
    
    -- Update the account balance
    UPDATE accounts SET balance = acc_balance WHERE id = account_id;
    
END;

$$

DELIMITER ;





DELIMITER $$

CREATE PROCEDURE UpdateUserBalance(IN user_id INT)
BEGIN
    DECLARE user_balance DOUBLE;
    DECLARE user_currency VARCHAR(4);
    
    -- Get the currency of the user
    SELECT currency INTO user_currency
    FROM users
    WHERE id = user_id;

    -- Calculate user balance
    SELECT SUM((a.balance / (SELECT equivalence1dolar FROM currency_conversion WHERE currency = a.currency)) * (SELECT equivalence1dolar FROM currency_conversion WHERE currency = user_currency)) INTO user_balance
    FROM accounts a
    WHERE a.user_id = user_id;
    
    -- Update the user's balance
    UPDATE users
    SET balance = user_balance
    WHERE id = user_id;
    
END;

$$

DELIMITER ;




DELIMITER $$

CREATE TRIGGER AfterInsertTransaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE cat_id INT;
    DECLARE acc_id INT;
    DECLARE users_id INT; -- Agregar esta variable para almacenar el user_id
    
    -- Llamar al procedimiento para actualizar el balance de la subcategoría
    CALL UpdateSubcategoryBalances(NEW.subcategorie_id);

    -- Obtener el categorie_id correspondiente al subcategorie_id
    SELECT categorie_id INTO cat_id
    FROM subcategories
    WHERE id = NEW.subcategorie_id;

    -- Llamar al procedimiento para actualizar el balance de la categoría
    CALL UpdateCategoryBalances(cat_id);

    -- Obtener el account_id correspondiente al categorie_id
    SELECT account_id INTO acc_id
    FROM categories
    WHERE id = cat_id;

    -- Llamar al procedimiento para actualizar el balance de la cuenta
    CALL UpdateAccountBalance(acc_id);

    -- Obtener el user_id correspondiente al account_id
    SELECT user_id INTO users_id
    FROM accounts
    WHERE id = acc_id;

    -- Llamar al procedimiento para actualizar el balance del usuario
    CALL UpdateUserBalance(users_id);
    
END;

$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER AfterUpdateTransaction
AFTER UPDATE ON transactions
FOR EACH ROW
BEGIN
    DECLARE cat_id INT;
    DECLARE acc_id INT;
    DECLARE users_id INT; -- Agregar esta variable para almacenar el user_id

    IF NEW.currency != OLD.currency OR NEW.amount != OLD.amount THEN
        -- Llamar al procedimiento para actualizar el balance de la subcategoría
        CALL UpdateSubcategoryBalances(NEW.subcategorie_id);

        -- Obtener el categorie_id correspondiente al subcategorie_id
        SELECT categorie_id INTO cat_id
        FROM subcategories
        WHERE id = NEW.subcategorie_id;

        -- Llamar al procedimiento para actualizar el balance de la categoría
        CALL UpdateCategoryBalances(cat_id);

        -- Obtener el account_id correspondiente al categorie_id
        SELECT account_id INTO acc_id
        FROM categories
        WHERE id = cat_id;

        -- Llamar al procedimiento para actualizar el balance de la cuenta
        CALL UpdateAccountBalance(acc_id);

        -- Obtener el user_id correspondiente al account_id
        SELECT user_id INTO users_id
        FROM accounts
        WHERE id = acc_id;

        -- Llamar al procedimiento para actualizar el balance del usuario
        CALL UpdateUserBalance(users_id);
        
    END IF;
END;

$$

DELIMITER ;




DELIMITER $$

CREATE TRIGGER AfterDeleteTransaction
AFTER DELETE ON transactions
FOR EACH ROW
BEGIN
    DECLARE cat_id INT;
    DECLARE acc_id INT;
    DECLARE user_id INT; -- Agregar esta variable para almacenar el user_id

    -- Llamar al procedimiento para actualizar el balance de la subcategoría
    CALL UpdateSubcategoryBalances(OLD.subcategorie_id);

    -- Obtener el categorie_id correspondiente al subcategorie_id
    SELECT categorie_id INTO cat_id
    FROM subcategories
    WHERE id = OLD.subcategorie_id;

    -- Llamar al procedimiento para actualizar el balance de la categoría
    CALL UpdateCategoryBalances(cat_id);

    -- Obtener el account_id correspondiente al categorie_id
    SELECT account_id INTO acc_id
    FROM categories
    WHERE id = cat_id;

    -- Llamar al procedimiento para actualizar el balance de la cuenta
    CALL UpdateAccountBalance(acc_id);

    -- Obtener el user_id correspondiente al account_id
    SELECT user_id INTO user_id
    FROM accounts
    WHERE id = acc_id;

    -- Llamar al procedimiento para actualizar el balance del usuario
    CALL UpdateUserBalance(user_id);
END;

$$

DELIMITER ;









DELIMITER $$

CREATE TRIGGER AfterDeleteCategory
AFTER DELETE ON categories
FOR EACH ROW
BEGIN
    DECLARE users_id INT;

    -- Obtener el user_id correspondiente al account_id que está siendo eliminado
    SELECT user_id INTO users_id
    FROM accounts
    WHERE id = OLD.account_id;

    -- Llamar al procedimiento para actualizar el balance de la cuenta
    CALL UpdateAccountBalance(OLD.account_id);

    -- Llamar al procedimiento para actualizar el balance del usuario
    CALL UpdateUserBalance(users_id);
END;

$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER AfterDeleteSubcategory
AFTER DELETE ON subcategories
FOR EACH ROW
BEGIN
    DECLARE acc_id INT;
    DECLARE users_id INT;

    -- Llamar al procedimiento para actualizar los saldos de las categorías
    CALL UpdateCategoryBalances(OLD.categorie_id);

    -- Obtener el account_id correspondiente al categorie_id
    SELECT account_id INTO acc_id
    FROM categories
    WHERE id = OLD.categorie_id;

    -- Llamar al procedimiento para actualizar el balance de la cuenta
    CALL UpdateAccountBalance(acc_id);

    -- Obtener el user_id correspondiente al account_id
    SELECT user_id INTO users_id
    FROM accounts
    WHERE id = acc_id;

    -- Llamar al procedimiento para actualizar el balance del usuario
    CALL UpdateUserBalance(users_id);
END;

$$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER AfterDeleteAccount
AFTER DELETE ON accounts
FOR EACH ROW
BEGIN
    
    CALL UpdateUserBalance(OLD.user_id);


END;

$$

DELIMITER ;








INSERT INTO `currency_conversion` (`id`, `currency`, `equivalence1dolar`) VALUES
(1, 'USD', 1),
(2, 'COP', 4167.588127),
(3, 'GBP', 0.782897),
(4, 'BTC', 0.000035);


INSERT INTO `types` (`id`, `type`, `action`) VALUES
(1, 1, 'Income'),
(2, 2, 'Expenditure');


--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `country`, `phone`, `currency`, `balance`, `password`, `authorization`) VALUES
(10, 'usuario1', 'usuario1@example.com', 'País1', '123456789', 'USD', 0, 'contraseña1', 0),
(11, 'usuario3', 'usuario3@example.com', 'País3', '555555555', 'GBP', 0, 'contraseña3', 0),
(12, 'usuario4', 'usuario4@example.com', 'País4', '111111111', 'BTC', 0, 'contraseña4', 0);



--
-- Volcado de datos para la tabla `accounts`
--

INSERT INTO `accounts` (`id`, `accountname`, `description`, `currency`, `balance`, `user_id`) VALUES
(1, 'Cuenta Personal', 'Cuenta de ahorros personal', 'USD', 0, 10),
(2, 'Cuenta de Gastos', 'Cuenta para gastos diarios', 'USD', 0, 11),
(3, 'Cuenta de Viaje', 'Cuenta para gastos de viaje', 'GBP', 0, 12),
(4, 'Cuenta Empresarial', 'Cuenta para negocio', 'USD', 0, 12);

--
-- Volcado de datos para la tabla `categories`
--

INSERT INTO `categories` (`id`, `categoriename`, `balance`, `currency`, `account_id`) VALUES
(1, 'Alimentos', 0, 'USD', 1),
(2, 'Transporte', 0, 'USD', 1),
(3, 'Entretenimiento', 0, 'GBP', 3),
(4, 'Comida', 0, 'GBP', 3),
(5, 'Suministros de Oficina', 0, 'USD', 4);


--
-- Volcado de datos para la tabla `subcategories`
--

INSERT INTO `subcategories` (`id`, `subcategoryname`, `balance`, `currency`, `categorie_id`, `type_id`) VALUES
(1, 'Verduras', 0, 'USD', 1, 2),
(2, 'Restaurantes', 0, 'USD', 2, 2),
(3, 'Cine', 0, 'GBP', 3, 2),
(4, 'Teatro', 0, 'GBP', 3, 2),
(5, 'Frutas', 0, 'USD', 1, 2),
(6, 'Taxis', 0, 'USD', 2, 2),
(7, 'Comida Rápida', 0, 'GBP', 4, 2),
(8, 'Utensilios', 0, 'USD', 5, 1);


--
-- Volcado de datos para la tabla `transactions`
--


-- INSERT INTO `transactions` (`id`, `date`, `currency`, `amount`, `descripcion`, `subcategorie_id`)
-- VALUES (1, '2023-08-29', 'USD', 1, 'Compras en el supermercado', 1);

-- SELECT SLEEP(5); -- Pausa de 5 segundos

-- INSERT INTO `transactions` (`id`, `date`, `currency`, `amount`, `descripcion`, `subcategorie_id`)
-- VALUES (2, '2023-08-28', 'USD', 1, 'Cena con amigos', 2);

-- SELECT SLEEP(5); -- Pausa de 5 segundos

-- INSERT INTO `transactions` (`id`, `date`, `currency`, `amount`, `descripcion`, `subcategorie_id`)
-- VALUES (3, '2023-08-27', 'GBP', 1, 'Boletos de cine', 3);

-- SELECT SLEEP(5); -- Pausa de 5 segundos

-- INSERT INTO `transactions` (`id`, `date`, `currency`, `amount`, `descripcion`, `subcategorie_id`)
-- VALUES (4, '2023-08-26', 'GBP', 1, 'Boletos de teatro', 4);

-- SELECT SLEEP(5); -- Pausa de 5 segundos

-- INSERT INTO `transactions` (`id`, `date`, `currency`, `amount`, `descripcion`, `subcategorie_id`)
-- VALUES (5, '2023-08-25', 'USD', 1, 'Frutas frescas', 5);

-- SELECT SLEEP(5); -- Pausa de 5 segundos

-- INSERT INTO `transactions` (`id`, `date`, `currency`, `amount`, `descripcion`, `subcategorie_id`)
-- VALUES (6, '2023-08-24', 'USD', 1, 'Viaje en taxi', 6);

-- SELECT SLEEP(5); -- Pausa de 5 segundos

-- INSERT INTO `transactions` (`id`, `date`, `currency`, `amount`, `descripcion`, `subcategorie_id`)
-- VALUES (7, '2023-08-23', 'GBP', 1, 'Comida rápida', 7);

-- SELECT SLEEP(5); -- Pausa de 5 segundos


-- INSERT INTO `transactions` (`id`, `date`, `currency`, `amount`, `descripcion`, `subcategorie_id`)
-- VALUES (8, '2023-08-22', 'USD', 1, 'Compra de útiles', 8);




INSERT INTO `transactions` (`id`, `date`, `currency`, `amount`, `descripcion`, `subcategorie_id`) VALUES
(1, '2023-08-29', 'USD', 50.25, 'Compras en el supermercado', 1),
(2, '2023-08-28', 'USD', 20.5, 'Cena con amigos', 2),
(3, '2023-08-27', 'GBP', 25, 'Boletos de cine', 3),
(4, '2023-08-26', 'GBP', 40, 'Boletos de teatro', 4),
(5, '2023-08-25', 'USD', 15.75, 'Frutas frescas', 5),
(6, '2023-08-24', 'USD', 30, 'Viaje en taxi', 6),
(7, '2023-08-23', 'GBP', 12.5, 'Comida rápida', 7),
(8, '2023-08-22', 'USD', 10, 'Compra de útiles', 8);





-- -- Desactivar claves foráneas para permitir la eliminación de tablas
-- SET FOREIGN_KEY_CHECKS = 0;

-- -- Eliminar todas las tablas
-- DROP TABLE IF EXISTS `transactions`;
-- DROP TABLE IF EXISTS `subcategories`;
-- DROP TABLE IF EXISTS `categories`;
-- DROP TABLE IF EXISTS `accounts`;
-- DROP TABLE IF EXISTS `users`;
-- DROP TABLE IF EXISTS `types`;
-- DROP TABLE IF EXISTS `currency_conversion`;

-- -- Reactivar claves foráneas después de eliminar tablas
-- SET FOREIGN_KEY_CHECKS = 1;
