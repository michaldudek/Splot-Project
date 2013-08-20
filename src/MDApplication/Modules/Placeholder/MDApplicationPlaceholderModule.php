<?php
/**
 * Module class for MDApplicationPlaceholderModule.
 * 
 * Created on 20-08-2013 23:04 GMT.
 * 
 * @package MDApplication
 */
namespace MDApplication\Modules\Placeholder;

use Splot\Framework\Modules\AbstractModule;

class MDApplicationPlaceholderModule extends AbstractModule
{

    /**
     * Prefix that will be added to all URL's from this module's controllers.
     * 
     * @var string
     */
    protected $_urlPrefix = '';

    /**
     * Boot the module.
     * 
     * You should register any event listeners or services or perform any configuration in this method.
     * 
     * It is called on application boot. Keep in mind that results of this function (whatever the method does
     * to the application scope) may be cached, so you shouldn't perform any logic actions here as this method
     * sometimes might not be called.
     */
    public function boot() {
        
    }

    /**
     * Initialize the module.
     * 
     * This method is called after application and all its modules have been fully booted (and therefore all services
     * and event listeners registered). You can perform any actions here that reuse components from other modules.
     */
    public function init() {

    }

}