import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:aayutrack/core/theme/app_theme.dart';
import 'package:aayutrack/core/widgets/app_widgets.dart';
import 'package:aayutrack/features/profile/presentation/providers/profile_provider.dart';

class SosEmergencyScreen extends ConsumerStatefulWidget {
  const SosEmergencyScreen({super.key});

  @override
  ConsumerState<SosEmergencyScreen> createState() => _SosEmergencyScreenState();
}

class _SosEmergencyScreenState extends ConsumerState<SosEmergencyScreen> {
  bool _isCalling112 = false;
  bool _isCallingContact = false;
  bool _isSendingSms = false;
  bool _isFetchingLocation = false;
  bool _isOpeningMap = false;
  bool _isSharingLocation = false;

  Position? _currentPosition;
  String? _locationError;
  DateTime? _lastLocationUpdated;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _launchUri(
    Uri uri, {
    required String errorMessage,
  }) async {
    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!success && mounted) {
      _showError(errorMessage);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _digitsOnly(String input) {
    return input.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  String _buildGoogleMapsLink(Position? position) {
    if (position == null) return 'Not available';
    return 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
  }

  String _buildLocationSummary(Position? position) {
    if (position == null) return 'Location not available';
    return 'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
  }

  String _buildSosMessage({
    required String patientName,
    required String bloodGroup,
    required String address,
    required String medicalConditions,
    required String allergies,
    required String phoneNumber,
    required Position? position,
  }) {
    final now = DateTime.now();
    final mapsLink = _buildGoogleMapsLink(position);
    final locationSummary = _buildLocationSummary(position);

    return 'SOS ALERT from AAYUTRACK.\n'
        'Patient: $patientName\n'
        'Phone: ${phoneNumber.isEmpty ? 'Not available' : phoneNumber}\n'
        'Blood Group: ${bloodGroup.isEmpty ? 'Not available' : bloodGroup}\n'
        'Address: ${address.isEmpty ? 'Not available' : address}\n'
        'Medical Conditions: ${medicalConditions.isEmpty ? 'Not available' : medicalConditions}\n'
        'Allergies: ${allergies.isEmpty ? 'Not available' : allergies}\n'
        'Time: ${_formatDateTime(now)}\n'
        'Current Location: $locationSummary\n'
        'Map Link: $mapsLink\n'
        'Please contact urgently.';
  }

  Future<void> _loadCurrentLocation() async {
    if (_isFetchingLocation) return;

    setState(() {
      _isFetchingLocation = true;
      _locationError = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location service is turned off. Please enable GPS.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          _locationError = 'Location permission denied.';
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError =
              'Location permission permanently denied. Enable it from app settings.';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
        _lastLocationUpdated = DateTime.now();
        _locationError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locationError = 'Unable to fetch current location.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingLocation = false;
        });
      }
    }
  }

  Future<void> _call112() async {
    if (_isCalling112) return;

    setState(() => _isCalling112 = true);

    try {
      await _launchUri(
        Uri(scheme: 'tel', path: '112'),
        errorMessage: 'Unable to open dialer for 112.',
      );
    } finally {
      if (mounted) {
        setState(() => _isCalling112 = false);
      }
    }
  }

  Future<void> _callEmergencyContact(String phone) async {
    if (_isCallingContact) return;

    final sanitized = _digitsOnly(phone);
    if (sanitized.isEmpty) {
      _showError('Emergency contact number is missing.');
      return;
    }

    setState(() => _isCallingContact = true);

    try {
      await _launchUri(
        Uri(scheme: 'tel', path: sanitized),
        errorMessage: 'Unable to open dialer for emergency contact.',
      );
    } finally {
      if (mounted) {
        setState(() => _isCallingContact = false);
      }
    }
  }

  Future<void> _sendSosSms({
    required String phone,
    required String message,
  }) async {
    if (_isSendingSms) return;

    final sanitized = _digitsOnly(phone);
    if (sanitized.isEmpty) {
      _showError('Emergency contact number is missing.');
      return;
    }

    setState(() => _isSendingSms = true);

    try {
      final smsUri = Uri(
        scheme: 'sms',
        path: sanitized,
        queryParameters: <String, String>{
          'body': message,
        },
      );

      await _launchUri(
        smsUri,
        errorMessage: 'Unable to open SMS app.',
      );
    } finally {
      if (mounted) {
        setState(() => _isSendingSms = false);
      }
    }
  }

  Future<void> _copyEmergencyMessage(String message) async {
    await Clipboard.setData(ClipboardData(text: message));

    if (!mounted) return;
    _showSuccess('Emergency message copied.');
  }

  Future<void> _openCurrentLocationInMaps() async {
    if (_isOpeningMap) return;

    if (_currentPosition == null) {
      _showError('Current location is not available yet.');
      return;
    }

    setState(() => _isOpeningMap = true);

    try {
      await _launchUri(
        Uri.parse(_buildGoogleMapsLink(_currentPosition)),
        errorMessage: 'Unable to open Google Maps.',
      );
    } finally {
      if (mounted) {
        setState(() => _isOpeningMap = false);
      }
    }
  }

  Future<void> _shareCurrentLocation({
    required String patientName,
    required String phoneNumber,
  }) async {
    if (_isSharingLocation) return;

    if (_currentPosition == null) {
      _showError('Current location is not available yet.');
      return;
    }

    setState(() => _isSharingLocation = true);

    try {
      final text = 'Emergency location from AAYUTRACK\n'
          'Patient: $patientName\n'
          'Phone: ${phoneNumber.isEmpty ? 'Not available' : phoneNumber}\n'
          'Location: ${_buildLocationSummary(_currentPosition)}\n'
          'Map Link: ${_buildGoogleMapsLink(_currentPosition)}';

      await Share.share(text);
    } catch (_) {
      if (mounted) {
        _showError('Unable to share location.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSharingLocation = false);
      }
    }
  }

  Future<void> _openAppSettingsForLocation() async {
    final opened = await Geolocator.openAppSettings();
    if (!mounted) return;

    if (!opened) {
      _showError('Unable to open app settings.');
    }
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: const Icon(
              Icons.sos_rounded,
              size: 38,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Emergency Help',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fast access to emergency calling, SOS messaging, and live location sharing for critical response.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isCalling112 ? null : _call112,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.danger,
                minimumSize: const Size(double.infinity, 56),
              ),
              icon: _isCalling112
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.danger,
                      ),
                    )
                  : const Icon(Icons.call_rounded),
              label: const Text('Call Emergency 112'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStatusCard() {
    final hasLocation = _currentPosition != null;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Location',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                hasLocation
                    ? Icons.my_location_rounded
                    : Icons.location_off_rounded,
                color: hasLocation ? AppColors.primary : AppColors.danger,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _locationError ??
                      (hasLocation
                          ? _buildLocationSummary(_currentPosition)
                          : 'Fetching current location...'),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          if (_lastLocationUpdated != null) ...[
            const SizedBox(height: 10),
            Text(
              'Updated: ${_formatDateTime(_lastLocationUpdated!)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Refresh Location',
                  icon: Icons.refresh_rounded,
                  outlined: true,
                  onPressed: _isFetchingLocation ? null : _loadCurrentLocation,
                  isLoading: _isFetchingLocation,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Open in Maps',
                  icon: Icons.map_rounded,
                  onPressed: _isOpeningMap ? null : _openCurrentLocationInMaps,
                  isLoading: _isOpeningMap,
                ),
              ),
            ],
          ),
          if (_locationError != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _openAppSettingsForLocation,
                icon: const Icon(Icons.settings_rounded),
                label: const Text('Open App Settings'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profile = profileState.profile;

    final patientName = profile?.fullName ?? 'Patient';
    final bloodGroup = profile?.bloodGroup ?? '';
    final address = profile?.address ?? '';
    final medicalConditions = profile?.medicalConditions ?? '';
    final allergies = profile?.allergies ?? '';
    final phoneNumber = profile?.phoneNumber ?? '';
    final emergencyContactName =
        profile?.emergencyContactName ?? 'Emergency Contact';
    final emergencyContactPhone = profile?.emergencyContactPhone ?? '';

    final sosMessage = _buildSosMessage(
      patientName: patientName,
      bloodGroup: bloodGroup,
      address: address,
      medicalConditions: medicalConditions,
      allergies: allergies,
      phoneNumber: phoneNumber,
      position: _currentPosition,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SOS Emergency'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeroCard(),
              const SizedBox(height: 16),
              _buildLocationStatusCard(),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _InfoRow(
                      icon: Icons.person_rounded,
                      label: 'Name',
                      value: emergencyContactName.isEmpty
                          ? 'Not added in profile'
                          : emergencyContactName,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.call_rounded,
                      label: 'Phone',
                      value: emergencyContactPhone.isEmpty
                          ? 'Not added in profile'
                          : emergencyContactPhone,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Call Contact',
                            icon: Icons.call_rounded,
                            backgroundColor: AppColors.danger,
                            onPressed: _isCallingContact
                                ? null
                                : () => _callEmergencyContact(
                                      emergencyContactPhone,
                                    ),
                            isLoading: _isCallingContact,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            label: 'Send SOS SMS',
                            icon: Icons.sms_rounded,
                            outlined: true,
                            onPressed: _isSendingSms
                                ? null
                                : () => _sendSosSms(
                                      phone: emergencyContactPhone,
                                      message: sosMessage,
                                    ),
                            isLoading: _isSendingSms,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Share Current Location',
                      icon: Icons.share_location_rounded,
                      outlined: true,
                      onPressed: _isSharingLocation
                          ? null
                          : () => _shareCurrentLocation(
                                patientName: patientName,
                                phoneNumber: phoneNumber,
                              ),
                      isLoading: _isSharingLocation,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Patient Emergency Summary',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _InfoRow(
                      icon: Icons.badge_rounded,
                      label: 'Patient',
                      value: patientName,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.bloodtype_rounded,
                      label: 'Blood Group',
                      value: bloodGroup.isEmpty ? 'Not available' : bloodGroup,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.phone_rounded,
                      label: 'Phone',
                      value:
                          phoneNumber.isEmpty ? 'Not available' : phoneNumber,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.location_on_rounded,
                      label: 'Address',
                      value: address.isEmpty ? 'Not available' : address,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.health_and_safety_rounded,
                      label: 'Conditions',
                      value: medicalConditions.isEmpty
                          ? 'Not available'
                          : medicalConditions,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.warning_amber_rounded,
                      label: 'Allergies',
                      value: allergies.isEmpty ? 'Not available' : allergies,
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      icon: Icons.map_rounded,
                      label: 'Map Link',
                      value: _currentPosition == null
                          ? 'Not available'
                          : _buildGoogleMapsLink(_currentPosition),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SOS Message Preview',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        sosMessage,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Copy Message',
                            icon: Icons.copy_rounded,
                            outlined: true,
                            onPressed: () => _copyEmergencyMessage(sosMessage),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            label: 'Open Map Link',
                            icon: Icons.open_in_new_rounded,
                            onPressed:
                                _isOpeningMap ? null : _openCurrentLocationInMaps,
                            isLoading: _isOpeningMap,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primary,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}