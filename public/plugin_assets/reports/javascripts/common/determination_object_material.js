/**
 * @name availablePeriods {array} - список с досупными периодами
 */

(function () {
    'use strict';

    var DeterminationObjectMaterialReport = angular.module('DeterminationObjectMaterialReport', []);

    DeterminationObjectMaterialReport.controller('DeterminationObjectMaterialReportController',
        ['ngLoader', 'ngDateHelper', DeterminationObjectMaterialReportController]);

    function DeterminationObjectMaterialReportController (loader, dateHelper){
        angular.extend(this, {
            urls: {
                get_data_base     : '/reports/common/determination_object_material/get_data',
            },

            availablePeriods : {},

            data             : null,
            year             : dateHelper.getCurrentYear().toString(),
            month            : dateHelper.getCurrentMonth().toString(),


            init: function(){
                var controller = this;

                availablePeriods.forEach(function(period){
                    var params = period.identifier_params;

                    controller.availablePeriods[params.year] = controller.availablePeriods[params.year] || {};
                    controller.availablePeriods[params.year][params.month] = params.month_name;
                });
            },

            setDefaultMonth: function(){
                var controller = this;

                if(controller.year == dateHelper.getCurrentYear().toString())
                    controller.month = dateHelper.getCurrentMonth().toString();
                else {
                    var months = controller.availablePeriods[controller.year];
                    controller.month = Object.keys(months)[0].toString();
                }
            },

            getXlsData: function(){
                document.location.href = this.prepareUrl(this.urls.get_data_base + '.xlsx');
            },

            getDataUrl: function(){
                return this.urls.get_data_base + '?period=' + this.year + '-' + this.month;
            },

            prepareUrl: function(url){
                return url + '?period=' + this.year + '-' + this.month;
            },


            getAttrName: function(attr){
                switch(attr){
                    case 'min_bound':
                        return 'Мин. планка';
                    case 'max_bound':
                        return 'Макс. планка';
                    default :
                        return '';
                }
            },

            getWorkerGroup: function(worker){
                var result = null;
                angular.forEach(this.data, function(group){
                    if(worker.group_id == group.id){
                        result = group;
                        return false;
                    }
                });

                return result;
            },

            getData: function(){
                var controller = this;

                controller.loading = true;
                controller.data = null;

                loader
                    .getData( controller.getDataUrl() )
                    .then(
                        function(data) {
                            controller.data = data;
                            controller.loading = false;
                        },
                        function(error) {
                            controller.loading = false;
                            console.log(error);
                        }
                    );
            },

            initWorker: function(worker){
                worker.totals = {
                    current  : this.calculateExtraPoints(worker.closed),
                    estimated: this.calculateExtraPoints(worker.estimated),
                    started: this.calculateExtraPoints(worker.started)
                };

                worker.premium = 0;
            },

            allGroupsShowPremium: function(){
                if(this.data.length == 0) return false;

                var show = true;
                this.data.forEach(function(group){
                    if(!group.show_premium) show = false;
                });

                return show;
            },

            orderWorkers: function(worker){
                return worker.is_manager ? 0 : worker.name;
            },

            calculateExtraPoints: function(issues){
                var sum = 0;
                angular.forEach(issues, function(issue){
                    if(issue.scores) sum += parseInt(issue.scores);
                });

                return sum;
            },

            calculateGroupPremium: function(group, rewrite){
                var controller = this;
                var premium = 0;

                angular.forEach(group.workers, function(worker){
                    if(rewrite){
                        worker.premium = controller.calculateWorkerPremium(worker);
                    }

                    premium += worker.premium;
                });

                return premium;
            },

            calculateCommonPremium: function(rewrite){
                var controller = this;
                var premium = 0;

                angular.forEach(this.data, function(group){
                    premium += controller.calculateGroupPremium(group, rewrite);
                });

                return premium;
            },

            calculateWorkerPremium: function(worker){
                return worker.totals.current * 11.0;
            }
        });
    }

    DeterminationObjectMaterialReport.service('ngLoader', ngLoader);
    DeterminationObjectMaterialReport.service('ngDateHelper', ngDateHelper);
    DeterminationObjectMaterialReport.directive('objectName', objectName);
})();
