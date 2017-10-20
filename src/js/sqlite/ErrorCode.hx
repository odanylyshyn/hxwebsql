package js.sqlite;

@:enum
abstract ErrorCode(Int) {
    var NO_ERROR = 0;
    var NO_DB = 1;
    var TRANSACTION_ERROR = 2;
    var SQL_ERROR = 3;
    var USING_ERROR = 4;
}