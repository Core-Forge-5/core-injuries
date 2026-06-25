-- core-injuries  Database Schema
-- Run this manually or enable Config.Persistence.AutoCreateTable = true

CREATE TABLE IF NOT EXISTS `core_crutches_injuries` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(60) NOT NULL COMMENT 'CitizenFX identifier (license:xxx)',
    `tier` VARCHAR(32) NOT NULL COMMENT 'Tier key: minor, moderate, severe, wheelchair, armsling',
    `expiry` BIGINT NOT NULL COMMENT 'Unix timestamp when injury expires',
    `source` VARCHAR(16) NOT NULL COMMENT 'Source: ems, admin, knockout, command',
    `custom_duration` BOOLEAN DEFAULT FALSE COMMENT 'Whether duration was manually set by EMS',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_player` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='core-injuries injury persistence';

-- Index for faster expiry queries
CREATE INDEX IF NOT EXISTS `idx_expiry` ON `core_crutches_injuries` (`expiry`);

-- Example queries used by the resource:

-- Load active injuries on resource start:
-- SELECT identifier, tier, expiry, source, custom_duration FROM core_crutches_injuries WHERE expiry > UNIX_TIMESTAMP();

-- Upsert on ApplyInjury:
-- INSERT INTO core_crutches_injuries (identifier, tier, expiry, source, custom_duration)
-- VALUES (?, ?, ?, ?, ?)
-- ON DUPLICATE KEY UPDATE
--     tier = VALUES(tier),
--     expiry = VALUES(expiry),
--     source = VALUES(source),
--     custom_duration = VALUES(custom_duration),
--     updated_at = CURRENT_TIMESTAMP;

-- Delete on ClearInjury:
-- DELETE FROM core_crutches_injuries WHERE identifier = ?;

-- Cleanup expired injuries:
-- DELETE FROM core_crutches_injuries WHERE expiry <= UNIX_TIMESTAMP();