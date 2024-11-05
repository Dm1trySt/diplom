
(function () {
    'use strict';

    var DeterminationMaterialOfTheObjectReport = angular.module('DeterminationMaterialOfTheObjectReport', ['datatables', 'angular.filter']);

    DeterminationMaterialOfTheObjectReport.controller('DeterminationMaterialOfTheObjectReportController',
        ['$scope', '$filter', 'ngLoader', 'ngDateHelper', DeterminationMaterialOfTheObjectReportController]);

    function DeterminationMaterialOfTheObjectReportController ($scope, $filter, loader, dateHelper) {
        $scope.urls = {
            generate_data_base: '/reports/common/determination_object_material/generate_data',
            get_data_base: '/reports/common/determination_object_material/get_data',
        };
        $scope.availablePeriods = {};
        $scope.data = null;
        $scope.year = dateHelper.getCurrentYear().toString();
        $scope.month = dateHelper.getCurrentMonth().toString();
        $scope.tableOptions = {
            paging: false,
            info: false,
            searching:false
        };
        $scope.getDataTimeout = 3000;
        $scope.errorLoadingData = false;

        window.availablePeriods.forEach(function(period) {
            var params = period.identifier_params;
            $scope.availablePeriods[params.year] = $scope.availablePeriods[params.year] || {};
            $scope.availablePeriods[params.year][params.month] = params.month_name;
        });

        $scope.setDefaultMonth = function() {
            if($scope.year == dateHelper.getCurrentYear().toString())
                $scope.month = dateHelper.getCurrentMonth().toString();
            else {
                var months = $scope.availablePeriods[$scope.year];
                $scope.month = Object.keys(months)[0].toString();
            }
        };

        $scope.generateDataUrl = function() {
            return $scope.urls.generate_data_base + '?period=' + $scope.year + '-' + $scope.month;
        };

        $scope.getDataUrl = function() {
            return $scope.urls.get_data_base + '?period=' + $scope.year + '-' + $scope.month;
        };

        $scope.dataGetter = function() {
            $scope.loading = true;
            $scope.data = null;
            $scope.errorLoadingData = false;

            $scope.getData().then(function(data) {
                if ($scope.data == null && $scope.errorLoadingData == false) {
                    loader.getData($scope.generateDataUrl())
                }
            });
        };

        $scope.getData = function() {
            return loader
                .getData($scope.getDataUrl())
                .then(
                    function(data) {
                        if (data.success == undefined) {
                            $scope.data = data;
                            $scope.loading = false;
                        } else {
                            if (data.success == false) {
                                setTimeout(function(){$scope.getData()}, $scope.getDataTimeout);
                            }
                        }
                    },
                    function(error) {
                        $scope.loading = false;
                        $scope.errorLoadingData = true;
                        console.log(error);
                    }
                );
        };

        $scope.totalTimeByWorker = function(department, worker) {
            var sum = 0,
                length = department.projects.length;
            for (var i=0;i<length;i++) {
                sum = sum + department.projects[i]['user_'+worker.id]
            }
            return sum.toFixed(2);
        };

        $scope.totalTimeByDepartment = function(department) {
            var sum = 0,
                length = department.projects.length;
            for (var i=0;i<length;i++) {
                sum = sum + department.projects[i].total
            }
            return sum.toFixed(2);
        };

        $scope.showTab = function(name) {
            $('div#content .tab-content').hide();
            $('div.tabs span').removeClass('selected');
            $('#tab-content-' + name).show();
            $('#tab-' + name).addClass('selected');
            return false;
        };
    }

    DeterminationMaterialOfTheObjectReport.service('ngLoader', ngLoader);
    DeterminationMaterialOfTheObjectReport.service('ngDateHelper', ngDateHelper);

    DeterminationMaterialOfTheObjectReport.filter('groupWorkersByType', ['$filter',  function($filter) {
        return function(workers) {
            var result = [],
                data = $filter('groupBy')(workers, 'type');

            if (data['Оптимизатор'] != undefined) {
                result.push(['Оптимизатор', data['Оптимизатор']]);
            }
            if (data['Редактор'] != undefined) {
                result.push(['Редактор', data['Редактор']]);
            }

            var other = [];
            angular.forEach(data, function(value, key) {
                if (key != 'Оптимизатор' && key != 'Редактор') {
                    other.push(value);
                }
            });
            other = [].concat.apply([], other);

            if (other.length > 0) result.push(['Другие', other]);

            return result;
        }
    }]);

    DeterminationMaterialOfTheObjectReport.filter('flattenWorkers', function() {
        return function(workers) {
            var result = [];

            for (var i=0;i<workers.length;i++) {
                result.push(workers[i][1]);
            }

            result = [].concat.apply([], result);

            return result;
        }
    });
})();
