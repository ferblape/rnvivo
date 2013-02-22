class String
  def blank?
    self !~ /[^[:space:]]/
  end
end
