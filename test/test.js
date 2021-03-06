// Generated by Haxe 3.4.7
(function ($global) { "use strict";
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Lambda = function() { };
Lambda.__name__ = true;
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var _ = $iterator(it)();
		while(_.hasNext()) {
			var _1 = _.next();
			++n;
		}
	} else {
		var x = $iterator(it)();
		while(x.hasNext()) {
			var x1 = x.next();
			if(pred(x1)) {
				++n;
			}
		}
	}
	return n;
};
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) {
			a.push(f);
		}
		}
	}
	return a;
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = true;
var haxe_ds__$StringMap_StringMapIterator = function(map,keys) {
	this.map = map;
	this.keys = keys;
	this.index = 0;
	this.count = keys.length;
};
haxe_ds__$StringMap_StringMapIterator.__name__ = true;
haxe_ds__$StringMap_StringMapIterator.prototype = {
	hasNext: function() {
		return this.index < this.count;
	}
	,next: function() {
		var _this = this.map;
		var key = this.keys[this.index++];
		if(__map_reserved[key] != null) {
			return _this.getReserved(key);
		} else {
			return _this.h[key];
		}
	}
	,__class__: haxe_ds__$StringMap_StringMapIterator
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	setReserved: function(key,value) {
		if(this.rh == null) {
			this.rh = { };
		}
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) {
			return null;
		} else {
			return this.rh["$" + key];
		}
	}
	,keys: function() {
		return HxOverrides.iter(this.arrayKeys());
	}
	,arrayKeys: function() {
		var out = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) {
			out.push(key);
		}
		}
		if(this.rh != null) {
			for( var key in this.rh ) {
			if(key.charCodeAt(0) == 36) {
				out.push(key.substr(1));
			}
			}
		}
		return out;
	}
	,iterator: function() {
		return new haxe_ds__$StringMap_StringMapIterator(this,this.arrayKeys());
	}
	,__class__: haxe_ds_StringMap
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) {
					return o[0];
				}
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) {
						str += "," + js_Boot.__string_rec(o[i],s);
					} else {
						str += js_Boot.__string_rec(o[i],s);
					}
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g11 = 0;
			var _g2 = l;
			while(_g11 < _g2) {
				var i2 = _g11++;
				str1 += (i2 > 0 ? "," : "") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) {
			str2 += ", \n";
		}
		str2 += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) {
		return false;
	}
	if(cc == cl) {
		return true;
	}
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) {
				return true;
			}
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) {
		return false;
	}
	switch(cl) {
	case Array:
		if((o instanceof Array)) {
			return o.__enum__ == null;
		} else {
			return false;
		}
		break;
	case Bool:
		return typeof(o) == "boolean";
	case Dynamic:
		return true;
	case Float:
		return typeof(o) == "number";
	case Int:
		if(typeof(o) == "number") {
			return (o|0) === o;
		} else {
			return false;
		}
		break;
	case String:
		return typeof(o) == "string";
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					return true;
				}
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) {
					return true;
				}
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) {
					return true;
				}
			}
		} else {
			return false;
		}
		if(cl == Class ? o.__name__ != null : false) {
			return true;
		}
		if(cl == Enum ? o.__ename__ != null : false) {
			return true;
		}
		return o.__enum__ == cl;
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var js_sqlite_Database = function(dbName) {
	var isPlugin = Object.prototype.hasOwnProperty.call(window,"sqlitePlugin");
	var isWebSQL = Object.prototype.hasOwnProperty.call(window,"openDatabase");
	if(isPlugin) {
		this.sqlDB = window.sqlitePlugin.openDatabase(dbName + ".db");
		this.dbTypeName = "Cordova SQLite plugin";
	} else if(isWebSQL) {
		this.sqlDB = window.openDatabase(dbName, "", dbName, 256*1024);
		this.dbTypeName = "Webkit WebSQL";
	} else {
		window.console.error("SQLite is not supported by your browser");
	}
	this.queries = [];
};
js_sqlite_Database.__name__ = true;
js_sqlite_Database.prototype = {
	exec: function(queryData) {
		var query;
		if(typeof(queryData) == "string") {
			query = new js_sqlite_SqlQuery(queryData);
		} else if(js_Boot.__instanceof(queryData,js_sqlite_SqlQuery)) {
			query = queryData;
		} else {
			window.console.error("Database.exec: incorrect argument type. SqlQuery or String expected.");
			return;
		}
		query.prepareToExecuting();
		if(query.isSuccess) {
			this.queries.push(query);
			this.pushQueue();
		} else {
			query.callHandler();
		}
	}
	,pushQueue: function() {
		if(this.currentQuery == null && this.queries.length > 0) {
			this.currentQuery = this.queries.shift();
			this.sqlDB.transaction($bind(this,this.transactionCallback));
		}
	}
	,transactionCallback: function(tObj) {
		var _gthis = this;
		if(this.currentQuery.isReturnId) {
			tObj.executeSql(this.currentQuery.sqlExpression,[],function(tx,result) {
				tObj.executeSql("SELECT last_insert_rowid() as rowid",[],$bind(_gthis,_gthis.successHandler),$bind(_gthis,_gthis.errorHandler));
			},$bind(this,this.errorHandler));
		} else {
			tObj.executeSql(this.currentQuery.sqlExpression,[],$bind(this,this.successHandler),$bind(this,this.errorHandler));
		}
	}
	,successHandler: function(tx,result) {
		this.currentQuery.setResult(result);
		this.currentQuery.callHandler();
		this.currentQuery = null;
		this.pushQueue();
	}
	,errorHandler: function(tx,error) {
		this.currentQuery.setError(error);
		this.currentQuery.callHandler();
		this.currentQuery = null;
		this.pushQueue();
	}
	,__class__: js_sqlite_Database
};
var js_sqlite_SqlQuery = function(arg1,arg2) {
	this.isLocked = false;
	this.whereStr = "";
	this.tableName = "";
	this.isReturnId = false;
	this.limit = 0;
	this.order = "asc";
	this.sqlExpression = "";
	this.isSuccess = true;
	this.errorMessage = "";
	this.isHandled = false;
	this.setsMap = new haxe_ds_StringMap();
	this.selectFields = [];
	this.rows = [];
	this.orderFields = [];
	if(arg2 != null) {
		this.tableName = arg1;
		this.sqlOperator = arg2;
	} else {
		this.sqlExpression = arg1;
	}
};
js_sqlite_SqlQuery.__name__ = true;
js_sqlite_SqlQuery.prototype = {
	set: function(arg1,arg2) {
		if(this.isLocked) {
			return;
		}
		if(typeof(arg1) == "string" && arg2 != null) {
			var _this = this.setsMap;
			var key = arg1;
			if(__map_reserved[key] != null) {
				_this.setReserved(key,arg2);
			} else {
				_this.h[key] = arg2;
			}
		} else if(js_Boot.__instanceof(arg1,Dynamic)) {
			var _g = 0;
			var _g1 = Reflect.fields(arg1);
			while(_g < _g1.length) {
				var fieldName = _g1[_g];
				++_g;
				var this1 = this.setsMap;
				var value = Reflect.field(arg1,fieldName);
				var _this1 = this1;
				if(__map_reserved[fieldName] != null) {
					_this1.setReserved(fieldName,value);
				} else {
					_this1.h[fieldName] = value;
				}
			}
		}
	}
	,whereSign: function(fieldName,sign,value) {
		if(this.isLocked) {
			return;
		}
		this.whereStr = " where `" + fieldName + "`" + sign + this.stringify(value);
	}
	,whereId: function(rowId) {
		this.whereSign("rowid","=",rowId);
	}
	,whereEq: function(fieldName,value) {
		this.whereSign(fieldName,"=",value);
	}
	,whereList: function(fieldName,varList) {
		if(this.isLocked) {
			return;
		}
		var vs;
		var whereArr = [];
		var _g1 = 0;
		var _g = varList.length;
		while(_g1 < _g) {
			var i = _g1++;
			vs = this.stringify(varList[i]);
			whereArr.push("`" + fieldName + "`=" + vs);
		}
		this.whereStr = " where " + whereArr.join(" or ");
	}
	,whereMatch: function(fieldName,likePattern) {
		if(this.isLocked) {
			return;
		}
		this.whereStr = " where `" + fieldName + "` like '" + likePattern + "'";
	}
	,prepareToExecuting: function() {
		this.isLocked = true;
		if(this.sqlExpression == "") {
			var _g = this.sqlOperator;
			switch(_g) {
			case "delete":
				this.sqlExpression = this.makeDeleteExpr();
				break;
			case "insert":
				this.sqlExpression = this.makeInsertExpr();
				break;
			case "select":
				this.sqlExpression = this.makeSelectExpr();
				break;
			case "update":
				this.sqlExpression = this.makeUpdateExpr();
				break;
			}
		}
	}
	,setResult: function(data) {
		this.rows = [];
		var _g1 = 0;
		var _g = data.rows.length;
		while(_g1 < _g) {
			var i = _g1++;
			this.rows.push(data.rows.item(i));
		}
	}
	,setError: function(error) {
		this.isSuccess = false;
		this.errorMessage = error.message;
	}
	,callHandler: function() {
		if(this.handler != null) {
			this.handler(this);
		}
	}
	,stringify: function(value) {
		var strVal = "";
		if(typeof(value) == "boolean") {
			if(value) {
				strVal = "1";
			} else {
				strVal = "0";
			}
		} else if(typeof(value) == "string") {
			strVal = "'" + Std.string(value) + "'";
		} else {
			strVal = "" + Std.string(value);
		}
		return strVal;
	}
	,makeInsertExpr: function() {
		if(!this.checkSets()) {
			return "";
		}
		var keys = [];
		var vals = [];
		var key = this.setsMap.keys();
		while(key.hasNext()) {
			var key1 = key.next();
			keys.push("`" + key1 + "`");
			var _this = this.setsMap;
			vals.push(this.stringify(__map_reserved[key1] != null ? _this.getReserved(key1) : _this.h[key1]));
		}
		var fields = keys.join(",");
		var values = vals.join(",");
		return "insert into `" + this.tableName + "` (" + fields + ") values(" + values + ")";
	}
	,makeUpdateExpr: function() {
		if(!this.checkSets()) {
			return "";
		}
		if(!this.checkWhere()) {
			return "";
		}
		var setArr = [];
		var key = this.setsMap.keys();
		while(key.hasNext()) {
			var key1 = key.next();
			var _this = this.setsMap;
			setArr.push("`" + key1 + "`=" + this.stringify(__map_reserved[key1] != null ? _this.getReserved(key1) : _this.h[key1]));
		}
		return "update `" + this.tableName + "` set " + setArr.join(", ") + this.whereStr;
	}
	,makeDeleteExpr: function() {
		if(!this.checkWhere()) {
			return "";
		}
		return "delete from `" + this.tableName + "` " + this.whereStr;
	}
	,makeSelectExpr: function() {
		var fields;
		if(this.selectFields.length > 0) {
			fields = "`" + this.selectFields.join("`,`") + "`";
		} else {
			fields = "*";
		}
		var orderStr = "";
		if(this.orderFields.length > 0) {
			orderStr = "order by `" + this.orderFields.join("`,`") + "` " + this.order;
		}
		var expr = "select " + fields + " from `" + this.tableName + "` " + this.whereStr + " " + orderStr;
		if(this.limit > 0) {
			expr += " limit " + this.limit;
		}
		return expr;
	}
	,checkSets: function() {
		if(Lambda.count(this.setsMap) == 0) {
			this.isSuccess = false;
			this.errorMessage = "Cannot make query expression INSERT/UPDATE without param sets";
			return false;
		}
		return true;
	}
	,checkWhere: function() {
		if(this.whereStr == "") {
			this.isSuccess = false;
			this.errorMessage = "Cannot make query expression UPDATE/DELETE without \"where\" sets";
			return false;
		}
		return true;
	}
	,__class__: js_sqlite_SqlQuery
};
var test_Test = function() {
	this.db = new js_sqlite_Database("TestDB");
	window.document.getElementById("btnCreateTable").addEventListener("click",$bind(this,this.createTable));
	window.document.getElementById("btnInsertTwo").addEventListener("click",$bind(this,this.insertTwoRows));
	window.document.getElementById("btnUpdate").addEventListener("click",$bind(this,this.updateWhere));
	window.document.getElementById("btnUpdateList").addEventListener("click",$bind(this,this.updateWhereList));
	window.document.getElementById("btnUpdateMatch").addEventListener("click",$bind(this,this.updateWhereMatch));
	window.document.getElementById("btnDeleteMatch").addEventListener("click",$bind(this,this.deleteWhereEq));
	window.document.getElementById("btnSelect1").addEventListener("click",$bind(this,this.select1));
	window.document.getElementById("btnSelect2").addEventListener("click",$bind(this,this.select2));
};
test_Test.__name__ = true;
test_Test.main = function() {
	test_Test.instance = new test_Test();
};
test_Test.prototype = {
	getElem: function(id) {
		return window.document.getElementById(id);
	}
	,createTable: function() {
		var q = new js_sqlite_SqlQuery("CREATE TABLE IF NOT EXISTS records (username, score)");
		this.db.exec(q);
	}
	,insertTwoRows: function() {
		var q1 = new js_sqlite_SqlQuery("records","insert");
		q1.set("username","Bob");
		q1.set("score",123);
		this.db.exec(q1);
		var q2 = new js_sqlite_SqlQuery("records","insert");
		q2.set({ username : "Joe", score : 456});
		q2.isReturnId = true;
		q2.handler = function(res) {
			console.log(res);
		};
		this.db.exec(q2);
	}
	,updateWhere: function() {
		var q1 = new js_sqlite_SqlQuery("records","update");
		q1.set("score",900);
		q1.whereSign("username","=","Joe");
		var q2 = new js_sqlite_SqlQuery("records","update");
		q2.set("score",800);
		q2.whereSign("rowid","=",3);
		this.db.exec(q1);
		this.db.exec(q2);
	}
	,updateWhereList: function() {
		var q = new js_sqlite_SqlQuery("records","update");
		q.set("score",555);
		q.whereList("username",["Bob","Joe"]);
		q.handler = function(res) {
			console.log(res);
		};
		this.db.exec(q);
	}
	,updateWhereMatch: function() {
		var q = new js_sqlite_SqlQuery("records","update");
		q.set("score",1000);
		q.whereMatch("username","%er");
		this.db.exec(q);
	}
	,deleteWhereEq: function() {
		var q = new js_sqlite_SqlQuery("records","delete");
		q.whereSign("username","=","Joe");
		this.db.exec(q);
	}
	,select1: function() {
		var q = new js_sqlite_SqlQuery("records","select");
		q.selectFields = ["username","score"];
		q.whereSign("username","=","Joe");
		q.handler = function(res) {
			console.log(res.isSuccess);
			console.log(res.rows);
		};
		this.db.exec(q);
	}
	,select2: function() {
		var q = new js_sqlite_SqlQuery("records","select");
		q.limit = 5;
		q.orderFields = ["score"];
		q.order = "desc";
		q.handler = function(res) {
			console.log(res.isSuccess);
			console.log(res.rows);
		};
		this.db.exec(q);
	}
	,__class__: test_Test
};
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; }
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
var __map_reserved = {};
js_Boot.__toStr = ({ }).toString;
test_Test.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

//# sourceMappingURL=test.js.map