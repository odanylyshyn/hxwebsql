package js.sqlite;

class DbResult {
    public var isSuccess(default, null):Bool;
    public var errorCode(default, null):ErrorCode;
    public var errorMessage(default, null):String;
    public var status(default, null):DbStatus;
    public var handler:DbResult->Void;
    private var isHandled:Bool;

    public function new():Void {
        isSuccess = true;
        errorCode = ErrorCode.NO_ERROR;
        errorMessage = '';
        status = DbStatus.OPEN;
        isHandled = false;
    }

    private function successHandler():Void {
        status = DbStatus.CLOSE;
        if(!isHandled) {
            if(handler != null) handler(this);
            isHandled = true;
        }
    }

    private function errorHandler(errorMsg:String):Void {
        isSuccess = false;
        errorCode = ErrorCode.SQL_ERROR;
        errorMessage = errorMsg;
        status = DbStatus.CLOSE;
        if(!isHandled) {
            if(handler != null) handler(this);
            isHandled = true;
        }
    }

}