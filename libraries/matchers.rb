if defined?(ChefSpec)
  def create_opensshd_server(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:openssh_server, :create, resource_name)
  end
end
