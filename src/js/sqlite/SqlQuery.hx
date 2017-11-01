package js.sqlite;

import Std.is;
import js.sqlite.WebSqlExtern.SQLiteResult;
import js.sqlite.WebSqlExtern.SQLError;

class SqlQuery {
    public var sqlExpression(default, null):String = "";
    public var orderFields:Array<String>;
    public var order:Order = Order.ASCENDING;
    public var limit:Int = 0;
    public var isReturnId:Bool = false;
    public var selectFields:Array<String>;
    public var rows(default, null):Array<Dynamic>;
    public var handler(null, default):SqlQuery->Void;
    public var isSuccess(default, null):Bool;
    public var errorMessage(default, null):String;
    

    private var isHandled:Bool;
    private var sqlOperator:SqlOperator;
    private var tableName:String = "";
    private var setsMap:Map<String, Any>;
    private var whereStr:String = "";
    private var isLocked:Bool = false;

    /**
     * arg1 - sql expression or tableName
     * arg2 - sql operator 
     */
    public function new(arg1:String, ?arg2:SqlOperator) {
        isSuccess = true;
        errorMessage = '';
        isHandled = false;
        setsMap = new Map();
        selectFields = [];
        rows = [];
        orderFields = [];
        if(arg2 != null) {
            tableName = arg1;
            sqlOperator = arg2;
        } else sqlExpression = arg1;
    }

    public function set(arg1:Any, ?arg2:Any):Void {
        if(isLocked) return;
        if(is(arg1, String) && arg2 != null)
            setsMap.set(arg1, arg2);
        else if(is(arg1, Dynamic)) {
            for (fieldName in Reflect.fields(arg1)) {
                setsMap.set(fieldName, Reflect.field(arg1, fieldName) );
            }
        }
    }

    public function whereSign(fieldName:String, sign:String, value:Any):Void {
        if(isLocked) return;
        whereStr = " where `" + fieldName + "`" + sign + stringify(value);
    }

    public inline function whereId(rowId:Int):Void {
        whereSign("rowid", "=", rowId);
    }

    public inline function whereEq(fieldName:String, value:Any):Void {
        whereSign(fieldName, "=", value);
    }

    public function whereList(fieldName:String, varList:Array<Any>):Void {
        if(isLocked) return;
        var vs:String;
        var whereArr:Array<String> = [];
        for (i in 0...varList.length) {
            vs = stringify(varList[i]);
            whereArr.push("`" + fieldName + "`=" + vs);
        }
        whereStr = " where " + whereArr.join(" or ");
    }

    public function whereMatch(fieldName:String, likePattern:String):Void {
        if(isLocked) return;
        whereStr = " where `" + fieldName + "` like '" + likePattern + "'";
    }


    ////////////////////////////// allow for "Database" only /////////////////

    @:allow(js.sqlite.Database)
    private function prepareToExecuting():Void {
        isLocked = true;
        if(sqlExpression == '') {
            switch (sqlOperator) {
                case INSERT: sqlExpression = makeInsertExpr();
                case UPDATE: sqlExpression = makeUpdateExpr();
                case DELETE: sqlExpression = makeDeleteExpr();
                case SELECT: sqlExpression = makeSelectExpr();
            }
        }
    }

    @:allow(js.sqlite.Database)
    private function setResult(data:SQLiteResult):Void {
        rows = [];
        for (i in 0...data.rows.length) {
            rows.push(data.rows.item(i));
        }
    }

    @:allow(js.sqlite.Database)
    private function setError(error:SQLError):Void {
        isSuccess = false;
        errorMessage = error.message;
    }

    @:allow(js.sqlite.Database)
    private function callHandler():Void {
        if(handler != null) handler(this);
    }


    ////////////////////////////// private ///////////////////////////////////
    
    private function stringify(value:Any):String {
        var strVal:String = "";
        if(is(value, Bool)) strVal = value ? "1" : "0";
        else if(is(value, String)) strVal = "'" + value + "'";
        else strVal = "" + value;
        return strVal;
    }

    private function makeInsertExpr():String {
        if(!checkSets()) return "";
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
        if(!checkSets()) return "";
        if(!checkWhere()) return "";
        var setArr:Array<String> = [];
        for(key in setsMap.keys()) {
            setArr.push("`" + key + "`=" + stringify(setsMap[key]));
        }
        return 'update `$tableName` set ' + setArr.join(", ") + whereStr;
    }

    private function makeDeleteExpr():String {
        if(!checkWhere()) return "";
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
        return expr;
    }

    private function checkSets():Bool {
        if(Lambda.count(setsMap) == 0) {
            isSuccess = false;
            errorMessage = "Cannot make query expression INSERT/UPDATE without param sets";
            return false;
        }
        return true;
    }

    private function checkWhere():Bool {
        if(whereStr == "") {
            isSuccess = false;
            errorMessage = 'Cannot make query expression UPDATE/DELETE without "where" sets';
            return false;
        }
        return true;
    }

}


typedef WhereItem = {
    var field: String;
    var value: String;
    var sign: String;
}