package js.sqlite;

import js.Browser;
import js.sqlite.WebSqlExtern.WebSQLDatabase;
import js.sqlite.WebSqlExtern.WebSQLTransaction;

class Transaction extends DbResult {
    public var queries(default, null):Array<SqlQuery>;
    private var queryKeys:Map<String, Int>;
    private var sqlDB:WebSQLDatabase;
    private var currentIndex:Int;
    private var transObj:WebSQLTransaction;

    public function new(db:Database) {
        super();
        sqlDB = db.getSqlDb();
        queries = new Array();
        queryKeys = new Map();
    }

    public function addQuery(q:SqlQuery, ?key:String):Void {
        if(status == DbStatus.RUNNING) {
            Browser.console.error("Cannot add a request to a running transaction");
            return;
        }
        if(status == DbStatus.CLOSE) {
            Browser.console.error("Cannot add a request to a closed transaction");
            return;
        }
        queries.push(q);
        if(key != null) {
            queryKeys[key] = queries.length - 1;
        }
    }

    public function getQuery(key:String):SqlQuery {
        if(!queryKeys.exists(key)) return null;
        return queries[queryKeys[key]];
    }

    public function exec():Void {
        if(queries.length == 0) {
            Browser.console.error("Cannot run a transaction without queries");
            return;
        }
        status = DbStatus.RUNNING;
        sqlDB.transaction(transactionCallback, trErrorHandler, trSuccessHandler);
    }

    private function transactionCallback(tObj:WebSQLTransaction):Void {
        transObj = tObj;
        currentIndex = 0;
        execCurrentQuery();
    }

    private function execCurrentQuery():Void {
        trace('exec query $currentIndex');
        queries[currentIndex].handler = nextQuery;
        queries[currentIndex].exec(transObj);
    }

    private function nextQuery(q:DbResult):Void {
        queries[currentIndex].handler = null;
        currentIndex++;
        if(currentIndex < queries.length) execCurrentQuery();
    }

    private function trErrorHandler(msg:String):Void {
        super.errorHandler(msg);
    }

    private function trSuccessHandler():Void {
        super.successHandler();
        trace('Transaction success!');
    }

}
