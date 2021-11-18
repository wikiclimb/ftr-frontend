/// General catch-all exception type, try to use a more concrete class.
class ApplicationException implements Exception {}

/// There was an error recovering local data.
class CacheException implements Exception {}

/// There was an error on the network.
class NetworkException implements Exception {}

/// There was an error on the server.
class ServerException implements Exception {}

/// You need to authenticate to do that operation.
class UnauthorizedException implements Exception {}

/// The current user is not allowed to do that operation.
class ForbiddenException implements Exception {}
