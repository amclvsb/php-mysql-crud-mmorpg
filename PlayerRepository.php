<?php

class PlayerRepository implements PlayerRepositoryInterface
{
    private mysqli $db;

    public function __construct(mysqli $db)
    {
        $this->db = $db;
    }

    /* =========================================================
       LOAD PLAYER BY player_rounds.id
       ========================================================= */
    public function load(int $playerRoundId): PlayerInterface
    {
        $sql = "
            SELECT *
            FROM player_rounds
            WHERE id = ?
            LIMIT 1
        ";

        $stmt = mysqli_prepare($this->db, $sql);
        mysqli_stmt_bind_param($stmt, 'i', $playerRoundId);
        mysqli_stmt_execute($stmt);

        $result = mysqli_stmt_get_result($stmt);
        $row = mysqli_fetch_assoc($result);

        mysqli_stmt_close($stmt);

        if (!$row) {
            throw new RuntimeException('Player not found');
        }

        return new Player($row);
    }

    /* =========================================================
       LOAD PLAYER BY USER + ROUND
       ========================================================= */
    public function loadByUserAndRound(int $userId, int $roundId): PlayerInterface
    {
        $sql = "
            SELECT *
            FROM player_rounds
            WHERE user_id = ?
              AND round_id = ?
            LIMIT 1
        ";

        $stmt = mysqli_prepare($this->db, $sql);
        mysqli_stmt_bind_param($stmt, 'ii', $userId, $roundId);
        mysqli_stmt_execute($stmt);

        $result = mysqli_stmt_get_result($stmt);
        $row = mysqli_fetch_assoc($result);

        mysqli_stmt_close($stmt);

        if (!$row) {
            throw new RuntimeException('Player not found for round');
        }

        return new Player($row);
    }

    /* =========================================================
       SAVE PLAYER STATE (WHITELISTED)
       ========================================================= */
    public function save(PlayerInterface $player): void
    {
        /*
         * Net worth is recalculated server-side
         * before persisting.
         */
        $player->recalculateNetWorth();
        $data = $player->toDbArray();

        $sql = "
            UPDATE player_rounds
            SET
                energy      = ?,
                nerve       = ?,
                happiness   = ?,
                rank        = ?,
                rank_xp     = ?,
                money       = ?,
                net_worth   = ?,
                strength    = ?,
                speed       = ?,
                defense     = ?,
                dexterity   = ?,
                last_active = NOW()
            WHERE id = ?
            LIMIT 1
        ";

        $stmt = mysqli_prepare($this->db, $sql);

        mysqli_stmt_bind_param(
            $stmt,
            'iiiiiiiddddi',
            $data['energy'],
            $data['nerve'],
            $data['happiness'],
            $data['rank'],
            $data['rank_xp'],
            $data['money'],
            $data['net_worth'],
            $data['strength'],
            $data['speed'],
            $data['defense'],
            $data['dexterity'],
            $player->getId()
        );

        mysqli_stmt_execute($stmt);
        mysqli_stmt_close($stmt);
    }

    /* =========================================================
       CREATE PLAYER ENTRY FOR ROUND JOIN
       ========================================================= */
    public function createForRound(int $userId, int $roundId, string $username): PlayerInterface
    {
        $sql = "
            INSERT INTO player_rounds
            (user_id, round_id, username)
            VALUES (?, ?, ?)
        ";

        $stmt = mysqli_prepare($this->db, $sql);
        mysqli_stmt_bind_param($stmt, 'iis', $userId, $roundId, $username);
        mysqli_stmt_execute($stmt);

        $playerRoundId = mysqli_insert_id($this->db);

        mysqli_stmt_close($stmt);

        return $this->load($playerRoundId);
    }
}
