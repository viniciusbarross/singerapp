class LocalSaveException implements Exception {
  final String message;
  LocalSaveException(this.message);
}

class RemoteSaveException implements Exception {
  final String message;
  RemoteSaveException(this.message);
}

class SyncException implements Exception {
  final String message;
  SyncException(this.message);
}

class LocalDeleteException implements Exception {
  final String message;
  LocalDeleteException(this.message);
}

class RemoteDeleteException implements Exception {
  final String message;
  RemoteDeleteException(this.message);
}
