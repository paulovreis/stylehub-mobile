import '../config/selected_salon.dart';

class SessionState {
  const SessionState({
    required this.selectedSalon,
    required this.accessToken,
  });

  final SelectedSalon? selectedSalon;
  final String? accessToken;

  bool get hasSalon => selectedSalon != null;
  bool get isAuthenticated => accessToken != null && accessToken!.isNotEmpty;

  SessionState copyWith({
    SelectedSalon? selectedSalon,
    String? accessToken,
    bool clearSalon = false,
    bool clearToken = false,
  }) {
    return SessionState(
      selectedSalon: clearSalon ? null : (selectedSalon ?? this.selectedSalon),
      accessToken: clearToken ? null : (accessToken ?? this.accessToken),
    );
  }
}
