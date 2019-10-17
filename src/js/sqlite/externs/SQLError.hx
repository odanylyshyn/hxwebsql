package js.sqlite.externs;

@:native("SQLError")
extern class SQLError {
    public var code:Int;
    public var message:String;
}