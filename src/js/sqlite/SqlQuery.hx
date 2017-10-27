package js.sqlite;

import Std.is;
import js.sqlite.WebSqlExtern.WebSQLTransaction;
import js.sqlite.WebSqlExtern.SQLiteResult;
import js.sqlite.WebSqlExtern.WebSQLRows;
import js.sqlite.WebSqlExtern.SQLError;

class SqlQuery extends DbResult {
    public var sqlExpression(default, null):String = "";
    public var orderFields:Array<String>;
    public var order:Order = Order.ASCENDING;
    public var limit:Int = 0;
    public var isReturnId:Bool = false;
    public var selectFields:Array<String>;
    public var rows(default, null):Array<Dynamic>;

    private var sqlOperator:SqlOperator;
    private var tableName:String = "";
    private var setsMap:Map<String, Any>;
    private var whereStr:String = "";

    /**
     * arg1 - sql expression or tableName
     * arg2 - sql operator 
     */
    public function new(arg1:String, ?arg2:SqlOperator) {
        super();
        setsMap = new Map();
        selectFields = [];
        rows = [];
        orderFields = [];
        if(arg2 != null) {
            tableName = arg1;
            sqlOperator = arg2;
        } else sqlExpression = arg1;
    }

    public function set(fieldName:String, value:Any):Void {
        setsMap.set(fieldName, value);
    }

    public function mset(data:Dynamic):Void {
        for (fieldName in Reflect.fields(data)) {
            setsMap.set(fieldName, Reflect.field(data, fieldName) );
        }
    }

    public inline function whereEq(fieldName:String, value:Any):Void {
        whereSign(fieldName, "=", value);
    }

    public function whereSign(fieldName:String, sign:String, value:Any):Void {
        whereStr = " where `" + fieldName + "`" + sign + stringify(value);
    }

    public inline function whereId(rowId:Int):Void {
        whereSign("rowid", "=", rowId);
    }

    public function whereList(fieldName:String, varList:Array<Any>):Void {
        var vs:String;
        var whereArr:Array<String> = [];
        for (i in 0...varList.length) {
            vs = stringify(varList[i]);
            whereArr.push("`" + fieldName + "`=" + vs);
        }
        whereStr = " where " + whereArr.join(" or ");
    }

    public function whereMatch(fieldName:String, likePattern:String):Void {
        whereStr = " where `" + fieldName + "` like '" + likePattern + "'";
    }


    ////////////////////////////// private ///////////////////////////////////

    @:allow(js.sqlite.Transaction)
    private function exec(tObj:WebSQLTransaction):Void {
        status = DbStatus.RUNNING;
        if(sqlExpression == '') {
            switch (sqlOperator) {
                case INSERT: sqlExpression = makeInsertExpr();
                case UPDATE: sqlExpression = makeUpdateExpr();
                case DELETE: sqlExpression = makeDeleteExpr();
                case SELECT: sqlExpression = makeSelectExpr();
            }
        }
        tObj.executeSql(sqlExpression, [], sqlSuccessHandler, sqlErrorHandler);
    }

    private function sqlSuccessHandler(tx:WebSQLTransaction, result:SQLiteResult):Void {
        for (i in 0...result.rows.length) {
            rows.push(result.rows.item(i));
        }
        super.successHandler();
    }

    private function sqlErrorHandler(tx:WebSQLTransaction, error:SQLError):Void {
        super.errorHandler(error);
    }

    private function stringify(value:Any):String {
        var strVal:String = "";
        if(is(value, Bool)) strVal = value ? "1" : "0";
        else if(is(value, String)) strVal = "'" + value + "'";
        else strVal = "" + value;
        return strVal;
    }

    private function makeInsertExpr():String {
        var keys = [];
        var vals = [];
        for(key in setsMap.keys()) {
            keys.push("`" + key + "`");
            vals.push(stringify(setsMap[key]));
        }
        var fields:String = keys.join(",");
        var values:String = vals.join(",");
        return 'insert into `$tableName` ($fields) values($values)';
    }

    private function makeUpdateExpr():String {
        var setArr:Array<String> = [];
        for(key in setsMap.keys()) {
            setArr.push("`" + key + "`=" + stringify(setsMap[key]));
        }
        return 'update `$tableName` set ' + setArr.join(", ") + whereStr;
    }

    private function makeDeleteExpr():String {
        if(whereStr == "") return ""; // TODO: using error
        return 'delete from `$tableName` $whereStr';
    }

    private function makeSelectExpr():String {
        var fields:String;
        if(selectFields.length > 0) fields = "`" + selectFields.join("`,`") + "`";
        else fields = "*";

        var orderStr:String = '';
        if(orderFields.length > 0) orderStr = "order by `" + orderFields.join("`,`") + "` " + order;
        
        var expr:String = 'select $fields from `$tableName` $whereStr $orderStr';
        if(limit > 0) expr += ' limit $limit';
        trace(expr);
        return expr;
    }
    
}



typedef WhereItem = {
    var field: String;
    var value: String;
    var sign: String;
}