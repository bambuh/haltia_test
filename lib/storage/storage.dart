abstract interface class Storage<T> {
  Stream<List<T>> get allItemsStream;
  Future<void> initialize();
  Future<void> insert(T item);
  Future<List<T>> getAll();
  Future<T> getById(String id);
}
