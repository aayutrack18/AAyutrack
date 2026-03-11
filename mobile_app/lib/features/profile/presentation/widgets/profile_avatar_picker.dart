import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileAvatarOption {
  final String id;
  final IconData icon;
  final Color color;
  final String label;

  const ProfileAvatarOption({
    required this.id,
    required this.icon,
    required this.color,
    required this.label,
  });
}

class ProfileAvatarPicker extends StatelessWidget {
  final String displayName;
  final String? selectedAvatarId;
  final ValueChanged<String> onAvatarSelected;
  final bool enabled;

  const ProfileAvatarPicker({
    super.key,
    required this.displayName,
    required this.selectedAvatarId,
    required this.onAvatarSelected,
    this.enabled = true,
  });

  static const List<ProfileAvatarOption> avatarOptions = [
    ProfileAvatarOption(
      id: 'blue_person',
      icon: Icons.person_rounded,
      color: Color(0xFF2563EB),
      label: 'Blue',
    ),
    ProfileAvatarOption(
      id: 'teal_health',
      icon: Icons.health_and_safety_rounded,
      color: Color(0xFF0F766E),
      label: 'Health',
    ),
    ProfileAvatarOption(
      id: 'green_face',
      icon: Icons.sentiment_satisfied_alt_rounded,
      color: Color(0xFF16A34A),
      label: 'Green',
    ),
    ProfileAvatarOption(
      id: 'purple_user',
      icon: Icons.account_circle_rounded,
      color: Color(0xFF7C3AED),
      label: 'Purple',
    ),
    ProfileAvatarOption(
      id: 'orange_star',
      icon: Icons.star_rounded,
      color: Color(0xFFEA580C),
      label: 'Star',
    ),
    ProfileAvatarOption(
      id: 'pink_favorite',
      icon: Icons.favorite_rounded,
      color: Color(0xFFDB2777),
      label: 'Favorite',
    ),
  ];

  ProfileAvatarOption get selectedOption {
    return avatarOptions.firstWhere(
      (option) => option.id == selectedAvatarId,
      orElse: () => avatarOptions.first,
    );
  }

  String get initials {
    final parts = displayName
        .trim()
        .split(' ')
        .where((element) => element.trim().isNotEmpty)
        .toList();

    if (parts.isEmpty) return 'P';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final option = selectedOption;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  option.color.withValues(alpha: 0.18),
                  option.color.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: option.color.withValues(alpha: 0.22),
                width: 1.2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  option.icon,
                  size: 46,
                  color: option.color,
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Profile Avatar',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose a placeholder avatar for demo-ready profile presentation. This stays frontend-only for now.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: avatarOptions.map((avatar) {
              final isSelected = avatar.id == option.id;

              return InkWell(
                onTap: enabled ? () => onAvatarSelected(avatar.id) : null,
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 92,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? avatar.color.withValues(alpha: 0.10)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? avatar.color
                          : Colors.black.withValues(alpha: 0.08),
                      width: isSelected ? 1.4 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: avatar.color.withValues(alpha: 0.14),
                        child: Icon(
                          avatar.icon,
                          color: avatar.color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        avatar.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? avatar.color
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
