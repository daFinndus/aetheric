// This class is used for displaying more user friendly exceptions
class AuthExceptions {
  Map<String, String> errors = {
    "invalid-email": "The email address is not valid",
    "invalid-password": "Wrong password provided for that user",
    "invalid-credential": "The credentials seem wrong or non-existent",
    "INVALID_LOGIN_CREDENTIALS": "The credentials seem wrong or non-existent",
    "wrong-password": "Your password seems wrong, try again",
    "email-already-exists": "The email address is already in use",
    "uid-already-exists": "The user id is already in use",
    "user-not-found": "No user found for that email",
    "internal-error": "Something went wrong with our server",
    "too-many-requests": "Too many requests, try again later",
  };
}
