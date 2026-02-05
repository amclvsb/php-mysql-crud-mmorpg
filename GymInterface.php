<?php

interface GymInterface
{
    public function getName(): string;
    public function getEnergyCost(): int;

    public function train(
        PlayerInterface $player,
        string $stat
    ): GymResultInterface;
}
