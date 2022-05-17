//login exceptions

class UserNotFoundAuthException implements Exception{}
class WrongPasswordAuthException implements Exception{}

//register excwptions

class WeaPasswordAuthException implements Exception{}
class EmailAlreadyInAuthException implements Exception{}
class InvalidEmailAuthException implements Exception{}

//generic exceptions

class GenericAuthException implements Exception{}

class UserNotLoggedInAuthException implements Exception{}