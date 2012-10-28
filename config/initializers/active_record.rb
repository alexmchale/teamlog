class ActiveRecord::Base

  # All ActiveRecord objects should forbid passing the params hash straight into them.
  include ActiveModel::ForbiddenAttributesProtection

end
