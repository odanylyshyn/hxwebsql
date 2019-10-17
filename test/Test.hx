package test;

import js.Browser;
import js.html.Element;
import js.sqlite.Database;
import js.sqlite.SqlQuery;
import js.sqlite.SqlOperator;
import js.sqlite.Order;

class Test {
    static private var instance:Test;
    private var db:Database;

    static public function main():Void {
        instance = new Test();
    }

    public function new():Void {
        db = new Database("TestDB");
        getElem('btnCreateTable').addEventListener('click', createTable);
        getElem('btnInsertTwo').addEventListener('click', insertTwoRows);
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
        var q = new SqlQuery('CREATE TABLE IF NOT EXISTS records (username, score)');
        db.exec(q);
    }

    private function insertTwoRows():Void {
        var q1 = new SqlQuery('records', SqlOperator.INSERT);
        q1.set('username', 'Bob');
        q1.set('score', 123);
        db.exec(q1);

        var q2 = new SqlQuery('records', SqlOperator.INSERT);
        q2.set({username: 'Joe', score: 456});
        q2.isReturnId = true;
        q2.handler = function(res:SqlQuery):Void {
            trace(res);
        };
        db.exec(q2);
    }

    private function updateWhere():Void {
        var q1 = new SqlQuery('records', SqlOperator.UPDATE);
        q1.set('score', 900);
        q1.whereEq('username', 'Joe');   // WHERE `username`='Joe'

        var q2 = new SqlQuery('records', SqlOperator.UPDATE);
        q2.set('score', 800);
        q2.whereId(3);                   // WHERE `rowid`=3

        db.exec(q1);
        db.exec(q2);
    }

    private function updateWhereList():Void {
        var q = new SqlQuery('records', SqlOperator.UPDATE);
        q.set('score', 555);
        q.whereList('username', ['Bob', 'Joe']);     // WHERE `username`='Bob' OR `username`='Joe'
        q.handler = function(res:SqlQuery):Void {
            trace(res);
        };
        db.exec(q);
    }

    private function updateWhereMatch():Void {
        var q = new SqlQuery('records', SqlOperator.UPDATE);
        q.set('score', 1000);
        q.whereMatch('username', '%er');             // WHERE `username` LIKE '%er'
        db.exec(q);
    }

    private function deleteWhereEq():Void {
        var q = new SqlQuery('records', SqlOperator.DELETE);
        q.whereEq('username', 'Joe');
        db.exec(q);
    }

    private function select1():Void {
        var q = new SqlQuery('records', SqlOperator.SELECT);
        q.selectFields = ['username', 'score'];
        q.whereEq('username', 'Joe');
        q.handler = function(res:SqlQuery):Void {
            trace(res.isSuccess);
            trace(res.rows);
        };
        db.exec(q);
    }

    private function select2():Void {
        var q = new SqlQuery('records', SqlOperator.SELECT);
        q.limit = 5;
        q.orderFields = ['score'];
        q.order = Order.DESCENDING;
        q.handler = function(res:SqlQuery):Void {
            trace(res.isSuccess);
            trace(res.rows);
        };
        db.exec(q);
    }


}

