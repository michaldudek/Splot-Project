<?php
namespace MD\Placeholder\Controllers;

use Splot\Framework\Controller\AbstractController;

/**
 * Default landing page controller.
 *
 * @author Michał Pałys-Dudek <michal@michaldudek.pl>
 */
class Index extends AbstractController
{

    /**
     * URL for which this controller will respond.
     *
     * If a $_urlPrefix has been set in the controller's module then this URL will be appended to it.
     *
     * @var string
     */
    protected static $_url = '/';

    /**
     * The controller's methods which should respond to specific HTTP requests.
     *
     * You can direct GET and POST requests to different methods if you want.
     *
     * If you don't want the controller to respond to a specific HTTP method then set it to (bool) false.
     *
     * @var array
     */
    protected static $_methods = array(
        'get' => 'index',
        'post' => false,
        'put' => false,
        'delete' => false
    );

    /**
     * Default method that will respond to HTTP requests.
     *
     * Can return either of these:
     *     - \Splot\Framework\HTTP\Response object
     *     - a string (that will be converted to Response object by the framework)
     *     - an array (if there is SplotTwigModule registered and the controller has an associated template)
     *
     * @return array
     */
    public function index()
    {
        return array(
            'name' => 'Index'
        );
    }
}
