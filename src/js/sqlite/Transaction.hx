package js.sqlite;

import js.sqlite.WebSqlExtern.WebSQLDatabase;
import js.sqlite.WebSqlExtern.WebSQLTransaction;
import js.sqlite.WebSqlExtern.SQLError;

class Transaction {
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
            throw("Cannot add a request to a running transaction");
            return;
        }
        if(status == DbStatus.CLOSE) {
            throw("Cannot add a request to a closed transaction");
            return;
        }
        queries.push(q);
        if(key != null) {
            queryKeys[key] = queries.length - 1;
        }
        if(q.isReturnId) {
            var q2 = new SqlQuery('SELECT last_insert_rowid() as rowid');
            queries.push(q2);
            if(key != null) {
                queryKeys[key + '_rowid'] = queries.length - 1;
            }
        }
    }

    public function getQuery(key:String):SqlQuery {
        if(!queryKeys.exists(key)) return null;
        return queries[queryKeys[key]];
    }

    public function exec():Void {
        if(queries.length == 0) {
            throw("Cannot run a transaction without queries");
            return;
        }
        sqlDB.transaction(transactionCallback, trErrorHandler, trSuccessHandler);
    }

    private function transactionCallback(tObj:WebSQLTransaction):Void {
        for (i in 0...queries.length) {
            queries[i].exec(tObj);
        }

        /*transObj = tObj;
        currentIndex = 0;
        execCurrentQuery();*/
    }

    /*private function execCurrentQuery():Void {
        queries[currentIndex].handler = nextQuery;
        queries[currentIndex].exec(transObj);
    }

    private function nextQuery(q:DbResult):Void {
        queries[currentIndex].handler = null;
        currentIndex++;
        if(currentIndex < queries.length) execCurrentQuery();
    }*/

    private function trErrorHandler(error:SQLError):Void {
        super.errorHandler(error);
    }

    private function trSuccessHandler():Void {
        super.successHandler();
    }

}
