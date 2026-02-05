<?php

interface CrimeInterface
{
    public function getName(): string;
    public function getNerveCost(): int;

    public function getSuccessChance(PlayerInterface $player): float;
    public function commit(PlayerInterface $player): CrimeResultInterface;
}
