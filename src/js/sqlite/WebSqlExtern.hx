package js.sqlite;

@:native("WebSQLDatabase")
extern class WebSQLDatabase {
    public function transaction(
        txnCallback: WebSQLTransaction -> Void,
        ?errorCallback: String -> Void,
        ?successCallback: Void -> Void
    ):Void;
}

@:native("WebSQLTransaction")
extern class WebSQLTransaction {
    public function executeSql(
        sql:String,
        args:Array<String>,
        ?sqlCallback: WebSQLTransaction -> SQLiteResult -> Void,
        ?sqlErrorCallback: WebSQLTransaction -> String -> Void
    ):Void;
}

@:native("SQLiteResult")
extern class SQLiteResult {
    public var rows:WebSQLRows;
}

@:native("WebSQLRows")
extern class WebSQLRows {
    public var length:Int;
    public function item(i:Int):Dynamic;
}