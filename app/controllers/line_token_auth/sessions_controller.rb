module LineTokenAuth
  class SessionsController < DeviseTokenAuth::SessionsController
    include LineTokenAuth::Concerns::LineAuthenticator

    def create
      # Check
      field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first
      @resource = nil
      if field
        q_value = get_case_insensitive_field_from_resource_params(field)
        @resource = find_resource(field, q_value)
      end

      if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        auth_result = authenticate(@resource[field], resource_params[:access_token])
        if auth_result[:error]
          return render_error(auth_result[:error][:code], auth_result[:error][:message])
        end

        @token = @resource.create_token
        @resource.save

        sign_in(:user, @resource, store: false, bypass: false)

        yield @resource if block_given?

        render_create_success
      elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        if @resource.respond_to?(:locked_at) && @resource.locked_at
          render_create_error_account_locked
        else
          render_create_error_not_confirmed
        end
      else
        render_create_error_bad_credentials
      end
    end
    def valid_params?(key, val)
      resource_params[:access_token] && key && val
    end
    def provider
      'line'
    end
  end
end
