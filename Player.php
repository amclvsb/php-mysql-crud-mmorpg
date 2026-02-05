<?php

class Player implements PlayerInterface
{
    /* =============================
       CORE IDENTIFIERS
       ============================= */
    private int $id;              // player_rounds.id
    private int $userId;
    private int $roundId;
    private string $username;

    /* =============================
       RESOURCES
       ============================= */
    private int $energy;
    private int $maxEnergy;

    private int $nerve;
    private int $maxNerve;

    private int $happiness;
    private int $maxHappiness;

    /* =============================
       PROGRESSION
       ============================= */
    private int $rank;
    private int $rankXp;

    /* =============================
       ECONOMY
       ============================= */
    private int $money;
    private int $netWorth;

    /* =============================
       COMBAT STATS
       ============================= */
    private float $strength;
    private float $speed;
    private float $defense;
    private float $dexterity;

    /* =============================
       STATUS
       ============================= */
    private ?string $jailUntil;
    private ?string $hospitalUntil;

    /* =============================
       CONSTRUCTOR (HYDRATION)
       ============================= */
    public function __construct(array $row)
    {
        $this->id         = (int)$row['id'];
        $this->userId     = (int)$row['user_id'];
        $this->roundId    = (int)$row['round_id'];
        $this->username   = $row['username'];

        $this->energy     = (int)$row['energy'];
        $this->maxEnergy  = (int)$row['max_energy'];

        $this->nerve      = (int)$row['nerve'];
        $this->maxNerve   = (int)$row['max_nerve'];

        $this->happiness    = (int)$row['happiness'];
        $this->maxHappiness = (int)$row['max_happiness'];

        $this->rank       = (int)$row['rank'];
        $this->rankXp     = (int)$row['rank_xp'];

        $this->money      = (int)$row['money'];
        $this->netWorth   = (int)$row['net_worth'];

        $this->strength   = (float)$row['strength'];
        $this->speed      = (float)$row['speed'];
        $this->defense    = (float)$row['defense'];
        $this->dexterity  = (float)$row['dexterity'];

        $this->jailUntil      = $row['jail_until'];
        $this->hospitalUntil  = $row['hospital_until'];
    }

    /* =============================
       BASIC GETTERS
       ============================= */
    public function getId(): int { return $this->id; }
    public function getUsername(): string { return $this->username; }

    /* =============================
       ENERGY / NERVE
       ============================= */
    public function getEnergy(): int { return $this->energy; }
    public function getMaxEnergy(): int { return $this->maxEnergy; }

    public function consumeEnergy(int $amount): bool
    {
        if ($this->energy < $amount) {
            return false;
        }
        $this->energy -= $amount;
        return true;
    }

    public function getNerve(): int { return $this->nerve; }
    public function getMaxNerve(): int { return $this->maxNerve; }

    public function consumeNerve(int $amount): bool
    {
        if ($this->nerve < $amount) {
            return false;
        }
        $this->nerve -= $amount;
        return true;
    }

    /* =============================
       HAPPINESS
       ============================= */
    public function getHappiness(): int { return $this->happiness; }
    public function getMaxHappiness(): int { return $this->maxHappiness; }

    public function changeHappiness(int $amount): void
    {
        $this->happiness += $amount;

        if ($this->happiness < 0) {
            $this->happiness = 0;
        } elseif ($this->happiness > $this->maxHappiness) {
            $this->happiness = $this->maxHappiness;
        }
    }

    /* =============================
       RANK PROGRESSION
       ============================= */
    public function getRank(): int { return $this->rank; }
    public function getRankXp(): int { return $this->rankXp; }

    public function addRankXp(int $amount): void
    {
        $this->rankXp += $amount;
    }

    /* =============================
       ECONOMY
       ============================= */
    public function getMoney(): int { return $this->money; }

    public function addMoney(int $amount): void
    {
        $this->money += $amount;
        if ($this->money < 0) {
            $this->money = 0;
        }
    }

    public function getNetWorth(): int
    {
        return $this->netWorth;
    }

    public function recalculateNetWorth(): void
    {
        /*
         * Torn-style philosophy:
         * Net worth is derived, never trusted.
         * Items, faction assets, etc. can be injected later.
         */
        $this->netWorth =
            $this->money +
            (int)($this->strength + $this->speed + $this->defense + $this->dexterity);
    }

    /* =============================
       STATS
       ============================= */
    public function getStats(): array
    {
        return [
            'strength'  => $this->strength,
            'speed'     => $this->speed,
            'defense'   => $this->defense,
            'dexterity' => $this->dexterity
        ];
    }

    public function increaseStat(string $stat, float $amount): void
    {
        if (!property_exists($this, $stat)) {
            return;
        }

        /*
         * Diminishing returns baked in:
         * growth slows as stat grows
         */
        $current = $this->$stat;
        $gain = $amount / (1 + ($current / 100000));

        $this->$stat += $gain;
    }

    /* =============================
       STATUS CHECKS
       ============================= */
    public function isInJail(): bool
    {
        return $this->jailUntil !== null && strtotime($this->jailUntil) > time();
    }

    public function isHospitalized(): bool
    {
        return $this->hospitalUntil !== null && strtotime($this->hospitalUntil) > time();
    }

    /* =============================
       EXPORT FOR DB SAVE
       ============================= */
    public function toDbArray(): array
    {
        return [
            'energy'       => $this->energy,
            'nerve'        => $this->nerve,
            'happiness'    => $this->happiness,
            'rank'         => $this->rank,
            'rank_xp'      => $this->rankXp,
            'money'        => $this->money,
            'net_worth'    => $this->netWorth,
            'strength'     => $this->strength,
            'speed'        => $this->speed,
            'defense'      => $this->defense,
            'dexterity'    => $this->dexterity
        ];
    }
}
