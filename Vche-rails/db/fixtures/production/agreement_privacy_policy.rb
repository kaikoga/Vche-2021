privacy_policy = <<~PRIVACY_POLICY
  privacy_policy
PRIVACY_POLICY

Agreement.create_or_find_by!(slug: :privacy_policy) do |a|
  a.body = privacy_policy
  a.published_at = '2021-10-01 00:00:00'
  a.effective_at = '2021-10-01 00:00:00'
end


