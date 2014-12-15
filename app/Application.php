<?php
use Splot\Framework\Application\AbstractApplication;
use Splot\Framework\Framework;

class Application extends AbstractApplication
{

    protected $name = 'MDApplication';
    protected $version = '0.0.0-dev';

    public function loadModules() {
        $modules = array(
            new Splot\FrameworkExtraModule\SplotFrameworkExtraModule(),
            new Splot\KnitModule\SplotKnitModule(),
            new Splot\TwigModule\SplotTwigModule(),
            new Splot\AssetsModule\SplotAssetsModule(),

            new MDApplication\Modules\Placeholder\MDApplicationPlaceholderModule()
        );

        if ($this->container->getParameter('debug') || $this->container->getParameter('mode') === Framework::MODE_CONSOLE) {
            $modules = array_merge($modules, array(
                new Splot\DevToolsModule\SplotDevToolsModule(),
                new Splot\WebLogModule\SplotWebLogModule()
            ));
        }

        return $modules;
    }

}