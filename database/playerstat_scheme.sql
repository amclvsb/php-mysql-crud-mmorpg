-- PERSONAL STATS MASTER TABLE
CREATE TABLE ps_personalstats (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ATTACKING (TOP LEVEL)
CREATE TABLE ps_attacking (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    elo BIGINT,
    unarmored_wins BIGINT,
    highest_level_beaten BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_attacking_attacks (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    won BIGINT,
    lost BIGINT,
    stalemate BIGINT,
    assist BIGINT,
    stealth BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_attacking_defends (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    won BIGINT,
    lost BIGINT,
    stalemate BIGINT,
    total BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_attacking_escapes (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    player BIGINT,
    foes BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_attacking_killstreak (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    best BIGINT,
    current BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_attacking_hits (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    success BIGINT,
    miss BIGINT,
    critical BIGINT,
    one_hit_kills BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_attacking_damage (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    total BIGINT,
    best BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_attacking_networth (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    money_mugged BIGINT,
    largest_mug BIGINT,
    items_looted BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_attacking_ammunition (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    total BIGINT,
    special BIGINT,
    hollow_point BIGINT,
    tracer BIGINT,
    piercing BIGINT,
    incendiary BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_attacking_faction (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    respect BIGINT,
    retaliations BIGINT,
    ranked_war_hits BIGINT,
    raid_hits BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_attacking_faction_territory (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    wall_joins BIGINT,
    wall_clears BIGINT,
    wall_time BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- BATTLE STATS
CREATE TABLE ps_battle_stats (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    strength BIGINT,
    defense BIGINT,
    speed BIGINT,
    dexterity BIGINT,
    total BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- JOBS
CREATE TABLE ps_jobs (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    job_points_used BIGINT,
    trains_received BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_jobs_stats (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    manual BIGINT,
    intelligence BIGINT,
    endurance BIGINT,
    total BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- TRADING
CREATE TABLE ps_trading (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    trades BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_trading_items_bought (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    market BIGINT,
    shops BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_trading_items_auctions (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    won BIGINT,
    sold BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_trading_items (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    sent BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_trading_points (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    bought BIGINT,
    sold BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_trading_bazaar (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    customers BIGINT,
    sales BIGINT,
    profit BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_trading_item_market (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    customers BIGINT,
    sales BIGINT,
    revenue BIGINT,
    fees BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- JAIL
CREATE TABLE ps_jail (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    times_jailed BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_jail_busts (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    success BIGINT,
    fails BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_jail_bails (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    amount BIGINT,
    fees BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- HOSPITAL
CREATE TABLE ps_hospital (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    times_hospitalized BIGINT,
    medical_items_used BIGINT,
    blood_withdrawn BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_hospital_reviving (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    skill BIGINT,
    revives BIGINT,
    revives_received BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- FINISHING HITS
CREATE TABLE ps_finishing_hits (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    heavy_artillery BIGINT,
    machine_guns BIGINT,
    rifles BIGINT,
    sub_machine_guns BIGINT,
    shotguns BIGINT,
    pistols BIGINT,
    temporary BIGINT,
    piercing BIGINT,
    slashing BIGINT,
    clubbing BIGINT,
    mechanical BIGINT,
    hand_to_hand BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- COMMUNICATION
CREATE TABLE ps_communication_mails_sent (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    total BIGINT,
    friends BIGINT,
    faction BIGINT,
    colleagues BIGINT,
    spouse BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_communication (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    classified_ads BIGINT,
    personals BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- CRIMES
CREATE TABLE ps_crimes (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    total BIGINT,
    sell_illegal_goods BIGINT,
    theft BIGINT,
    auto_theft BIGINT,
    drug_deals BIGINT,
    computer BIGINT,
    fraud BIGINT,
    murder BIGINT,
    other BIGINT,
    organized_crimes BIGINT,
    version VARCHAR(32),
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- BOUNTIES
CREATE TABLE ps_bounties_placed (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    amount BIGINT,
    value BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_bounties_collected (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    amount BIGINT,
    value BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_bounties_received (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    amount BIGINT,
    value BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- INVESTMENTS
CREATE TABLE ps_investments_bank (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    total BIGINT,
    profit BIGINT,
    current BIGINT,
    time_remaining BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_investments_stocks (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    profits BIGINT,
    losses BIGINT,
    fees BIGINT,
    net_profits BIGINT,
    payouts BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- ITEMS
CREATE TABLE ps_items_found (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    city BIGINT,
    dump BIGINT,
    easter_eggs BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_items_used (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    books BIGINT,
    boosters BIGINT,
    consumables BIGINT,
    candy BIGINT,
    alcohol BIGINT,
    energy_drinks BIGINT,
    stat_enhancers BIGINT,
    easter_eggs BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_items (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    trashed BIGINT,
    viruses_coded BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- TRAVEL
CREATE TABLE ps_travel (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    total BIGINT,
    time_spent BIGINT,
    items_bought BIGINT,
    hunting_skill BIGINT,
    attacks_won BIGINT,
    defends_lost BIGINT,
    argentina BIGINT,
    canada BIGINT,
    cayman_islands BIGINT,
    china BIGINT,
    hawaii BIGINT,
    japan BIGINT,
    mexico BIGINT,
    united_arab_emirates BIGINT,
    united_kingdom BIGINT,
    south_africa BIGINT,
    switzerland BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- DRUGS
CREATE TABLE ps_drugs (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    cannabis BIGINT,
    ecstasy BIGINT,
    ketamine BIGINT,
    lsd BIGINT,
    opium BIGINT,
    pcp BIGINT,
    shrooms BIGINT,
    speed BIGINT,
    vicodin BIGINT,
    xanax BIGINT,
    total BIGINT,
    overdoses BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_drugs_rehab (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    amount BIGINT,
    fees BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- MISSIONS
CREATE TABLE ps_missions (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    missions BIGINT,
    credits BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_missions_contracts (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    total BIGINT,
    duke BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- RACING
CREATE TABLE ps_racing (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    skill BIGINT,
    points BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_racing_races (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    entered BIGINT,
    won BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- NETWORTH
CREATE TABLE ps_networth (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    total BIGINT,
    wallet BIGINT,
    vaults BIGINT,
    bank BIGINT,
    overseas_bank BIGINT,
    points BIGINT,
    inventory BIGINT,
    display_case BIGINT,
    bazaar BIGINT,
    item_market BIGINT,
    property BIGINT,
    stock_market BIGINT,
    auction_house BIGINT,
    bookie BIGINT,
    company BIGINT,
    enlisted_cars BIGINT,
    piggy_bank BIGINT,
    pending BIGINT,
    loans BIGINT,
    unpaid_fees BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

-- OTHER / ACTIVITY / REFILLS
CREATE TABLE ps_other_activity (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    time BIGINT,
    streak_best BIGINT,
    streak_current BIGINT,
    awards BIGINT,
    merits_bought BIGINT,
    donator_days BIGINT,
    ranked_war_wins BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);

CREATE TABLE ps_other_refills (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    energy BIGINT,
    nerve BIGINT,
    token BIGINT,
    FOREIGN KEY (user_id) REFERENCES ps_personalstats(user_id) ON DELETE CASCADE
);
