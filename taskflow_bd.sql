-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 15-06-2025 a las 17:32:20
-- Versión del servidor: 8.0.40
-- Versión de PHP: 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `taskflow_bd`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacoras`
--

DROP TABLE IF EXISTS `bitacoras`;
CREATE TABLE IF NOT EXISTS `bitacoras` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `fecha` date NOT NULL,
  `contenido` text,
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `actualizado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `usuario_id` (`usuario_id`,`fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

DROP TABLE IF EXISTS `categorias`;
CREATE TABLE IF NOT EXISTS `categorias` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `color` varchar(7) DEFAULT NULL,
  `icono` varchar(50) DEFAULT NULL,
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tareas`
--

DROP TABLE IF EXISTS `tareas`;
CREATE TABLE IF NOT EXISTS `tareas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `categoria_id` int DEFAULT NULL,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `completada` tinyint(1) DEFAULT '0',
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `actualizado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  KEY `categoria_id` (`categoria_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tareas_archivadas`
--

DROP TABLE IF EXISTS `tareas_archivadas`;
CREATE TABLE IF NOT EXISTS `tareas_archivadas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tarea_id` int NOT NULL,
  `usuario_id` int NOT NULL,
  `archivada_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `tarea_id` (`tarea_id`),
  KEY `usuario_id` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tokens_reseteo`
--

DROP TABLE IF EXISTS `tokens_reseteo`;
CREATE TABLE IF NOT EXISTS `tokens_reseteo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `token` varchar(255) NOT NULL,
  `expiracion` datetime NOT NULL,
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `contraseña` varchar(255) NOT NULL,
  `tema` varchar(10) DEFAULT 'claro',
  `orden_tareas` varchar(20) DEFAULT 'fecha',
  `notificaciones` tinyint(1) DEFAULT '1',
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_tareas_completadas_hoy`
-- (Véase abajo para la vista actual)
--
DROP VIEW IF EXISTS `vista_tareas_completadas_hoy`;
CREATE TABLE IF NOT EXISTS `vista_tareas_completadas_hoy` (
`id` int
,`usuario_id` int
,`categoria_id` int
,`titulo` varchar(255)
,`descripcion` text
,`fecha` date
,`hora` time
,`completada` tinyint(1)
,`creado_en` timestamp
,`actualizado_en` timestamp
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_tareas_por_dia`
-- (Véase abajo para la vista actual)
--
DROP VIEW IF EXISTS `vista_tareas_por_dia`;
CREATE TABLE IF NOT EXISTS `vista_tareas_por_dia` (
`fecha` date
,`total_tareas` bigint
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_tareas_completadas_hoy`
--
DROP TABLE IF EXISTS `vista_tareas_completadas_hoy`;

DROP VIEW IF EXISTS `vista_tareas_completadas_hoy`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_tareas_completadas_hoy`  AS SELECT `tareas`.`id` AS `id`, `tareas`.`usuario_id` AS `usuario_id`, `tareas`.`categoria_id` AS `categoria_id`, `tareas`.`titulo` AS `titulo`, `tareas`.`descripcion` AS `descripcion`, `tareas`.`fecha` AS `fecha`, `tareas`.`hora` AS `hora`, `tareas`.`completada` AS `completada`, `tareas`.`creado_en` AS `creado_en`, `tareas`.`actualizado_en` AS `actualizado_en` FROM `tareas` WHERE ((`tareas`.`completada` = true) AND (`tareas`.`fecha` = curdate())) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_tareas_por_dia`
--
DROP TABLE IF EXISTS `vista_tareas_por_dia`;

DROP VIEW IF EXISTS `vista_tareas_por_dia`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_tareas_por_dia`  AS SELECT `tareas`.`fecha` AS `fecha`, count(0) AS `total_tareas` FROM `tareas` WHERE (`tareas`.`completada` = false) GROUP BY `tareas`.`fecha` ;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `bitacoras`
--
ALTER TABLE `bitacoras`
  ADD CONSTRAINT `bitacoras_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD CONSTRAINT `categorias_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `tareas`
--
ALTER TABLE `tareas`
  ADD CONSTRAINT `tareas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tareas_ibfk_2` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `tareas_archivadas`
--
ALTER TABLE `tareas_archivadas`
  ADD CONSTRAINT `tareas_archivadas_ibfk_1` FOREIGN KEY (`tarea_id`) REFERENCES `tareas` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tareas_archivadas_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `tokens_reseteo`
--
ALTER TABLE `tokens_reseteo`
  ADD CONSTRAINT `tokens_reseteo_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
