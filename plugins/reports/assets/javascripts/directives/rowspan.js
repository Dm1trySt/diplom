function rowspanDirective() {
    return function($scope, element, attrs){
        $scope.$watch(attrs.ngRowspan,function(value){
            if(value > 1)
                element.attr('rowspan', value);
        });
    }
}