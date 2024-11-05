function objectName(){
    return function($scope, element){
        var link = angular.element('<a>', {
            text: $scope.object.object
        });
        element.append(link);
    }
}
