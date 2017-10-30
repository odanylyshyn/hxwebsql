### under construction
The project is under development. Some functional has not been implemented yet.
In this description, working examples are given (you can check them by opening the file /test/test.html)

[Bug in transaction](https://github.com/odanylyshyn/hxwebsql/issues/3)

### Haxe version
Use Haxe version 3 and more

# Examples

### Open database
Create database, if missing.
```haxe
var db = new Database("TestDB");
```

### Run any SQL query
Here is an example of creating a table.
```haxe
var tr = new Transaction(db);
tr.addQuery( new SqlQuery('CREATE TABLE IF NOT EXISTS records (username, score)') );
tr.exec();
```

### Insert
Second query with returning last insert rowid.
```haxe
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
    trace(tx.queries);                           // length = 3 (+ returning id query)
    trace(tx.getQuery('queryName_rowid').rows[0].rowid);
};
tr.exec();
```

### Insert, another way
```haxe
var tr = new Transaction(db);
var q = new SqlQuery('records', SqlOperator.INSERT);
q.mset({username: 'Peter', score: 675});
tr.addQuery(q);
tr.exec();
```

### Update
```haxe
var tr = new Transaction(db);

var q1 = new SqlQuery('records', SqlOperator.UPDATE);
q1.set('score', 900);
q1.whereEq('username', 'Joe');   // WHERE `username`='Joe'
tr.addQuery(q1);

var q2 = new SqlQuery('records', SqlOperator.UPDATE);
q2.set('score', 800);
q2.whereId(3);                   // WHERE `rowid`=3
tr.addQuery(q2);

tr.exec();
```

### Update, where list of variants
```haxe
var tr = new Transaction(db);

var q = new SqlQuery('records', SqlOperator.UPDATE);
q.set('score', 555);
q.whereList('username', ['Bob', 'Joe']);     // WHERE `username`='Bob' OR `username`='Joe'
tr.addQuery(q);

tr.exec();
```

### Update, where match LIKE-pattern
```haxe
var tr = new Transaction(db);

var q = new SqlQuery('records', SqlOperator.UPDATE);
q.set('score', 1000);
q.whereMatch('username', '%er');             // WHERE `username` LIKE '%er'
tr.addQuery(q);

tr.exec();
```

### Delete
```haxe
var tr = new Transaction(db);
var q = new SqlQuery('records', SqlOperator.DELETE);
q.whereEq('username', 'Joe');
tr.addQuery(q);
tr.exec();
```

### Select fields with "where"
```haxe
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
```

### Select all with order and limit
```haxe
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
```
