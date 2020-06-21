if defined?(ChefSpec)
  def create_opensshd_server(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sshd_server, :create, resource_name)
  end
end
