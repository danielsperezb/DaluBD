-- Desactivar claves foráneas para permitir la eliminación de tablas
SET FOREIGN_KEY_CHECKS = 0;

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


DELIMITER $$

CREATE PROCEDURE UpdateSubcategoryBalances(IN subcategory_id INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE trans_id INT;
    DECLARE trans_amount DOUBLE;
    DECLARE trans_currency VARCHAR(4);
    DECLARE subcat_currency VARCHAR(4);
    
    -- Cursor para obtener las transacciones de la subcategoría
    DECLARE cur CURSOR FOR
        SELECT id, amount, currency
        FROM transactions
        WHERE subcategorie_id = subcategory_id;
    
    -- Declarar manejador para NOT FOUND
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Obtener la divisa de la subcategoría
    SELECT currency INTO subcat_currency
    FROM subcategories
    WHERE id = subcategory_id;
    
    -- Inicializar balance de subcategoría en 0
    SET @subcategory_balance = 0;
    
    -- Abrir el cursor
    OPEN cur;
    
    read_loop: LOOP
        -- Obtener valores de la transacción
        FETCH cur INTO trans_id, trans_amount, trans_currency;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Convertir el monto de la transacción a la divisa de la subcategoría
        CALL ConvertCurrency(trans_amount, trans_currency, subcat_currency, @converted_amount);
        
        -- Actualizar el balance de la subcategoría
        SET @subcategory_balance = @subcategory_balance + @converted_amount;
    END LOOP;
    
    -- Cerrar el cursor
    CLOSE cur;
    
    -- Actualizar el balance de la subcategoría
    UPDATE subcategories SET balance = @subcategory_balance WHERE id = subcategory_id;
    
END;

$$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER AfterInsertTransaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    -- Llamar al procedimiento para actualizar el balance de la subcategoría
    CALL UpdateSubcategoryBalances(NEW.subcategorie_id);
END;

$$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER AfterUpdateTransaction
AFTER UPDATE ON transactions
FOR EACH ROW
BEGIN
    -- Llamar al procedimiento para actualizar el balance de la subcategoría
    CALL UpdateSubcategoryBalances(NEW.subcategorie_id);
END;

$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER AfterDeleteTransaction
AFTER DELETE ON transactions
FOR EACH ROW
BEGIN
    -- Llamar al procedimiento para actualizar el balance de la subcategoría
    CALL UpdateSubcategoryBalances(OLD.subcategorie_id);
END;

$$

DELIMITER ;









--
-- Volcado de datos para la tabla `currency_conversion`
--

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
(1, 'Cuenta Personal', 'Cuenta de ahorros personal', 'USD', 500, 10),
(2, 'Cuenta de Gastos', 'Cuenta para gastos diarios', 'USD', 100, 11),
(3, 'Cuenta de Viaje', 'Cuenta para gastos de viaje', 'GBP', 1000, 12),
(4, 'Cuenta Empresarial', 'Cuenta para negocio', 'USD', 2000, 12);

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
