<?php
namespace Application;

use Splot\Cache\Store\FileStore;
use Splot\Framework\Application\AbstractApplication;
use Splot\Framework\DependencyInjection\ContainerCache;

class App extends AbstractApplication
{

    protected $name = 'Application';
    protected $version = '0.0.0-dev';

    public function loadModules($env, $debug)
    {
        $modules = [
            new \Splot\FrameworkExtraModule\SplotFrameworkExtraModule(),
            new \Splot\KnitModule\SplotKnitModule(),
            new \Splot\TwigModule\SplotTwigModule(),
            new \Splot\AssetsModule\SplotAssetsModule(),

            new \MDApplication\Modules\Placeholder\MDApplicationPlaceholderModule()
        ];

        if ($debug) {
            $modules = array_merge($modules, [
                new \Splot\DevToolsModule\SplotDevToolsModule(),
                new \Splot\WebLogModule\SplotWebLogModule()
            ]);
        }

        return $modules;
    }

    public function loadParameters($env, $debug)
    {
        return [
            'root_dir' => $this->getRootDir(),
            'config_dir' => '%root_dir%/config',
            'cache_dir' => '%root_dir%/.cache'
        ];
    }

    public function provideContainerCache($env, $debug)
    {
        $containerCacheDir = $this->getRootDir() .'/.cache/'. $env .'/container';
        return new ContainerCache(new FileStore($containerCacheDir));
    }

    protected function getRootDir()
    {
        return realpath(__DIR__ .'/../../');
    }
}
