<?php

return array(

    'log_file' => '%log_dir%focusson.log',
    'log_error_file' => '%log_dir%error.log',
    'log_threshold' => 'info',

    'timezone' => 'Europe/Warsaw',

    'debugger' => array(
        'enabled' => false
    ),

    'router' => array(
        'host' => null
    ),

    'cache' => array(
        'enabled' => true,
        'stores' => array(),
        'caches' => array()
    ),

    'SplotKnitModule' => array(
        'stores' => array(
            'default' => array(
                'class' => 'Knit\\Store\\MongoDBStore',
                'database' => 'database-changeme'
            )
        )
    ),
    
);