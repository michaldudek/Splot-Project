<?php
namespace Application;

use Splot\Cache\Store\FileStore;
use Splot\Framework\Application\AbstractApplication;
use Splot\Framework\DependencyInjection\ContainerCache;

/**
 * Application class.
 *
 * @author Michał Pałys-Dudek <michal@michaldudek.pl>
 */
class App extends AbstractApplication
{

    /**
     * Application name.
     *
     * @var string
     */
    protected $name = 'Application';

    /**
     * Application version.
     *
     * @var string
     */
    protected $version = '0.0.0-dev';

    /**
     * What modules should be loaded for this application?
     *
     * @param string $env Env in which the app is ran.
     * @param boolean $debug Is debug on?
     *
     * @return array
     */
    public function loadModules($env, $debug)
    {
        $modules = [
            new \Splot\FrameworkExtraModule\SplotFrameworkExtraModule(),
            new \Splot\KnitModule\SplotKnitModule(),
            new \Splot\TwigModule\SplotTwigModule(),
            new \Splot\AssetsModule\SplotAssetsModule(),
            new \Splot\DevToolsModule\SplotDevToolsModule(),

            new \MD\Placeholder\MDPlaceholderModule()
        ];

        if ($debug) {
            $modules = array_merge(
                $modules,
                [
                    new \Splot\WebLogModule\SplotWebLogModule()
                ]
            );
        }

        return $modules;
    }

    /**
     * Define some basic parameters for the app.
     *
     * @param string $env Env in which the app is ran.
     * @param boolean $debug Is debug on?
     *
     * @return array
     */
    public function loadParameters($env, $debug)
    {
        return [
            'root_dir' => $this->getRootDir(),
            'config_dir' => '%root_dir%/config',
            'cache_dir' => '%root_dir%/.cache',
            'log_dir' => '%root_dir%/logs'
        ];
    }

    /**
     * Provide a cache for the container.
     *
     * @param string $env Env in which the app is ran.
     * @param boolean $debug Is debug on?
     *
     * @return ContainerCache
     */
    public function provideContainerCache($env, $debug)
    {
        $containerCacheDir = $this->getRootDir() .'/.cache/'. $env .'/container';
        return new ContainerCache(new FileStore($containerCacheDir));
    }

    /**
     * Configure the application.
     */
    public function configure()
    {
        parent::configure();

        // copy config values to the container
        $config = $this->getConfig();
        $this->container->setParameter('log_error_file', $config->get('log_error_file'));
    }

    /**
     * Return the root dir of the application.
     *
     * @return string
     */
    public function getRootDir()
    {
        return realpath(__DIR__ .'/../../');
    }
}
