class InMemoryStore{
  late dynamic _category;

  Future<void> addCategory(dynamic category){
    return Future.microtask(() => _category = category);
  }

  Future<dynamic> getCategory(){
    return Future.microtask(() => _category);
  }
}