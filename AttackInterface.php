<?php

interface AttackInterface
{
    public function getEnergyCost(): int;

    public function canAttack(
        PlayerInterface $attacker,
        PlayerInterface $defender
    ): bool;

    public function execute(
        PlayerInterface $attacker,
        PlayerInterface $defender
    ): AttackResultInterface;
}
