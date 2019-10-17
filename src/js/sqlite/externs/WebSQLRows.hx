package js.sqlite.externs;

@:native("WebSQLRows")
extern class WebSQLRows {
    public var length:Int;
    public function item(i:Int):Dynamic;
}