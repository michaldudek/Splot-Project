<?php
require_once __DIR__ .'/../vendor/autoload.php';

use Splot\Framework\Framework;
use Application\App;

Framework::run(new App(), 'prod', true);
