/// Data models for the Cardify activity.
///
/// This file is provided — do not modify it.
library;

// ---------------------------------------------------------------------------
// Deck
// ---------------------------------------------------------------------------

/// A named collection of [Flashcard]s stored in the SQLite database.
class Deck {
  const Deck({this.id, required this.title, required this.category});

  /// Database primary key. `null` for a [Deck] that has not yet been saved.
  final int? id;

  /// Human-readable name shown in the deck list.
  final String title;

  /// Broad subject tag (e.g. `'Programming'`, `'Computer Science'`).
  final String category;

  // ---- ORM helpers ----------------------------------------------------------

  factory Deck.fromMap(Map<String, dynamic> m) => Deck(
        id: m['id'] as int?,
        title: m['title'] as String,
        category: m['category'] as String,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'title': title,
        'category': category,
      };

  Deck copyWith({int? id, String? title, String? category}) => Deck(
        id: id ?? this.id,
        title: title ?? this.title,
        category: category ?? this.category,
      );

  @override
  String toString() => 'Deck(id: $id, title: $title, category: $category)';
}

// ---------------------------------------------------------------------------
// Flashcard
// ---------------------------------------------------------------------------

/// A single question/answer card belonging to a [Deck].
class Flashcard {
  const Flashcard({
    this.id,
    required this.deckId,
    required this.front,
    required this.back,
  });

  /// Database primary key. `null` for a [Flashcard] not yet saved.
  final int? id;

  /// Foreign key referencing [Deck.id].
  final int deckId;

  /// The question or prompt shown face-up.
  final String front;

  /// The answer shown after the card is flipped.
  final String back;

  // ---- ORM helpers ----------------------------------------------------------

  factory Flashcard.fromMap(Map<String, dynamic> m) => Flashcard(
        id: m['id'] as int?,
        deckId: m['deck_id'] as int,
        front: m['front'] as String,
        back: m['back'] as String,
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'deck_id': deckId,
        'front': front,
        'back': back,
      };

  Flashcard copyWith({int? id, int? deckId, String? front, String? back}) =>
      Flashcard(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        front: front ?? this.front,
        back: back ?? this.back,
      );

  @override
  String toString() =>
      'Flashcard(id: $id, deckId: $deckId, front: $front)';
}

// ---------------------------------------------------------------------------
// DeckTemplate
// ---------------------------------------------------------------------------

/// A deck-plus-cards definition loaded from [assets/decks.yaml] or
/// [documents/decks.json].  Templates are not stored in SQLite; they live in
/// the file-based library managed by [DeckStore].
class DeckTemplate {
  const DeckTemplate({
    required this.title,
    required this.category,
    required this.cards,
  });

  final String title;
  final String category;

  /// Ordered list of front/back pairs for this template's cards.
  final List<CardTemplate> cards;

  // ---- JSON helpers (used by DeckStore) ------------------------------------

  factory DeckTemplate.fromMap(Map<String, dynamic> m) => DeckTemplate(
        title: m['title'] as String,
        category: m['category'] as String,
        cards: (m['cards'] as List)
            .map((c) => CardTemplate.fromMap(c as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'category': category,
        'cards': cards.map((c) => c.toMap()).toList(),
      };
}

// ---------------------------------------------------------------------------
// CardTemplate
// ---------------------------------------------------------------------------

/// A single front/back pair inside a [DeckTemplate].
class CardTemplate {
  const CardTemplate({required this.front, required this.back});

  final String front;
  final String back;

  factory CardTemplate.fromMap(Map<String, dynamic> m) => CardTemplate(
        front: m['front'] as String,
        back: m['back'] as String,
      );

  Map<String, dynamic> toMap() => {'front': front, 'back': back};
}

// ---------------------------------------------------------------------------
// DeckWithCount
// ---------------------------------------------------------------------------

/// A [Deck] annotated with the number of [Flashcard]s it contains.
/// Returned by [DeckProvider.getAllWithCount] (bonus exercise).
class DeckWithCount {
  const DeckWithCount({required this.deck, required this.cardCount});

  final Deck deck;
  final int cardCount;
}
