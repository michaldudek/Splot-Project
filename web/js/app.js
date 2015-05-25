(function(ng, window, document, undefined) {
    'use strict';

    ng.module('App', [
        'ngAnimate',
        'ui.router',
        'pasvaz.bindonce'
    ])
        .config(['$logProvider', '$httpProvider', '$locationProvider',
            function($logProvider, $httpProvider, $locationProvider) {
                // enable debug
                $logProvider.debugEnabled(true);

                // bring back X-Requested-With header as it was removed from $http service
                $httpProvider.defaults.headers.common['X-Requested-With'] = 'XMLHttpRequest';

                $locationProvider.html5Mode(true);
            }
        ]);

})(window.angular, window, document);