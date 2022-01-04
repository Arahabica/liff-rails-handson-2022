module LineTokenAuth
  # DeviseTokenAuthのコントローラを継承している
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    include LineTokenAuth::Concerns::LineAuthenticator

    def create
      build_resource

      unless @resource.present?
        raise DeviseTokenAuth::Errors::NoResourceDefinedError,
              "#{self.class.name} #build_resource does not define @resource,"\
              ' execution stopped.'
      end

      # if whitelist is set, validate redirect_url against whitelist
      return render_create_error_redirect_url_not_allowed if blacklisted_redirect_url?(@redirect_url)

      auth_result = authenticate(@resource[:uid], sign_up_params[:access_token])
      if auth_result[:error]
        return render_error(auth_result[:error][:code], auth_result[:error][:message])
      end
      @resource.name = auth_result[:profile][:name]
      @resource.image = auth_result[:profile][:image]
      if @resource.save
        yield @resource if block_given?

        if active_for_authentication?
          # email auth has been bypassed, authenticate user
          @token = @resource.create_token
          @resource.save!
          update_auth_header
        end

          render_create_success
      else
        clean_up_passwords @resource
        render_create_error
      end
    end
    protected

    def build_resource
      @resource            = resource_class.new(uid: sign_up_params[:uid])
      @resource.provider   = provider
    end

    private

    def provider
      'line'
    end
  end
end
