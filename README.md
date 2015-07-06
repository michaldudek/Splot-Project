MD Splot Project
================

A customised template for creating PHP projects that use [Splot Framework](https://github.com/splot/Framework).
Includes frontend assets management, convenient [Vagrant](https://www.vagrantup.com/) configuration, streamlined common 
QA tasks, separation of concerns in terms of backend work (PHP) and frontend work (JavaScript and CSS are managed with 
tools designed for it) and built in deployment tools.

A rich and opinionated alternative to [Splot Default Project](https://github.com/splot/default-project).

    $ composer create-project michaldudek/splot-project ./project -s dev
    $ cd ./project

    # edit Vagrantfile, line 1

    $ vagrant up
    $ curl http://www.changeme.dev

    # develop

    $ make assets
    $ make qa

    $ cap prod deploy

    # ???
    # profit

# Concepts

* Backend (PHP)
    * Whole backend application code resides in `src/`
    * All backend tests reside in `tests/`
    * The application configuration is stored in `config/`
    * The Splot Console is available as `$ php console`
* Frontend (JavaScript and CSS)
    * All application CSS and JavaScript code resides in `web/`
    * LESS is used as a CSS pre-processor
    * Bower is used to manage vendor dependencies and Bower directory is `web/components/`
    * Assets management (building, compilation, minification, linting, etc) is done with Gulp
* Deployment
    * Deployment of the application is done with Capistrano
* Management, QA and building
    * Common tasks are streamlined into the `Makefile` and `$ make` command

# Using

When creating a new PHP project just run:

    $ composer create-project michaldudek/splot-project ./project -s dev

where `./project` is the name / path to your project.

You should then `$ cd ./project` and edit a few files for configuration.

## Vagrant

After installation edit the `Vagrantfile`. Change your application name in the first line:

    APP_NAME = "changeme"

This name will be used as your dev domain, ie `www.APP_NAME.dev` (where `www.` is optional).

To start your dev server run:

    $ vagrant up

This will spin an Ubuntu 14.04 VM with PHP 5.6 (opcache disabled), Apache2, Memcached, MongoDB, MySQL, node.js, Redis
and Xdebug installed. Feel free to edit the `Vagrantfile` to tweak it to your needs.

Your app should now be reachable under the above domain.

## Backend (PHP) development

See [Splot Framework](https://github.com/splot/Framework) for information on how to develop PHP applications with it.

Explore contents of `config/config.*.yml` and `config/parameters.yml.dist` (drop the `.dist` extension) for application
configuration.

All your application PHP code should go to `src/` which is autoloaded with PSR-0 standard. All your tests should go to
to `tests/` and be prefixed with `Tests\` namespace.

You should often run QA tools on your code (preferably before every commit / push) using the following commands:

    $ make test // runs PHPUnit tests
    $ make phpcs // runs PHPCS on the contents of src/
    $ make phpmd // runs PHPMD on the contents of src/

(run `$ make help` to see more options).

## Frontend (JavaScript and CSS) development

This template comes with some common libraries installed from [Bower](http://bower.io/) (including
[jQuery](https://jquery.com/), [Bootstrap 3](http://getbootstrap.com/), [AngularJS](https://angularjs.org/),
[Font Awesome](http://fortawesome.github.io/Font-Awesome/) and [lodash](https://lodash.com/)). 

### CSS

[LESS](http://lesscss.org/) is used as a CSS pre-processor and all its code resides in `web/less/` directory. There is 
a single file `app.less` which gets compiled and it should import all other components. All variables and mixins should 
go to `_varmix.less` file.

To compile the CSS run:

    $ make css

### JavaScript

All application JavaScript code resides in `web/js` directory. This project template has a basic skeleton for an
AngularJS app, but this is not enforced or necessary. Just edit or remove the `app.js` file and start from scratch.

To compile the JavaScript run:

    $ make js

This will concatenate and minify all `*.js` files found in the directory and its subdirectories.

You should often run QA tools on your JavaScript (which at the moment of this writing is only JSHinting) with:

    $ make js:hint

All 3rd party libraries are compiled to a separate file `libs.js`. To configure what should go into that file (e.g.
turn off the libraries you don't need and add any new) edit the `gulpfile.js` file and you will see a list of the
included files in the `js-libs` task.

### Building

Building the CSS or JavaScript code with the above commands will concatenate, minify and generate sourcemaps of all the
code and put the results in `web/assets` directory. Code from this directory should be referenced in your application.

The created target files are revisioned with a checksum appended to their name (in order to boost browser caching
without issues) so after every compilation they will have a different name. Check the
[base.html.twig](src/Application/Resources/views/base.html.twig) template to see how this issue with solved - using
the [Splot Assets Module](https://github.com/splot/AssetsModule) we're adding wildcarded files to the HTML. By default,
they are configured to be not minified or concatenated by Splot, so it should have a minimal impact on the performance.

Run `$ make assets` to build all assets.

Building is done using Gulp and while developing you should run

    $ gulp watch

in order to watch the CSS and JavaScript files for changes and immediate compilation.

# Makefile

This project template comes with a `Makefile` which contains streamlined common development tasks. Please do check it
and run `$ make help` to see list of available commands. Of biggest interest should be:

    $ make qa

which runs tests ([PHPUnit](https://phpunit.de/)), linters ([PHPCS](https://github.com/squizlabs/PHP_CodeSniffer) and 
[JSHint](http://jshint.com/)), mess detector ([PHPMD](http://phpmd.org/)), etc. on the source code in one go.

# Deployment

[Capistrano](http://capistranorb.com/) is used for deployments. Before running a deployment you should edit the files 
in `config/deploy/` to reference your Git repository and configure deployment targets.

After it has been configured you will be able to deploy to your envs using

    $ cap prod deploy
    $ cap dev deploy
    $ cap [env] deploy

or

    $ make deploy

to deploy to the `prod` environment.
