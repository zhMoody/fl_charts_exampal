abstract class Serialize {
  int get id;
  Map<String, dynamic> asMap();
}

typedef QueryCallback<T, U> = U Function(T value);

enum Order {
  asc("ASC"),
  desc("DESC"),
  ;

  final String description;

  const Order(this.description);
}
