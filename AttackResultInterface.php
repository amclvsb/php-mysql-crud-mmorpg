<?php

interface AttackResultInterface
{
    public function getWinner(): PlayerInterface;
    public function getLoser(): PlayerInterface;

    public function getStatGains(): array;
    public function getMoneyStolen(): int;

    public function getRespectChange(): int;
    public function getLog(): array;
}
