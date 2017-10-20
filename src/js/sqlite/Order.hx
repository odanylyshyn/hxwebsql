package js.sqlite;

@:enum
abstract Order(String) {
    var ASCENDING = "asc";
    var DESCENDING = "desc";
}