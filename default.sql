/* ============================================================
   TORN-STYLE CRIME MMORPG — FULL DATABASE SCHEMA
   Engine: InnoDB
   Charset: utf8mb4
   ============================================================ */

SET FOREIGN_KEY_CHECKS = 0;

/* ============================================================
   1. USERS (ACCOUNT LAYER)
   ============================================================ */
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(32) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   2. ROUNDS / WORLDS
   ============================================================ */
CREATE TABLE rounds (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,

    start_date DATETIME NOT NULL,
    end_date DATETIME NULL,

    energy_regen INT NOT NULL DEFAULT 5,
    nerve_regen INT NOT NULL DEFAULT 1,

    is_active TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   3. PLAYER STATE PER ROUND
   ============================================================ */
CREATE TABLE player_rounds (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    user_id BIGINT UNSIGNED NOT NULL,
    round_id INT UNSIGNED NOT NULL,

    username VARCHAR(32) NOT NULL,

    /* Resources */
    energy INT NOT NULL DEFAULT 100,
    max_energy INT NOT NULL DEFAULT 100,

    nerve INT NOT NULL DEFAULT 15,
    max_nerve INT NOT NULL DEFAULT 15,

    happiness INT NOT NULL DEFAULT 2500,
    max_happiness INT NOT NULL DEFAULT 2500,

    /* Rank */
    rank INT NOT NULL DEFAULT 1,
    rank_xp BIGINT NOT NULL DEFAULT 0,

    /* Economy */
    money BIGINT NOT NULL DEFAULT 0,
    net_worth BIGINT NOT NULL DEFAULT 0,

    /* Combat Stats */
    strength DOUBLE NOT NULL DEFAULT 10,
    speed DOUBLE NOT NULL DEFAULT 10,
    defense DOUBLE NOT NULL DEFAULT 10,
    dexterity DOUBLE NOT NULL DEFAULT 10,

    /* Status */
    jail_until DATETIME NULL,
    hospital_until DATETIME NULL,

    last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_user_round (user_id, round_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (round_id) REFERENCES rounds(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   4. CRIMES
   ============================================================ */
CREATE TABLE crimes (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,

    nerve_cost INT NOT NULL,
    base_success FLOAT NOT NULL,

    min_money INT NOT NULL,
    max_money INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE crime_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    player_round_id BIGINT UNSIGNED NOT NULL,
    crime_id INT UNSIGNED NOT NULL,

    success TINYINT(1) NOT NULL,
    money_change INT NOT NULL,
    jail_time INT NOT NULL DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (player_round_id) REFERENCES player_rounds(id),
    FOREIGN KEY (crime_id) REFERENCES crimes(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   5. ATTACKS / PVP
   ============================================================ */
CREATE TABLE attack_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    attacker_id BIGINT UNSIGNED NOT NULL,
    defender_id BIGINT UNSIGNED NOT NULL,
    winner_id BIGINT UNSIGNED NOT NULL,

    money_stolen BIGINT NOT NULL DEFAULT 0,
    respect_change INT NOT NULL DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (attacker_id) REFERENCES player_rounds(id),
    FOREIGN KEY (defender_id) REFERENCES player_rounds(id),
    FOREIGN KEY (winner_id) REFERENCES player_rounds(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   6. GYMS
   ============================================================ */
CREATE TABLE gyms (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,

    energy_cost INT NOT NULL,
    efficiency FLOAT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE gym_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    player_round_id BIGINT UNSIGNED NOT NULL,
    gym_id INT UNSIGNED NOT NULL,

    stat VARCHAR(16) NOT NULL,
    stat_gain DOUBLE NOT NULL,
    happiness_cost INT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (player_round_id) REFERENCES player_rounds(id),
    FOREIGN KEY (gym_id) REFERENCES gyms(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   7. ITEMS
   ============================================================ */
CREATE TABLE items (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(64) NOT NULL,

    energy_restore INT NOT NULL DEFAULT 0,
    nerve_restore INT NOT NULL DEFAULT 0,
    happiness_restore INT NOT NULL DEFAULT 0,

    cooldown INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE player_items (
    player_round_id BIGINT UNSIGNED NOT NULL,
    item_id INT UNSIGNED NOT NULL,
    quantity INT NOT NULL DEFAULT 0,

    PRIMARY KEY (player_round_id, item_id),
    FOREIGN KEY (player_round_id) REFERENCES player_rounds(id),
    FOREIGN KEY (item_id) REFERENCES items(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   8. FACTIONS
   ============================================================ */
CREATE TABLE factions (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    round_id INT UNSIGNED NOT NULL,

    name VARCHAR(64) NOT NULL,
    respect BIGINT NOT NULL DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (round_id) REFERENCES rounds(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE faction_members (
    faction_id INT UNSIGNED NOT NULL,
    player_round_id BIGINT UNSIGNED NOT NULL,
    role VARCHAR(16) NOT NULL DEFAULT 'member',

    PRIMARY KEY (faction_id, player_round_id),
    FOREIGN KEY (faction_id) REFERENCES factions(id),
    FOREIGN KEY (player_round_id) REFERENCES player_rounds(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   9. FACTION WARS
   ============================================================ */
CREATE TABLE faction_wars (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    faction_a INT UNSIGNED NOT NULL,
    faction_b INT UNSIGNED NOT NULL,
    winner INT UNSIGNED NULL,

    started_at DATETIME NOT NULL,
    ended_at DATETIME NULL,

    FOREIGN KEY (faction_a) REFERENCES factions(id),
    FOREIGN KEY (faction_b) REFERENCES factions(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   10. RANK CURVE
   ============================================================ */
CREATE TABLE rank_curve (
    rank INT PRIMARY KEY,
    xp_required BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
