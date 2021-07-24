Flavor.create_or_find_by(
  emoji: '👗',
  slug: 'avatar_tryon',
  name: 'アバター試着会',
  taste: :general
)

Flavor.create_or_find_by(
  emoji: '🐱',
  slug: 'avatar_meeting',
  name: 'アバター集会',
  taste: :general
)

Flavor.create_or_find_by(
  emoji: '💬',
  slug: 'other_meeting',
  name: 'その他交流会',
  taste: :general
)

Flavor.create_or_find_by(
  emoji: '🍺',
  slug: 'vr_drinking',
  name: 'VR飲み会',
  taste: :general
)

Flavor.create_or_find_by(
  emoji: '☕️',
  slug: 'cafe',
  name: 'カフェイベント',
  taste: :general
)

Flavor.create_or_find_by(
  emoji: '🎶',
  slug: 'music',
  name: '音楽イベント',
  taste: :general
)

Flavor.create_or_find_by(
  emoji: '⚔',
  slug: 'roleplaying',
  name: 'ロールプレイ',
  taste: :general
)

Flavor.create_or_find_by(
  emoji: '🔰',
  slug: 'beginner',
  name: '初心者向けイベント',
  taste: :general
)

Flavor.create_or_find_by(
  emoji: '🔄',
  slug: 'regular',
  name: '定期イベント',
  taste: :general
)

##----

Flavor.create_or_find_by(
  emoji: '👾',
  slug: 'game',
  name: 'ゲームイベント',
  taste: :general
)

Flavor.create_or_find_by(
  emoji: '🖥',
  slug: 'hackathon',
  name: 'ハッカソン',
  taste: :general
)

Flavor.create_or_find_by(
  emoji: '🎂',
  slug: 'birthday',
  name: '誕生会',
  taste: :private
)

Flavor.create_or_find_by(
  emoji: '👑',
  slug: 'personal',
  name: '個人イベント',
  taste: :private
)

Flavor.create_or_find_by(
  emoji: '🕴',
  slug: 'small',
  name: '少人数イベント',
  taste: :private
)

Flavor.create_or_find_by(
  emoji: '☎️',
  slug: 'reservation',
  name: '予約制イベント',
  taste: :restricted
)

Flavor.create_or_find_by(
  emoji: '💳️',
  slug: 'members',
  name: '会員制イベント',
  taste: :restricted
)

Flavor.create_or_find_by(
  emoji: '❤️️',
  slug: 'mature',
  name: '大人向けイベント',
  taste: :mature
)
