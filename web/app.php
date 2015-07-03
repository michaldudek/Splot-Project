<?php
require_once __DIR__ .'/../vendor/autoload.php';

use Splot\Framework\Framework;
use Application\App;

// detect env based on .tld
$tld = end(explode('.', $_SERVER['SERVER_NAME']));
$env = $tld === 'dev' ? 'dev' : 'prod';
$debug = $env === 'dev' ? true : false;

Framework::run(new App(), $env, $debug);
