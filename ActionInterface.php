<?php

interface ActionInterface
{
    public function getName(): string;

    public function getEnergyCost(): int;
    public function getNerveCost(): int;

    public function canExecute(PlayerInterface $player): bool;
    public function execute(PlayerInterface $player): ActionResultInterface;
}
