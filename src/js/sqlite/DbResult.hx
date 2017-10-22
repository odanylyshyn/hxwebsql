package js.sqlite;

class DbResult {
    public var isSuccess(default, null):Bool;
    public var errorCode(default, null):ErrorCode;
    public var errorMessage(default, null):String;
    public var status(default, null):DbStatus;
    public var handler:DbResult->Void;
    public var isHandled(default, null):Bool;

    public function new():Void {
        isSuccess = true;
        errorCode = ErrorCode.NO_ERROR;
        errorMessage = '';
        status = DbStatus.OPEN;
        isHandled = false;
    }
}