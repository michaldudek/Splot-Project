/*global _, Math*/
(function(_, Math, undefined) {
    'use strict';

    _.clear = function(arr) {
        if (arr === undefined) {
            return false;
        }
        arr.splice(0, arr.length);
    };

    _.push = function(arr, push) {
        if (arr === undefined) {
            return false;
        }
        
        _.forEach(push, function(item) {
            arr.push(item);
        });
    };

    _.replace = function(arr, newArr) {
        _.clear(arr);
        _.push(arr, newArr);
    };

    _.joinFrom = function(collection, key, value) {
        if (!_.isArray(value)) {
            value = [value];
        }

        var result = [],
            query = {};
            
        _.forEach(value, function(v) {
            query[key] = v;
            var item = _.find(collection, query);
            if (item) {
                result.push(item);
            }
        });

        return result;
    };

    _.fillKeys = function(keys, value) {
        var obj = {};
        _.forEach(keys, function(key) {
            obj[key] = value;
        });
        return obj;
    };

    _.makeArray = function(collection) {
        var arr = [];
        _.forEach(collection, function(item) {
            arr.push(item);
        });
        return arr;
    };

    _.timestamp = function() {
        return Math.floor(_.now() / 1000);
    };

})(_, Math);