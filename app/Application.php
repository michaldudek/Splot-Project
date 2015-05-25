<?php
use Splot\Framework\Application\AbstractApplication;
use Splot\Framework\Framework;

class Application extends AbstractApplication
{

    protected $name = 'MDApplication';
    protected $version = '0.0.0-dev';

    public function loadModules($env, $debug) {
        $modules = array(
            new Splot\FrameworkExtraModule\SplotFrameworkExtraModule(),
            new Splot\KnitModule\SplotKnitModule(),
            new Splot\TwigModule\SplotTwigModule(),
            new Splot\AssetsModule\SplotAssetsModule(),

            new MDApplication\Modules\Placeholder\MDApplicationPlaceholderModule()
        );

        if ($debug) {
            $modules = array_merge($modules, array(
                new Splot\DevToolsModule\SplotDevToolsModule(),
                new Splot\WebLogModule\SplotWebLogModule()
            ));
        }

        return $modules;
    }

    public function loadParameters($env, $debug) {
        return array(
            'config_dir' => '%root_dir%/config',
            'log_error_file' => '%root_dir%/log/error.log'
        );
    }

}
