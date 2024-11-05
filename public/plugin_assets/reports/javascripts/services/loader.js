function ngLoader ($http, $q) {
    var getData = function(url, params, method, headers) {
        var d = $q.defer(),
            token = angular.element('[name="csrf-token"]').attr('content');
        method = method || 'GET';
        headers = headers || {};
        params = params || {};
        headers['X-CSRF-Token'] = token;
        var options = {
            method: method,
            url: url,
            headers: headers
        };
        if (method == 'GET') {
            options['params'] = params;
        }else {
            options['data'] = params;
        }
        if (angular.version.full < "1.6.5") {
            $http(options)
                .success(function(data, status, headers) {
                    d.resolve(data);
                })
                .error(function(data, status, headers) {
                    d.reject(data);
                });
        }else {
            $http(options)
                .then(function(response) {
                    d.resolve(response.data);
                }, function(error) {
                    d.reject(error);
                });
        }

        return d.promise;
    };

    return {
        getData: getData
    }
}
