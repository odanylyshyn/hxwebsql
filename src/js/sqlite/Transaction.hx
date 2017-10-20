package js.sqlite;

import js.Browser;
import js.sqlite.WebSqlExtern.WebSQLDatabase;
import js.sqlite.WebSqlExtern.WebSQLTransaction;

class Transaction extends DbResult {
    private var queries:Map<String, SqlQuery>;
    private var counter:Int = 0;
    private var sqlDB:WebSQLDatabase;
    

    public function new(db:Database) {
        super();
        sqlDB = db.getSqlDb();
        queries = new Map();
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
        if(key == null) key = "q" + counter++;
        queries[key] = q;
    }

    public function getQuery(key:String):SqlQuery {
        return queries[key];
    }

    public function exec(?trHandler:Transaction->Void):Void {
        status = DbStatus.RUNNING;
        sqlDB.transaction(transactionCallback);
    }

    private function transactionCallback(tObj:WebSQLTransaction):Void {
        for (value in queries) {
            value.exec(tObj);
        }
        // TODO: sequential call as queue instead of loop
    }

}
