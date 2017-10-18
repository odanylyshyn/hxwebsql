package;

import js.Browser;
import js.html.Element;
import js.sqlite.Database;
import js.sqlite.Transaction;
import js.sqlite.SqlQuery;
import js.sqlite.SqlOperator;

class Test {
	static private var instance:Test;
	private var db:Database;

	static public function main():Void {
		instance = new Test();
    }  

    public function new():Void {
    	db = new Database("TestDB");
        getElem('nojs').style.display = 'none';
        getElem('container').style.display = 'block';
        getElem('btnCreateTable').addEventListener('click', createTable);
        getElem('btnInsertTwo').addEventListener('click', insertTwoRows);
        getElem('btnInsertMset').addEventListener('click', insertRowMset);
    }

    inline private function getElem(id:String):Element {
        return Browser.document.getElementById(id);
    }

    private function createTable():Void {
    	trace('run creating table');
        var tr = new Transaction(db);
		tr.addQuery( new SqlQuery('CREATE TABLE IF NOT EXISTS records (username, score)') );
		tr.exec();
    }

    private function insertTwoRows():Void {
    	var tr = new Transaction(db);
		var q1 = new SqlQuery('records', SqlOperator.INSERT);
		q1.set('username', 'Bob');
		q1.set('score', 123);
		tr.addQuery(q1);
		var q2 = new SqlQuery('records', SqlOperator.INSERT);
		q2.set('username', 'Joe');
		q2.set('score', 456);
		tr.addQuery(q2);
		tr.exec();
    }

    private function insertRowMset():Void {
        var tr = new Transaction(db);
		var q = new SqlQuery('records', SqlOperator.INSERT);
		q.mset({username: 'Peter', score: 675});
		tr.addQuery(q);
		tr.exec();
    }

    

}

