<?php

interface PlayerInterface
{
    public function getId(): int;
    public function getUsername(): string;

    /* Resources */
    public function getEnergy(): int;
    public function getMaxEnergy(): int;
    public function consumeEnergy(int $amount): bool;

    public function getNerve(): int;
    public function getMaxNerve(): int;
    public function consumeNerve(int $amount): bool;

    public function getHappiness(): int;
    public function getMaxHappiness(): int;
    public function changeHappiness(int $amount): void;

    /* Progression */
    public function getRank(): int;
    public function getRankXp(): int;
    public function addRankXp(int $amount): void;

    /* Economy */
    public function getMoney(): int;
    public function addMoney(int $amount): void;

    public function getStats(): array; // strength, speed, defense, dexterity
    public function increaseStat(string $stat, float $amount): void;

    public function getNetWorth(): int;
    public function recalculateNetWorth(): void;
}
