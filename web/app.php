<?php
use Splot\Framework\Framework;

$rootDir = dirname(__FILE__) .'/..';

require_once $rootDir .'/vendor/autoload.php';
require_once $rootDir .'/app/Application.php';

Framework::run(new Application());