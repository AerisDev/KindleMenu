   ];
  
    $scope.addTodo = function() {
    if($scope.todoText==""||$scope.todoText==undefined) return 1;
    $scope.todos.unshift({text:$scope.todoText, done:false});
    $scope.todoText = '';

    };
 

    $scope.saveText = function(){
	var text=angular.toJson($scope.todos).replace(new RegExp( "\\n", "g" ),"\001");;
	var text1=text.replace(/'/g,"\002");
	var text2=text1.replace(/"/g,"\003");
	var text3=text2.replace(/\$/g,"\004");
	var MESSAGE='; sh -c \'DISPLAY=:0 echo "'+text3+'" > /mnt/us/extensions/kindlereminder/bin/reminder/reminder.txt; /mnt/us/extensions/kindlereminder/bin/sh/parse_reminder.sh & \'';
nativeBridge.setLipcProperty( "com.lab126.system", "sendEvent", MESSAGE);
    }
    
    $scope.remaining = function() {
    var count = 0;
    angular.forEach($scope.todos, function(todo) {
    count += todo.done ? 0 : 1;
    });
    return count;
    };
     
    $scope.archive = function() {
    var oldTodos = $scope.todos;
    $scope.todos = [];
    angular.forEach(oldTodos, function(todo) {
    if (!todo.done) $scope.todos.push(todo);
    });
    };
}
