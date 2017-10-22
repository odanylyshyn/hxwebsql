package js.sqlite;

import js.Browser;
import js.sqlite.WebSqlExtern.WebSQLDatabase;
import js.sqlite.WebSqlExtern.WebSQLTransaction;

class Transaction extends DbResult {
    private var queries:Array<SqlQuery>;
    private var queryKeys:Map<String, Int>;
    private var sqlDB:WebSQLDatabase;
    private var currentQuery:SqlQuery;
    

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

    public function exec(?trHandler:Transaction->Void):Void {
        if(queries.length == 0) {
            Browser.console.error("Cannot run a transaction without queries");
            return;
        }
        status = DbStatus.RUNNING;
        sqlDB.transaction(transactionCallback);
    }

    private function transactionCallback(tObj:WebSQLTransaction):Void {
        // currentQuery = 
        for (i in 0...queries.length) {
            queries[i].exec(tObj);
        }
        // TODO: sequential call as queue instead of loop
    }

}
