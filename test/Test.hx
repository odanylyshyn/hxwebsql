package;

import js.Browser;
import js.html.Element;
import js.sqlite.Database;
import js.sqlite.Transaction;
import js.sqlite.SqlQuery;
import js.sqlite.SqlOperator;
import js.sqlite.DbResult;
import js.sqlite.Order;

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
        getElem('btnUpdate').addEventListener('click', updateWhere);
        getElem('btnUpdateList').addEventListener('click', updateWhereList);
        getElem('btnUpdateMatch').addEventListener('click', updateWhereMatch);
        getElem('btnDeleteMatch').addEventListener('click', deleteWhereEq);
        getElem('btnSelect1').addEventListener('click', select1);
        getElem('btnSelect2').addEventListener('click', select2);
    }

    inline private function getElem(id:String):Element {
        return Browser.document.getElementById(id);
    }

    private function createTable():Void {
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
        q2.isReturnId = true;
        tr.addQuery(q2, 'queryName');
        tr.handler = function(res:DbResult):Void {
            trace(res.isSuccess);
            var tx = cast(res, Transaction);
            trace(tx.queries);
            trace(tx.getQuery('queryName_rowid').rows[0].rowid);
        };
        tr.exec();
    }

    private function insertRowMset():Void {
        var tr = new Transaction(db);
        var q = new SqlQuery('records', SqlOperator.INSERT);
        q.mset({username: 'Peter', score: 675});
        tr.addQuery(q);
        tr.exec();
    }

    private function updateWhere():Void {
        var tr = new Transaction(db);
        var q1 = new SqlQuery('records', SqlOperator.UPDATE);
        q1.set('score', 900);
        q1.whereEq('username', 'Joe');
        tr.addQuery(q1);
        var q2 = new SqlQuery('records', SqlOperator.UPDATE);
        q2.set('score', 800);
        q2.whereId(3);
        tr.addQuery(q2);
        tr.handler = function(res:DbResult):Void {
            var tx = cast(res, Transaction);
            trace(tx.queries);
        };
        tr.exec();
    }

    private function updateWhereList():Void {
        var tr = new Transaction(db);
        var q = new SqlQuery('records', SqlOperator.UPDATE);
        q.set('score', 555);
        q.whereList('username', ['Bob', 'Joe']);
        tr.addQuery(q);
        tr.exec();
    }

    private function updateWhereMatch():Void {
        var tr = new Transaction(db);
        var q = new SqlQuery('records', SqlOperator.UPDATE);
        q.set('score', 1000);
        q.whereMatch('username', '%er');
        tr.addQuery(q);
        tr.exec();
    }

    private function deleteWhereEq():Void {
        var tr = new Transaction(db);
        var q = new SqlQuery('records', SqlOperator.DELETE);
        q.whereEq('username', 'Joe');
        tr.addQuery(q);
        tr.handler = function(res:DbResult):Void {
            var tx = cast(res, Transaction);
            trace(tx.queries);
        };
        tr.exec();
    }

    private function select1():Void {
        var tr = new Transaction(db);
        var q = new SqlQuery('records', SqlOperator.SELECT);
        q.selectFields = ['username', 'score'];
        q.whereEq('username', 'Joe');
        tr.addQuery(q);
        tr.handler = function(res:DbResult):Void {
            trace(res.isSuccess);
            var tx = cast(res, Transaction);
            trace(tx.queries);
        };
        tr.exec();
    }

    private function select2():Void {
        var tr = new Transaction(db);
        var q = new SqlQuery('records', SqlOperator.SELECT);
        q.limit = 5;
        q.orderFields = ['score'];
        q.order = Order.DESCENDING;
        tr.addQuery(q);
        tr.handler = function(res:DbResult):Void {
            trace(res.isSuccess);
            var tx = cast(res, Transaction);
            trace(tx.queries);
        };
        tr.exec();
    }


}

