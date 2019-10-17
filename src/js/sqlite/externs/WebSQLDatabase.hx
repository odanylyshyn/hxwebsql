package js.sqlite.externs;

@:native("WebSQLDatabase")
extern class WebSQLDatabase {
    public function transaction(
        txnCallback: WebSQLTransaction -> Void,
        ?errorCallback: SQLError -> Void,
        ?successCallback: Void -> Void
    ):Void;
}