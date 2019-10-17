package js.sqlite;

import Std.is;
import js.Browser;
import js.sqlite.externs.*;

class Database {
    public var dbTypeName(default, null):String;
    private var sqlDB:WebSQLDatabase;
    private var queries:Array<SqlQuery>;
    private var currentQuery:SqlQuery;

    public function new(dbName:String):Void {
        var isPlugin = Reflect.hasField(Browser.window, "sqlitePlugin");
        var isWebSQL = Reflect.hasField(Browser.window, "openDatabase");
        if(isPlugin) {
            sqlDB = untyped __js__("window.sqlitePlugin.openDatabase({0})", dbName + ".db");
            dbTypeName = "Cordova SQLite plugin";
        } else if(isWebSQL) {
            sqlDB = untyped __js__('window.openDatabase({0}, "", {0}, 256*1024)', dbName);
            dbTypeName = "Webkit WebSQL";
        } else {
            Browser.console.error("SQLite is not supported by your browser");
        }
        queries = new Array();
    }

    public function exec(queryData:Any):Void {
        var query:SqlQuery;
        if(is(queryData, String)) query = new SqlQuery(queryData);
        else if(is(queryData, SqlQuery)) query = queryData;
        else {
            Browser.console.error("Database.exec: incorrect argument type. SqlQuery or String expected.");
            return;
        }
        query.prepareToExecuting();
        if(query.isSuccess) {
            queries.push(query);
            pushQueue();
        } else query.callHandler();
    }

    private function pushQueue():Void {
        if(currentQuery == null && queries.length > 0) {
            currentQuery = queries.shift();
            sqlDB.transaction(transactionCallback);
        }
    }

    private function transactionCallback(tObj:WebSQLTransaction):Void {
        if(currentQuery.isReturnId) {
            tObj.executeSql(currentQuery.sqlExpression, [], function(tx:WebSQLTransaction, result:SQLiteResult):Void {
                tObj.executeSql("SELECT last_insert_rowid() as rowid",[], successHandler, errorHandler);
            }, errorHandler);
        } else tObj.executeSql(currentQuery.sqlExpression, [], successHandler, errorHandler);
    }

    private function successHandler(tx:WebSQLTransaction, result:SQLiteResult):Void {
        currentQuery.setResult(result);
        currentQuery.callHandler();
        currentQuery = null;
        pushQueue();
    }

    private function errorHandler(tx:WebSQLTransaction, error:SQLError):Void {
        currentQuery.setError(error);
        currentQuery.callHandler();
        currentQuery = null;
        pushQueue();
    }








}
