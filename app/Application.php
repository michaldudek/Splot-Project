<?php
use MD\Foundation\Debug\Debugger;
use Splot\Framework\Application\AbstractApplication;
use Splot\Framework\Framework;
use Splot\Framework\Config;

class Application extends AbstractApplication
{

    protected $name = 'MDApplication';
    protected $version = '0.0.0-dev';

    public function boot(array $option = array()) {

    }

    public function loadModules() {
        $modules = array(
            new Splot\KnitModule\SplotKnitModule(),
            new Splot\TwigModule\SplotTwigModule(),
            new Splot\AssetsModule\SplotAssetsModule(),

            
        );

        if ($this->getEnv() === Framework::ENV_DEV || Debugger::isCli()) {
            $modules = array_merge($modules, array(
                new Splot\DevToolsModule\SplotDevToolsModule(),
                new Splot\WebLogModule\SplotWebLogModule()
            ));
        }

        return $modules;
    }

}