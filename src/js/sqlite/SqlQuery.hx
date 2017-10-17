package js.sqlite;

import Std.is;

class SqlQuery extends DbQueryResult {
	public  var sqlExpr(get, null):String = '';
	public  var order:Order = Order.ASCENDING;
	public  var limit:Int = 0;

	private var sqlOperator:SqlOperator;
	private var tableName:String = '';
	private var setsMap:Map<String, String>;
	private var whereArr:Array<WhereItem>;

	/**
	 * arg1 - sql expression or tableName
	 * arg2 - sql operator 
	 */
	public function new(arg1:String, ?arg2:SqlOperator) {
		super();
		setsMap = new Map();
		whereArr = new Array();
		if(arg2 != null) {
			tableName = arg1;
			sqlOperator = arg2;
		} else sqlExpr = arg1;
	}

	public function set(fieldName:String, value:Any):Void {
	    setsMap.set(fieldName, valueToStr(value));
	}

	public function whereEq(fieldName:String, value:Any):Void {
	    whereSign(fieldName, '=', value);
	}

	public function whereSign(fieldName:String, sign:String, value:Any):Void {
	    whereArr.push({field:fieldName, value: valueToStr(value), sign: sign});
	}

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
		return cast(sqlOperator, String) + ' into `' + tableName + '`(' + fields + ') values(' + values + ')';
	}

	private function makeUpdateExpr():String {
		// TODO
		return '';
	}

	private function makeDeleteExpr():String {
		// TODO
		return '';
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