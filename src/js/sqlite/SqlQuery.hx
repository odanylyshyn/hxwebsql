package js.sqlite;

import Std.is;

class SqlQuery extends DbQueryResult {
    public var sqlExpr(get, null):String = '';
    public var order:Order = Order.ASCENDING;
    public var limit:Int = 0;

    private var sqlOperator:SqlOperator;
    private var tableName:String = '';
    private var setsMap:Map<String, String>;
    private var whereStr:String = '';

    /**
     * arg1 - sql expression or tableName
     * arg2 - sql operator 
     */
    public function new(arg1:String, ?arg2:SqlOperator) {
        super();
        setsMap = new Map();
        if(arg2 != null) {
            tableName = arg1;
            sqlOperator = arg2;
        } else sqlExpr = arg1;
    }



    // "set" section

    public function set(fieldName:String, value:Any):Void {
        setsMap.set(fieldName, valueToStr(value));
    }

    public function mset(data:Dynamic):Void {
        for (fieldName in Reflect.fields(data)) {
            setsMap.set(fieldName, valueToStr( Reflect.field(data, fieldName)) );
        }
    }



    // "where" section

    public inline function whereEq(fieldName:String, value:Any):Void {
        whereSign(fieldName, '=', value);
    }

    public function whereSign(fieldName:String, sign:String, value:Any):Void {
        whereStr = '`' + fieldName + '`' + sign + "'" + valueToStr(value) + "'";
    }

    public inline function whereId(rowId:Int):Void {
        whereSign('rowid', '=', ''+rowId);
    }

    public function whereList(fieldName:String, varList:Array<Any>):Void {
        var vs:String;
        var whereArr:Array<String> = [];
        for (i in 0...varList.length) {
            vs = valueToStr(varList[i]);
            whereArr.push('`' + fieldName + "`='" + vs + "'");
        }
        whereStr = whereArr.join(' or ');
    }

    public function whereMatch(fieldName:String, likePattern:String):Void {
        whereStr = '`' + fieldName + "` like '" + likePattern + "'";
    }


    ////////////////////////////// private ///////////////////////////////////

    private function valueToStr(value:Any):String {
        var strVal:String = '';
        if(is(value, Bool)) strVal = value ? '1' : '0';
        else strVal = '' + value;
        return strVal;
    }

    private function get_sqlExpr():String {
        if(sqlExpr == '') {
            switch (sqlOperator) {
                case INSERT: sqlExpr = makeInsertExpr();
                case UPDATE: sqlExpr = makeUpdateExpr();
                case DELETE: sqlExpr = makeDeleteExpr();
                case SELECT: sqlExpr = makeSelectExpr();
            }
        }
        return sqlExpr;
    }

    private function makeInsertExpr():String {
        var keys = [];
        var vals = [];
        for(key in setsMap.keys()) {
            keys.push('`' + key + '`');
            vals.push("'" + setsMap[key] + "'");
        }
        var fields:String = keys.join(',');
        var values:String = vals.join(',');
        return 'insert into `' + tableName + '`(' + fields + ') values(' + values + ')';
    }

    private function makeUpdateExpr():String {
        var setArr:Array<String> = [];
        for(key in setsMap.keys()) {
            setArr.push('`' + key + "`='" + setsMap[key] + "'");
        }
        return 'update `' + tableName + '` set ' + setArr.join(', ') + ' where ' + whereStr;
    }

    private function makeDeleteExpr():String {
        return 'delete from `' + tableName + '` where ' + whereStr;
    }

    private function makeSelectExpr():String {
        // TODO
        return '';
    }
    
}



typedef WhereItem = {
    var field: String;
    var value: String;
    var sign: String;
}