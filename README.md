# Requirements
Haxe 3.0 or higher.

# Examples

### Open database
Create database, if missing.
```haxe
var db = new Database("TestDB");
```

### Run any SQL query
Here is an example of creating a table.
```haxe
var q = new SqlQuery('CREATE TABLE IF NOT EXISTS records (username, score)');
q.handler = function(res:SqlQuery):Void { /* ... */ }
db.exec(q);
// or
db.exec('CREATE TABLE IF NOT EXISTS records (username, score)'); // no handler!
```

### Insert
Second query with returning last insert rowid.
```haxe
var q1 = new SqlQuery('records', SqlOperator.INSERT);
q1.set('username', 'Bob');
q1.set('score', 123);
db.exec(q1);

var q2 = new SqlQuery('records', SqlOperator.INSERT);
q2.set({username: 'Joe', score: 456});
q2.isReturnId = true;
q2.handler = function(res:SqlQuery):Void {
    trace(res.isSuccess);
    trace(res.rows[0].rowid);
};
db.exec(q2);
```

### Update
```haxe
var q1 = new SqlQuery('records', SqlOperator.UPDATE);
q1.set('score', 900);
q1.whereEq('username', 'Joe');   // WHERE `username`='Joe'

var q2 = new SqlQuery('records', SqlOperator.UPDATE);
q2.set('score', 800);
q2.whereId(3);                   // WHERE `rowid`=3

db.exec(q1);
db.exec(q2);

```

### Update, where list of variants
```haxe
var q = new SqlQuery('records', SqlOperator.UPDATE);
q.set('score', 555);
q.whereList('username', ['Bob', 'Joe']);     // WHERE `username`='Bob' OR `username`='Joe'
db.exec(q);
```

### Update, where match LIKE-pattern
```haxe
var q = new SqlQuery('records', SqlOperator.UPDATE);
q.set('score', 1000);
q.whereMatch('username', '%er');             // WHERE `username` LIKE '%er'
db.exec(q);
```

### Delete
```haxe
var q = new SqlQuery('records', SqlOperator.DELETE);
q.whereEq('username', 'Joe');
db.exec(q);
```

### Select fields with "where"
```haxe
var q = new SqlQuery('records', SqlOperator.SELECT);
q.selectFields = ['username', 'score'];
q.whereEq('username', 'Joe');
q.handler = function(res:SqlQuery):Void {
    trace(res.isSuccess);
    trace(res.rows);
};
db.exec(q);
```

### Select all with order and limit
```haxe
var q = new SqlQuery('records', SqlOperator.SELECT);
q.limit = 5;
q.orderFields = ['score'];
q.order = Order.DESCENDING;
q.handler = function(res:SqlQuery):Void {
    trace(res.isSuccess);
    trace(res.rows);
};
db.exec(q);
```
