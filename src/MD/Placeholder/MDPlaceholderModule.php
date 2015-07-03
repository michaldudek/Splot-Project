<?php
namespace MD\Placeholder;

use Splot\Framework\Modules\AbstractModule;

class MDPlaceholderModule extends AbstractModule
{

    /**
     * Prefix that will be added to all URL's from this module.
     * 
     * @var string|null
     */
    protected $urlPrefix;

    /**
     * If the module depends on other modules then return those dependencies from this method.
     *
     * It works exactly the same as application's ::loadModules().
     * 
     * @return array
     */
    public function loadModules($env, $debug) {
        return array();
    }

    /**
     * This method is called on the module during configuration phase so you can register any services,
     * listeners etc here.
     *
     * It should not contain any logic, just wiring things together.
     *
     * If the module contains any routes they should be registered here.
     */
    public function configure() {
        parent::configure();
    }

    /**
     * This method is called on the module during the run phase. If you need you can include any logic
     * here.
     */
    public function run() {
        parent::run();
    }

}