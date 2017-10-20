package js.sqlite;

import js.Browser;
import js.sqlite.WebSqlExtern.WebSQLDatabase;

class Database extends DbResult {
    public var dbType(default, null):String;
    private var sqlDB:WebSQLDatabase;

    public function new(dbName:String):Void {
        super();
        var isPlugin = Reflect.hasField(Browser.window, "sqlitePlugin");
        var isWebSQL = Reflect.hasField(Browser.window, "openDatabase");
        if(isPlugin) {
            sqlDB = untyped __js__("window.sqlitePlugin.openDatabase({0})", dbName + ".db");
            dbType = "Webkit WebSQL";
        } else if(isWebSQL) {
            sqlDB = untyped __js__('window.openDatabase({0}, "", {0}, 256*1024)', dbName);
            dbType = "Cordova SQLite plugin";
        } else {
            isSuccess = false;
            errorCode = ErrorCode.NO_DB;
            errorMessage = "SQLite is not supported by your browser";
            Browser.console.error(errorMessage);
        }
    }

    @:allow(js.sqlite.Transaction)
    private function getSqlDb():WebSQLDatabase {
        return sqlDB;
    }

}