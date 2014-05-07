class Twitter::User
  def user_id
    self.ac_account.valueForKeyPath("properties")["user_id"]
  end
end