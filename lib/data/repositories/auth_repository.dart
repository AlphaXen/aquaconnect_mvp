import '../models/member.dart';

class AuthSession {
  const AuthSession({required this.member, required this.organization});

  final Member member;
  final Organization organization;
}

abstract class AuthRepository {
  Stream<AuthSession?> authStateChanges();

  AuthSession? get currentSession;

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();
}
