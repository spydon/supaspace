import 'package:flutter/material.dart';
import 'package:supaspace/game/space_game.dart';

/// Call-sign form shown to a first-time player before they join, and again
/// whenever they choose to change their name from the lobby. The chosen name
/// is persisted, so a returning player skips this screen entirely.
class NameOverlay extends StatefulWidget {
  const NameOverlay({required this.game, super.key});

  final SpaceGame game;

  @override
  State<NameOverlay> createState() => _NameOverlayState();
}

class _NameOverlayState extends State<NameOverlay> {
  static const _maxLength = 10;

  late final TextEditingController _controller = TextEditingController(
    text: widget.game.hasChosenName ? widget.game.player.name : '',
  );

  bool get _isEditing => widget.game.hasChosenName;

  bool get _canSubmit => _controller.text.trim().isNotEmpty;

  void _submit() {
    if (!_canSubmit) {
      return;
    }
    widget.game.submitName(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: _Panel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Title(_isEditing ? 'CHANGE CALL SIGN' : 'CHOOSE YOUR CALL SIGN'),
              const SizedBox(height: 6),
              Text(
                'This is the name other pilots see',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: 280,
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLength: _maxLength,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _submit(),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Enter a call sign',
                    counterText: '',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF66E0FF)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _PrimaryButton(
                label: _isEditing ? 'SAVE' : 'CONTINUE',
                enabled: _canSubmit,
                onPressed: _submit,
              ),
              if (_isEditing) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: widget.game.cancelNameEditor,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white.withValues(alpha: 0.6),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// shared styling, kept consistent with the lobby panel ------------------------

class _Panel extends StatelessWidget {
  const _Panel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 36),
      constraints: const BoxConstraints(maxWidth: 460),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0C1A).withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF66E0FF).withValues(alpha: 0.12),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF66E0FF), Color(0xFFB388FF)],
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          letterSpacing: 4,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: enabled
            ? const LinearGradient(
                colors: [Color(0xFF66E0FF), Color(0xFFB388FF)],
              )
            : null,
        color: enabled ? null : Colors.white.withValues(alpha: 0.08),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: const Color(0xFF66E0FF).withValues(alpha: 0.5),
                  blurRadius: 18,
                ),
              ]
            : null,
      ),
      child: TextButton(
        onPressed: enabled ? onPressed : null,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 14),
          foregroundColor: Colors.black,
          disabledForegroundColor: Colors.white.withValues(alpha: 0.3),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
