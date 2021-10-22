class OauthsLoyalty < ApplicationLoyalty
  def oauth?
    true
  end

  def callback?
    true
  end
end
