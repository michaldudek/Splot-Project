<?php
namespace Tests\Application;

use Application\App;

/**
 * AppTest
 *
 * @author Michał Pałys-Dudek <michal@michaldudek.pl>
 *
 * @coversDefaultClass \Application\App
 */
class AppTest extends \PHPUnit_Framework_TestCase
{

    /**
     * Test modules loaded.
     *
     * @covers ::loadModules
     */
    public function testLoadModules()
    {
        $app = new App();
        $modules = $app->loadModules('test', true);

        $this->assertInternalType('array', $modules);

        foreach ($modules as $module) {
            $this->assertInstanceOf('Splot\Framework\Modules\AbstractModule', $module);
        }
    }

    /**
     * Test loaded parameters.
     *
     * @covers ::loadParameters
     */
    public function testLoadParameters()
    {
        $app = new App();
        $parameters = $app->loadParameters('test', true);

        $this->assertInternalType('array', $parameters);
        foreach (['root_dir', 'config_dir', 'cache_dir', 'log_dir'] as $param) {
            $this->assertArrayHasKey($param, $parameters);
            $this->assertNotEmpty($parameters[$param]);
        }
    }

    /**
     * Test provided container cache.
     *
     * @covers ::provideContainerCache
     */
    public function testProvideContainerCache()
    {
        $app = new App();
        $containerCache = $app->provideContainerCache('test', true);

        $this->assertInstanceOf('Splot\DependencyInjection\ContainerCacheInterface', $containerCache);
    }

    /**
     * Test configuration.
     *
     * @covers ::configure
     */
    public function testConfigure()
    {
        $config = $this->getMock('Splot\Framework\Config\Config');
        $container = $this->getMock('Splot\DependencyInjection\ContainerInterface');
        $container->expects($this->atLeastOnce())
            ->method('get')
            ->with($this->equalTo('config'))
            ->will($this->returnValue($config));

        $container->expects($this->any())
            ->method('setParameter');

        $app = new App();
        $app->setContainer($container);

        $app->configure();
    }

    /**
     * Test getting the root dir.
     *
     * @covers ::getRootDir
     */
    public function testGetRootDir()
    {
        $app = new App();
        
        $rootDir = realpath(__DIR__ .'/../../');
        $this->assertEquals($rootDir, $app->getRootDir());
    }
}
