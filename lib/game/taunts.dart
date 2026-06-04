import 'dart:math';

/// The taunt emojis offered in the HUD and the pool of random phrases shown
/// under one when it is played.
class Taunts {
  Taunts._();

  static const emojis = ['😎', '🤣', '💀', '👽', '🔥', '🖖'];

  static const _phrases = [
    'Too slow!',
    'Eat stardust!',
    'Is that all?',
    'Outgunned!',
    'Skill issue!',
    'Catch me!',
    'Boom!',
    'GG EZ',
    'Better luck next time!',
    'See ya!',
    'Nice try!',
    'Was that on purpose?',
    'Blame the lag, not your aim',
    'Yoinked your planet!',
    'Houston, you have a problem',
    'Resistance is futile',
    'Did you unplug the mouse?',
    'I learned this from a tutorial',
    'Stay in orbit, rookie',
    'Pew pew, get good',
    'You sound like a free trial',
    'To infinity and... bye!',
    'My other ship is a banana 🍌',
    "It's never Copple.",
  ];

  static final _random = Random();

  static String randomPhrase() => _phrases[_random.nextInt(_phrases.length)];
}
