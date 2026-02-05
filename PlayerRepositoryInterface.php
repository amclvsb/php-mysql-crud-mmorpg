<?php

interface PlayerRepositoryInterface
{
    public function load(int $playerId): PlayerInterface;
    public function save(PlayerInterface $player): void;
}
