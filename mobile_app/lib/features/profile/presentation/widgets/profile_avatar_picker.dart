import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import 'section_title.dart';

class ProfileAvatarOption {
  final String id;
  final String emoji;
  final String label;

  const ProfileAvatarOption({
    required this.id,
    required this.emoji,
    required this.label,
  });
}

class ProfileAvatarPicker extends StatelessWidget {
  final String displayName;
  final String selectedAvatarId;
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
      id: 'avatar_1',
      emoji: '🧑',
      label: 'Default',
    ),
    ProfileAvatarOption(
      id: 'avatar_2',
      emoji: '👨',
      label: 'Male 1',
    ),
    ProfileAvatarOption(
      id: 'avatar_3',
      emoji: '👩',
      label: 'Female 1',
    ),
    ProfileAvatarOption(
      id: 'avatar_4',
      emoji: '🧔',
      label: 'Male 2',
    ),
    ProfileAvatarOption(
      id: 'avatar_5',
      emoji: '👩‍⚕️',
      label: 'Female 2',
    ),
    ProfileAvatarOption(
      id: 'avatar_6',
      emoji: '👨‍⚕️',
      label: 'Doctor Style',
    ),
    ProfileAvatarOption(
      id: 'avatar_7',
      emoji: '🙂',
      label: 'Simple',
    ),
    ProfileAvatarOption(
      id: 'avatar_8',
      emoji: '😊',
      label: 'Friendly',
    ),
  ];

  ProfileAvatarOption get _selectedOption {
    return avatarOptions.firstWhere(
      (option) => option.id == selectedAvatarId,
      orElse: () => avatarOptions.first,
    );
  }

  String _buildInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'P';

    final parts = trimmed.split(' ').where((e) => e.isNotEmpty).toList();

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
    final selectedOption = _selectedOption;
    final initials = _buildInitials(displayName);

    return Opacity(
      opacity: enabled ? 1 : 0.72,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.05),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: 'Profile Avatar',
              subtitle: 'Choose a frontend preview avatar for demo purposes',
              icon: Icons.account_circle_outlined,
            ),
            const SizedBox(height: 4),
            _AvatarPreviewCard(
              emoji: selectedOption.emoji,
              initials: initials,
              displayName: displayName.trim().isEmpty
                  ? 'Patient Name Preview'
                  : displayName.trim(),
              label: selectedOption.label,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.18),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This avatar is currently UI preview only. Real image upload or backend storage is not connected yet.',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose an avatar',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 420 ? 4 : 3;
                final itemWidth =
                    (width - ((crossAxisCount - 1) * 12)) / crossAxisCount;
                final childAspectRatio = itemWidth / 92;

                return GridView.builder(
                  itemCount: avatarOptions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final option = avatarOptions[index];
                    final isSelected = option.id == selectedAvatarId;

                    return _AvatarOptionTile(
                      option: option,
                      isSelected: isSelected,
                      enabled: enabled,
                      onTap: () {
                        if (!enabled) return;
                        onAvatarSelected(option.id);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarPreviewCard extends StatelessWidget {
  final String emoji;
  final String initials;
  final String displayName;
  final String label;

  const _AvatarPreviewCard({
    required this.emoji,
    required this.initials,
    required this.displayName,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 76,
                width: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.16),
                ),
              ),
              Text(
                emoji,
                style: const TextStyle(fontSize: 30),
              ),
              Positioned(
                bottom: 2,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Selected style: $label',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.18),
                    ),
                  ),
                  child: const Text(
                    'Preview Active',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarOptionTile extends StatelessWidget {
  final ProfileAvatarOption option;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  const _AvatarOptionTile({
    required this.option,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isSelected ? AppColors.primary : Colors.black.withValues(alpha: 0.06);
    final backgroundColor = isSelected
        ? AppColors.primary.withValues(alpha: 0.08)
        : Theme.of(context).cardColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      option.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
