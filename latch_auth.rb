#Latch Ruby SDK - Set of  reusable classes to  allow developers integrate Latch on their applications.
#Copyright (C) 2013 Eleven Paths
#
#This library is free software; you can redistribute it and/or
#modify it under the terms of the GNU Lesser General Public
#License as published by the Free Software Foundation; either
#version 2.1 of the License, or (at your option) any later version.
#
#This library is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#Lesser General Public License for more details.
#
#You should have received a copy of the GNU Lesser General Public
#License along with this library; if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require 'base64'
require 'cgi'
require 'openssl'
require 'net/http'
require_relative 'latch_response'

class LatchAuth

  attr_accessor  :api_host
  API_HOST = 'https://latch.elevenpaths.com'
  API_VERSION = '1.1'

  # Application API
  API_CHECK_STATUS_URL = '/api/' + API_VERSION + '/status'
  API_PAIR_URL = '/api/' + API_VERSION + '/pair'
  API_PAIR_WITH_ID_URL = '/api/' + API_VERSION + '/pairWithId'
  API_UNPAIR_URL =  '/api/' + API_VERSION + '/unpair'
  API_LOCK_URL =  '/api/' + API_VERSION + '/lock'
  API_UNLOCK_URL =  '/api/' + API_VERSION + '/unlock'
  API_HISTORY_URL =  '/api/' + API_VERSION + '/history'
  API_OPERATIONS_URL =  '/api/' + API_VERSION + '/operation'
  API_INSTANCE_URL = '/api/' + API_VERSION + '/instance'

  # User API
  API_APPLICATION_URL = '/api/' + API_VERSION + '/application'
  API_SUBSCRIPTION_URL = '/api/' + API_VERSION + '/subscription'


  AUTHORIZATION_HEADER_NAME = 'Authorization'
  DATE_HEADER_NAME = 'X-11Paths-Date'
  AUTHORIZATION_METHOD = '11PATHS'
  AUTHORIZATION_HEADER_FIELD_SEPARATOR = ' '

  HMAC_ALGORITHM = 'sha1'

  X_11PATHS_HEADER_PREFIX = 'X-11Paths-'
  X_11PATHS_HEADER_SEPARATOR = ':'

  # The custom header consists of three parts, the method, the appId and the signature.
  # This method returns the specified part if it exists.
  # @param $part The zero indexed part to be returned
  # @param $header The HTTP header value from which to extract the part
  # @return string the specified part from the header or an empty string if not existent
  def getPartFromHeader(part, header)
    result = ''
    if header.empty?
      parts = header.split(AUTHORIZATION_HEADER_FIELD_SEPARATOR)
      if parts.length > part
        result = parts[part]
      end
    end
    result
  end

  # @param $authorization_header Authorization HTTP Header
  # @return string the Authorization method. Typical values are "Basic", "Digest" or "11PATHS"
  def getAuthMethodFromHeader(authorization_header)
    getPartFromHeader(0, authorization_header)
  end

  # @param $authorization_header Authorization HTTP Header
  # @return string the requesting application Id. Identifies the application using the API
  def getAppIdFromHeader(authorization_header)
    getPartFromHeader(1, authorization_header)
  end


  # @param $authorization_header Authorization HTTP Header
  # @return string the signature of the current request. Verifies the identity of the application using the API
  def getSignatureFromHeader(authorization_header)
    getPartFromHeader(2, authorization_header)
  end


  # Create an instance of the class with the Application ID and secret obtained from Eleven Paths
  # @param $app_id
  # @param $secret_key
  def initialize(app_id, secret_key)
    @appid = app_id
    @secret = secret_key
    @api_host = API_HOST
  end

  def http(method, url, headers, params=nil)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    if uri.default_port == 443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    case method
      when 'GET'
        request = Net::HTTP::Get.new(uri.request_uri)
      when 'POST'
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data(params)
      when 'PUT'
        request = Net::HTTP::Put.new(uri.request_uri)
        request.set_form_data(params)
      when 'DELETE'
        request = Net::HTTP::Delete.new(uri.request_uri)
      else
        request = nil
    end

    headers.map do |key,value|
      request[key] = value
    end

    response = http.request(request)
    response.body
  end


  def http_get_proxy(url)
    LatchResponse.new(http('GET', api_host + url, authenticationHeaders('GET', url, nil)))
  end

  def http_post_proxy(url, params)
    LatchResponse.new(http('POST', api_host + url, authenticationHeaders('POST', url, nil, nil, params), params))
  end

  def http_put_proxy(url, params)
    LatchResponse.new(http('PUT', api_host + url, authenticationHeaders('PUT', url, nil, nil, params), params))
  end

  def http_delete_proxy(url)
    LatchResponse.new(http('DELETE', api_host + url, authenticationHeaders('DELETE', url, nil)))
  end

  # @param $data the string to sign
  # @return string base64 encoding of the HMAC-SHA1 hash of the data parameter using {@code secretKey} as cipher key.
  def signData(data)
    Base64.encode64(OpenSSL::HMAC.digest(HMAC_ALGORITHM, @secret, data))
  end


  # Calculate the authentication headers to be sent with a request to the API
  # @param $HTTPMethod the HTTP Method, currently only GET is supported
  # @param $query_string the urlencoded string including the path (from the first forward slash) and the parameters
  # @param $x_headers HTTP headers specific to the 11-paths API. null if not needed.
  # @param $utc the Universal Coordinated Time for the Date HTTP header
  # @return array a map with the Authorization and Date headers needed to sign a Latch API request
  def authenticationHeaders(http_method, query_string, x_headers=nil, utc=nil, params=nil)
    if utc == nil
      utc = getCurrentUTC
    end

    string_to_sign = (http_method.upcase).strip + "\n" +
        utc.to_s + "\n" +
        getSerializedHeaders(x_headers) + "\n" +
        query_string.strip

    if params != nil && params.size > 0
      serialized_params = getSerializedParams(params)
      if serialized_params != nil && serialized_params.size > 0
        string_to_sign = string_to_sign.strip + "\n" + serialized_params
      end
    end

    authorization_header = AUTHORIZATION_METHOD +
        AUTHORIZATION_HEADER_FIELD_SEPARATOR +
        @appid +
        AUTHORIZATION_HEADER_FIELD_SEPARATOR +
        signData(string_to_sign).chop

    headers = {}
    headers[AUTHORIZATION_HEADER_NAME] = authorization_header
    headers[DATE_HEADER_NAME] = utc
    return headers
  end



  # Prepares and returns a string ready to be signed from the 11-paths specific HTTP headers received
  # @param $x_headers a non necessarily ordered map of the HTTP headers to be ordered without duplicates.
  # @return a String with the serialized headers, an empty string if no headers are passed, or null if there's a problem
  # such as non 11paths specific headers
  def getSerializedHeaders(x_headers)
    if x_headers != nil
      headers = x_headers.inject({}) do |x_headers, keys|
        hash[keys[0].downcase] = keys[1]
        hash
      end

      serialized_headers = ''

      headers.sort.map do |key,value|
        if key.downcase == X_11PATHS_HEADER_PREFIX.downcase
          puts 'Error serializing headers. Only specific ' + X_11PATHS_HEADER_PREFIX + ' headers need to be singed'
          return nil
        end
        serialized_headers += key + X_11PATHS_HEADER_SEPARATOR + value + ' '
      end
      substitute = 'utf-8'
      return serialized_headers.gsub(/^[#{substitute}]+|[#{substitute}]+$/, '')
    else
      return ''
    end
  end

  def getSerializedParams(parameters)
    result = ''
    unless parameters.nil?
      serialized_params = ''
      parameters.sort.map do |key,value|
        if value.kind_of?(Array)
          parameters[key].sort.map do |value2|
            if value2.kind_of?(String)
              serialized_params += key + '=' + value2 + '&'
            end
          end
        else
          serialized_params += key + '=' + CGI::escape(value) + '&'
        end
      end
      substitute = '&'
      result = serialized_params.gsub(/^[#{substitute}]+|[#{substitute}]+$/, '')
    end
    return result
  end

  # @return a string representation of the current time in UTC to be used in a Date HTTP Header
  def getCurrentUTC
    Time.now.utc
  end

end