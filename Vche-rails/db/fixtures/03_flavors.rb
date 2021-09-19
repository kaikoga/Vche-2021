Flavor.create_or_find_by(
  emoji: '🔰',
  slug: 'beginner',
  name: '初心者向け',
  taste: :welcome,
  available: true
)

Flavor.create_or_find_by(
  emoji: '👘',
  slug: 'avatar',
  name: 'アバター集会',
  taste: :welcome,
  available: true
)

Flavor.create_or_find_by(
  emoji: '🏢',
  slug: 'group',
  name: 'バーチャル団体',
  taste: :welcome,
  available: true
)

Flavor.create_or_find_by(
  emoji: '🍺',
  slug: 'drinking',
  name: 'VR飲み会',
  taste: :welcome,
  available: true
)

Flavor.create_or_find_by(
  emoji: '🎶',
  slug: 'music',
  name: '音楽イベント',
  taste: :welcome,
  available: true
)

Flavor.create_or_find_by(
  emoji: '⚔️',
  slug: 'roleplaying',
  name: 'ロールプレイ',
  taste: :welcome,
  available: true
)

Flavor.create_or_find_by(
  emoji: '🎨',
  slug: 'creator',
  name: 'クリエイター',
  taste: :welcome,
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
  taste: :isolated,
  available: true
)

Flavor.create_or_find_by(
  emoji: '❤️',
  slug: 'nsfw',
  name: 'NSFW',
  taste: :isolated,
  available: false
)
