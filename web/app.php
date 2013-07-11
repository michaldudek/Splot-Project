<?php
use Splot\Framework\Framework;

require_once realpath(dirname(__FILE__) .'/../vendor/autoload.php');
require_once realpath(dirname(__FILE__) .'/../app/Application.php');

Framework::web(new Application(), array());