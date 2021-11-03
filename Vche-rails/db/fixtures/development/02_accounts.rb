vrchat_pc = Platform.find_by!(slug: :vrchat_pc)

Account.create_or_find_by(
  display_name: 'kaikoga',
  platform: vrchat_pc,
  url: 'kaikogakaikoga',
  user: User.find_by!(email: 'kaikoga')
)
