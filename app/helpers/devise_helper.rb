module DeviseHelper
   def devise_error_messages!
      return nil if resource.errors.empty?

      return resource.errors.full_messages.map { |msg|  msg }.join(',  ')
   end
end