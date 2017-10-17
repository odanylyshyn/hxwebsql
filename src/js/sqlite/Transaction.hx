package js.sqlite;

import js.sqlite.WebSqlExtern.WebSQLDatabase;
import js.sqlite.WebSqlExtern.WebSQLTransaction;

class Transaction extends DbQueryResult {
	private var queries:Map<String, SqlQuery>;
	private var counter:Int = 0;
	private var sqlDB:WebSQLDatabase;

	public function new(db:Database) {
		super();
		sqlDB = db.sqlDB;
		queries = new Map();
	}

	public function addQuery(q:SqlQuery, ?key:String):Void {
		if(key == null) key = 'q' + counter++;
	    queries[key] = q;
	}

	public function getQuery(key:String):SqlQuery {
	    return queries[key];
	}

	public function exec(?trHandler:Transaction->Void):Void {
	    sqlDB.transaction(transactionCallback);
	}

	private function transactionCallback(tObj:WebSQLTransaction):Void {
	    for (value in queries) {
	    	tObj.executeSql(value.sqlExpr, []);
	    }
	}

}
