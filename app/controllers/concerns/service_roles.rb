module ServiceRoles
  extend ActiveSupport::Concern

  def set_roles
    @roles = Service.roles.keys
  end
end
