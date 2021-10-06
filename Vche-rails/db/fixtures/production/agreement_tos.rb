tos = <<~TOS
  tos
TOS

Agreement.create_or_find_by!(slug: :tos) do |a|
  a.body = tos
  a.published_at = '2021-10-01 00:00:00'
  a.effective_at = '2021-10-01 00:00:00'
end


