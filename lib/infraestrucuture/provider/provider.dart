
import 'package:popcorntime/domain/entities/user.dart';

class UserProvider {
  static User? currentUser;

  static void setUser(User user) {
    currentUser = user;
  }

  static void clearUser() {
    currentUser = null;
  }
}
