# frozen_string_literal: true

module JMAP
  # A Session object holds details about the data and capabilities a JMAP
  # server can provide to the client based on the credentials provided.
  class Session
    attr_reader :parsed_json

    def initialize(response_body)
      @parsed_json = response_body
    end

    # @todo: Add a value object for this
    def capabilities = parsed_json["capabilities"]

    # @todo: Add a value object for this
    def accounts = parsed_json["accounts"]

    # @todo: Add a value object for this
    def primary_accounts = parsed_json["primaryAccounts"]

    # @return [String] The username associated with the given credentials, or
    # the empty string if none.
    def username = parsed_json["username"]

    # @return [String] The URL to use for JMAP API requests.
    def api_url = parsed_json["apiUrl"]

    #  The URL endpoint to use when downloading files, in URI Template (level
    #  1) format [@!RFC6570]. The URL MUST contain variables called accountId,
    #  blobId, type, and name. The use of these variables is described in
    #  Section 6.2. Due to potential encoding issues with slashes in content
    #  types, it is RECOMMENDED to put the type variable in the query section
    #  of the URL.
    #
    #  @return [String]
    def download_url = parsed_json["downloadUrl"]

    # The URL endpoint to use when uploading files, in URI Template (level 1)
    # format [@!RFC6570]. The URL MUST contain a variable called accountId.
    #
    # @return [String]
    def upload_url = parsed_json["uploadUrl"]

    # The URL to connect to for push events, as described in Section 7.3, in
    # URI Template (level 1) format [@!RFC6570]. The URL MUST contain variables
    # called types, closeafter, and ping.
    #
    # @return [String]
    def event_source_url = parsed_json["eventSourceUrl"]

    # A (preferably short) string representing the state of this object on the
    # server. If the value of any other property on the Session object changes,
    # this string will change. The current value is also returned on the API
    # Response object (see Section 3.4), allowing clients to quickly determine
    # if the session information has changed (e.g., an account has been added
    # or removed), so they need to refetch the object.
    #
    # @return [String]
    def state = parsed_json["state"]
  end
end
