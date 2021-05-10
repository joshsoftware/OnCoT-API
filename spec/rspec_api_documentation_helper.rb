require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

# Values listed are the default values
RspecApiDocumentation.configure do |config|
  # Set the application that Rack::Test uses
  config.app = Rails.application

  # Used to provide a configuration for the specification (supported only by 'open_api' format for now) 
  config.configurations_dir = Rails.root.join("doc", "configurations", "api")

  # Output folder
  # **WARNING*** All contents of the configured directory will be cleared, use a dedicated directory.
  config.docs_dir = Rails.root.join("doc", "api")

  # An array of output format(s).
  # Possible values are :json, :html, :combined_text, :combined_json,
  #   :json_iodocs, :textile, :markdown, :append_json, :slate,
  #   :api_blueprint, :open_api
  config.format = [:json]

  # Location of templates
  config.template_path = "inside of the gem"

  # Filter by example document type
  config.filter = :all

  # Filter by example document type
  config.exclusion_filter = nil

  # Used when adding a cURL output to the docs
  config.curl_host = nil

  # Used when adding a cURL output to the docs
  # Allows you to filter out headers that are not needed in the cURL request,
  # such as "Host" and "Cookie". Set as an array.
  config.curl_headers_to_filter = nil

  # By default, when these settings are nil, all headers are shown,
  # which is sometimes too chatty. Setting the parameters to an
  # array of headers will render *only* those headers.
  config.request_headers_to_include = nil
  config.response_headers_to_include = nil

  # By default examples and resources are ordered by description. Set to true keep
  # the source order.
  config.keep_source_order = false

  # Change the name of the API on index pages
  config.api_name = "API Documentation"
  
  # Change the description of the API on index pages
  config.api_explanation = "API Description"

  # Redefine what method the DSL thinks is the client
  # This is useful if you need to `let` your own client, most likely a model.
  config.client_method = :client

  # Change the IODocs writer protocol
  config.io_docs_protocol = "http"

  # You can define documentation groups as well. A group allows you generate multiple
  # sets of documentation.
  config.define_group :public do |config|
    # By default the group's doc_dir is a subfolder under the parent group, based
    # on the group's name.
    # **WARNING*** All contents of the configured directory will be cleared, use a dedicated directory.
    config.docs_dir = Rails.root.join("doc", "api", "public")

    # Change the filter to only include :public examples
    config.filter = :public
  end

  # Change how the post body is formatted by default, you can still override by `raw_post`
  # Can be :json, :xml, or a proc that will be passed the params
  config.request_body_formatter = Proc.new { |params| params }

  # Change how the response body is formatted by default
  # Is proc that will be called with the response_content_type & response_body
  # by default, a response body that is likely to be binary is replaced with the string
  # "[binary data]" regardless of the media type.  Otherwise, a response_content_type of `application/json` is pretty formatted.
  config.response_body_formatter = Proc.new { |response_content_type, response_body| response_body }

  # Change the embedded style for HTML output. This file will not be processed by
  # RspecApiDocumentation and should be plain CSS.
  config.html_embedded_css_file = nil

  # Removes the DSL method `status`, this is required if you have a parameter named status
  # In this case you can assert response status with `expect(response_status).to eq 200`
  config.disable_dsl_status!

  # Removes the DSL method `method`, this is required if you have a parameter named method
  config.disable_dsl_method!
end
