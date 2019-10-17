package js.sqlite.externs;

@:native("WebSQLTransaction")
extern class WebSQLTransaction {
    public function executeSql(
        sql:String,
        args:Array<String>,
        ?sqlCallback: WebSQLTransaction -> SQLiteResult -> Void,
        ?sqlErrorCallback: WebSQLTransaction -> SQLError -> Void
    ):Void;
}