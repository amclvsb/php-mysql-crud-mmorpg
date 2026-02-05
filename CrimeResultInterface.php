<?php

interface CrimeResultInterface
{
    public function isSuccess(): bool;

    public function getMoneyChange(): int;
    public function getStatGains(): array;
    public function getJailTime(): int;

    public function getMessage(): string;
}
