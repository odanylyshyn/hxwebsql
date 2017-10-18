package js.sqlite;

class DbQueryResult {
    public static var NO_ERROR:Int = 0;
    public static var NO_DB:Int = 1;
    public static var TRANSACTION_ERROR:Int = 2;
    public static var SQL_ERROR:Int = 3;

    public var isSuccess(default, null):Bool;
    public var errorCode(default, null):Int;
    public var errorMessage(default, null):String;
    public var handler:DbQueryResult->Void;

    public function new():Void {
        isSuccess = true;
        errorCode = NO_ERROR;
        errorMessage = '';
    }
}