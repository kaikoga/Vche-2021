Flavor.create_or_find_by(
  emoji: '🔰',
  slug: 'beginner',
  name: '初心者向け',
  taste: :general,
  available: true
)

Flavor.create_or_find_by(
  emoji: '👘',
  slug: 'avatar',
  name: 'アバター集会',
  taste: :general,
  available: true
)

Flavor.create_or_find_by(
  emoji: '🏢',
  slug: 'group',
  name: 'バーチャル団体',
  taste: :general,
  available: true
)

Flavor.create_or_find_by(
  emoji: '🍺',
  slug: 'drinking',
  name: 'VR飲み会',
  taste: :general,
  available: true
)

Flavor.create_or_find_by(
  emoji: '🎶',
  slug: 'music',
  name: '音楽イベント',
  taste: :general,
  available: true
)

Flavor.create_or_find_by(
  emoji: '⚔️',
  slug: 'roleplaying',
  name: 'ロールプレイ',
  taste: :general,
  available: true
)

Flavor.create_or_find_by(
  emoji: '🎨',
  slug: 'creator',
  name: 'クリエイター',
  taste: :general,
  available: true
)

Flavor.create_or_find_by(
  emoji: '👑',
  slug: 'personal',
  name: '個人イベント',
  taste: :private,
  available: true
)

Flavor.create_or_find_by(
  emoji: '🎂',
  slug: 'birthday',
  name: '誕生会',
  taste: :private,
  available: true
)

Flavor.create_or_find_by(
  emoji: '🏠',
  slug: 'small',
  name: '少人数イベント',
  taste: :private,
  available: true
)

Flavor.create_or_find_by(
  emoji: '☎️',
  slug: 'reservation',
  name: '要予約',
  taste: :restricted,
  available: true
)

Flavor.create_or_find_by(
  emoji: '🍷️',
  slug: 'mature',
  name: '大人向け',
  taste: :mature,
  available: true
)

Flavor.create_or_find_by(
  emoji: '❤️',
  slug: 'nsfw',
  name: 'NSFW',
  taste: :mature,
  available: false
)
