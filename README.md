### under construction
The project is under development. Some functional has not been implemented yet.
In this description, working examples are given (you can check them by opening the file /test/test.html)
Current version: 0.2.1

### Haxe version
Use Haxe version 3 and more

### Release notes & TODO
version | tasks | status
----|-------------------
0.1 | INSERT, UPDATE, DELETE & raw SQL | released
0.2 | callbacks | released
0.3 | SELECT & hanling result | TODO
0.4 | returning rowID after INSERT | TODO
0.5 | Creating table | TODO
0.6 | Unique, primary key, types(?) | TODO
0.7 | Drop table & vacuum | TODO
0.8 | Testing script | TODO
0.9 | Debugging for chrome & cordova plugin | TODO
1.0 | Full documentation | TODO

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
```haxe
var tr = new Transaction(db);
var q1 = new SqlQuery('records', SqlOperator.INSERT);
q1.set('username', 'Bob');
q1.set('score', 123);
tr.addQuery(q1);

var q2 = new SqlQuery('records', SqlOperator.INSERT);
q2.set('username', 'Joe');
q2.set('score', 456);
tr.addQuery(q2);
tr.handler = function(res:DbResult):Void {
    trace(res.isSuccess);
    // review of completed transaction:
    var tx = cast(res, Transaction);
    trace(tx.queries);
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
q2.whereId(3);                   // WHERE `rowid`='3'
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
