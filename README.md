# under construction
This project is in the initial stage of development. Most of the functionality is still planned.

# usage example
```haxe
// create or open database
var db = new Database("TestDB");

// create table
var tr1 = new Transaction(db);
tr1.addQuery( new SqlQuery('CREATE TABLE IF NOT EXISTS records (username, score)') );
tr1.exec();

// add two rows
var tr2 = new Transaction(db);
var q1 = new SqlQuery('records', SqlOperator.INSERT);
q1.set('username', 'Bob');
q1.set('score', 123);
tr2.addQuery(q1);

var q2 = new SqlQuery('records', SqlOperator.INSERT);
q2.set('username', 'Joe');
q2.set('score', 456);
tr2.addQuery(q2);

tr2.exec();

// using method "mset"
var tr3 = new Transaction(db);
var q3 = new SqlQuery('records', SqlOperator.INSERT);
q3.mset({username: 'Peter', score: 675});
tr3.addQuery( q3 );
tr3.exec();
		
```
