import 'package:flutter/material.dart';
import 'package:supaspace/game/settings_service.dart';

/// Opens the settings menu, where background music and sound effects can be
/// toggled. The toggles are bound to [SettingsService], so changes apply
/// immediately and persist between sessions.
Future<void> showSettingsDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _SettingsDialog(),
  );
}

class _SettingsDialog extends StatelessWidget {
  const _SettingsDialog();

  @override
  Widget build(BuildContext context) {
    final settings = SettingsService.instance;
    return Dialog(
      backgroundColor: const Color(0xFF0A0C1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'SETTINGS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 12),
              _ToggleRow(
                label: 'Music',
                onIcon: Icons.music_note,
                offIcon: Icons.music_off,
                notifier: settings.musicEnabled,
              ),
              _ToggleRow(
                label: 'Sound Effects',
                onIcon: Icons.volume_up,
                offIcon: Icons.volume_off,
                notifier: settings.sfxEnabled,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF66E0FF),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.onIcon,
    required this.offIcon,
    required this.notifier,
  });

  final String label;
  final IconData onIcon;
  final IconData offIcon;
  final ValueNotifier<bool> notifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: notifier,
      builder: (context, enabled, _) => SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: Icon(
          enabled ? onIcon : offIcon,
          color: enabled ? const Color(0xFF66E0FF) : Colors.white38,
        ),
        title: Text(label, style: const TextStyle(color: Colors.white)),
        value: enabled,
        activeThumbColor: const Color(0xFF66E0FF),
        onChanged: (value) => notifier.value = value,
      ),
    );
  }
}
