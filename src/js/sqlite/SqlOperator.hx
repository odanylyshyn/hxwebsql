package js.sqlite;

@:enum
abstract SqlOperator(String) {
    var INSERT = "insert";
    var UPDATE = "update";
    var DELETE = "delete";
    var SELECT = "select";
}