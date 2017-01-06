<?php

class Test
{
    public $ref;

    public function __construct()
    {
        $this->ref = new self();
    }
}

$test = new Test();
