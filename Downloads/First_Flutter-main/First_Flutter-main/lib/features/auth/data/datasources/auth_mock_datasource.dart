import '../models/user_model.dart';
import '../../../../core/errors/exceptions.dart';

/// Mock data source for demo/testing purposes
/// Simulates API responses without requiring a real backend
class AuthMockDataSource {
  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<UserModel> login(String email, String password) async {
    await _simulateDelay();
    
    // Simulate validation
    if (email.isEmpty || password.isEmpty) {
      throw ServerException('Email and password are required', 400);
    }
    
    // Mock successful login
    return UserModel(
      id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: email.split('@')[0], // Use email prefix as name
      phoneNumber: null,
      profileImageUrl: null,
    );
  }

  Future<UserModel> register(String email, String password, String name) async {
    await _simulateDelay();
    
    // Simulate validation
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw ServerException('All fields are required', 400);
    }
    
    if (password.length < 6) {
      throw ServerException('Password must be at least 6 characters', 400);
    }
    
    // Mock successful registration
    return UserModel(
      id: 'demo_user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      phoneNumber: null,
      profileImageUrl: null,
    );
  }

  Future<void> logout(String token) async {
    await _simulateDelay();
    // Mock successful logout
  }
}

