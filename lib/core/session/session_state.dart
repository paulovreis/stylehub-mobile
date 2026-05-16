import '../config/selected_salon.dart';

class SessionState {
  const SessionState({
    required this.selectedSalon,
    required this.accessToken,
    this.userEmail,
  });

  final SelectedSalon? selectedSalon;
  final String? accessToken;
  final String? userEmail;

  bool get hasSalon => selectedSalon != null;
  bool get isAuthenticated => accessToken != null && accessToken!.isNotEmpty;

  SessionState copyWith({
    SelectedSalon? selectedSalon,
    String? accessToken,
    String? userEmail,
    bool clearSalon = false,
    bool clearToken = false,
    bool clearUserEmail = false,
  }) {
    return SessionState(
      selectedSalon: clearSalon ? null : (selectedSalon ?? this.selectedSalon),
      accessToken: clearToken ? null : (accessToken ?? this.accessToken),
      userEmail: clearUserEmail ? null : (userEmail ?? this.userEmail),
    );
  }
}
