import 'package:flutter_test/flutter_test.dart';
import 'package:stylehub_mobile/features/profile/domain/me_profile.dart';

void main() {
  test('MeProfile.parse reads flat payload', () {
    final p = MeProfile.parse({
      'id': 7,
      'name': 'Ana',
      'email': 'ana@example.com',
      'phone': '+55 11 99999-0000',
    });

    expect(p.id, 7);
    expect(p.name, 'Ana');
    expect(p.email, 'ana@example.com');
    expect(p.phone, '+55 11 99999-0000');
  });

  test('MeProfile.parse tolerates envelope', () {
    final p = MeProfile.parse({
      'data': {
        'user_id': '42',
        'full_name': 'Bruno',
        'mail': 'bruno@example.com',
        'phone_number': '11999990000',
      },
    });

    expect(p.id, 42);
    expect(p.name, 'Bruno');
    expect(p.email, 'bruno@example.com');
    expect(p.phone, '11999990000');
  });
}
