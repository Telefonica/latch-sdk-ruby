#Latch Ruby SDK - Set of  reusable classes to  allow developers integrate Latch on their applications.
#Copyright (C) 2024 Telefonica Innovación Digital
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

require_relative 'latch_auth'

class LatchApp < LatchAuth

  # Create an instance of the class with the Application ID and secret obtained from Telefonica Digital
  # @param $appId
  # @param $secretKey
  def initialize(app_id, secret_key)
    super(app_id, secret_key)
  end

  def pair(token, web3_wallet = nil, web3_signature = nil, common_name = nil)
    data = {
      'wallet' => CGI.escape(web3_wallet.to_s),
      'signature' => CGI.escape(web3_signature.to_s),
      'commonName' => CGI.escape(common_name.to_s)
    }

    # Filter empty or nil
    data = data.reject { |_, v| v.nil? || v.empty? }
  
    if data.empty?
      http_get_proxy(API_PAIR_URL + '/' + token)
    else
      http_post_proxy(API_PAIR_URL + '/' + token, data)
    end
  end

  def pairWithId(account_id, web3_wallet = nil, web3_signature = nil, common_name = nil)
    data = {
      'wallet' => CGI.escape(web3_wallet.to_s),
      'signature' => CGI.escape(web3_signature.to_s),
      'commonName' => CGI.escape(common_name.to_s)
    }
  
    # Filtrar datos (eliminar valores nil o vacíos)
    data = data.reject { |_, v| v.nil? || v.empty? }
  
    # Realizar la solicitud dependiendo de si 'data' está vacío
    if data.empty?
      http_get_proxy(API_PAIR_WITH_ID_URL + '/' + account_id)
    else
      http_post_proxy(API_PAIR_WITH_ID_URL + '/' + account_id, data)
    end
  end

  # Deprecated: Use 'pairWithId' instead of 'pairWithIdWeb3'
  # This method will be removed in a future release.
  def pairWithIdWeb3(account_id, web3Wallet, web3Signature)
    if web3Wallet.nil? || web3Signature.nil?
      http_get_proxy(API_PAIR_WITH_ID_URL + '/' + account_id)
    else
      params = { 'wallet' => web3Wallet, 'signature' => web3Signature }
      http_post_proxy(API_PAIR_WITH_ID_URL + '/' + account_id, params)
    end
  end

  # Deprecated: Use 'pair' instead of 'pairWithCodeWeb3'
  # This method will be removed in a future release.
  def pairWithCodeWeb3(token, web3Wallet, web3Signature)
    if web3Wallet.nil? || web3Signature.nil?
      http_get_proxy(API_PAIR_URL + '/' + token)
    else
      params = { 'wallet' => web3Wallet, 'signature' => web3Signature }
      http_post_proxy(API_PAIR_URL + '/' + token, params)
    end
  end

  def status(account_id, operation_id = nil, instance_id = nil, silent = false, nootp = false)
    url = API_CHECK_STATUS_URL + '/' + account_id
    if operation_id != nil && operation_id.length > 0
      url += '/op/' + operation_id
    end
    if instance_id != nil && instance_id.length > 0
      url += '/i/' + instance_id
    end
    if nootp
      url += '/nootp'
    end
    if silent
      url += '/silent'
    end
    http_get_proxy(url)
  end

  def add_instance(account_id, operation_id = nil, instance_name = nil)
    arr = Hash.new {|h,k| h[k] = []}
    url = API_INSTANCE_URL + '/' + account_id
    if operation_id != nil && operation_id.length > 0
      url += '/op/' + operation_id
    end
    if instance_name != nil && instance_name.length > 0
      if instance_name.kind_of?(Array)
        instance_name.each do |value|
          arr['instances'] += [value]
        end
      else
        arr['instances'] << instance_name
      end
    end
    http_put_proxy(url,arr)
  end

  def remove_instance(account_id, operation_id = nil, instance_name = nil)
    url = API_INSTANCE_URL + '/' + account_id
    if operation_id != nil && operation_id.length > 0
      url += '/op/' + operation_id
    end
    if instance_name != nil && instance_name.length > 0
      url += '/i/' + instance_name
    end
    http_delete_proxy(url)
  end

  def operationStatus(account_id, operation_id, silent = false, nootp = false)
    url = API_CHECK_STATUS_URL + '/' + account_id + '/op/' + operation_id
    if nootp
      url += '/nootp'
    end
    if silent
      url += '/silent'
    end
    http_get_proxy(url)
  end


  def unpair(account_id)
    http_get_proxy(API_UNPAIR_URL + '/' + account_id)
  end

  def lock(account_id, operation_id = nil, instance = nil)
    url = API_LOCK_URL + '/' + account_id
    if operation_id != nil && operation_id.length > 0
      url += '/op/' + operation_id
    end
    if instance != nil && instance.length > 0
      url += '/i/' + instance
    end
    http_post_proxy(url, {})
  end

  def unlock(account_id, operation_id = nil, instance = nil)
    url = API_UNLOCK_URL + '/' + account_id
    if operation_id != nil && operation_id.length > 0
      url += '/op/' + operation_id
    end
    if instance != nil && instance.length > 0
      url += '/i/' + instance
    end
    http_post_proxy(url, {})
  end

  def history (account_id, from='0', to=nil)
    if to == nil
      to = Time.now.to_i*1000
    end
    http_get_proxy(API_HISTORY_URL + '/' + account_id + '/' + from + '/' + to.to_s)
  end

  def createOperation(parent_id, name, two_factor, lock_on_request)
    params = {
        'parentId' => parent_id,
        'name' => name,
        'two_factor'=>two_factor,
        'lock_on_request'=>lock_on_request
    }
    http_put_proxy(API_OPERATIONS_URL, params)
  end

  def updateOperation(operation_id, name, two_factor, lock_on_request)
    params = {
        'name' => name,
        'two_factor'=>two_factor,
        'lock_on_request'=>lock_on_request
    }
    http_post_proxy(API_OPERATIONS_URL + '/' + operation_id, params)
  end

  def deleteOperation(operation_id)
    http_delete_proxy(API_OPERATIONS_URL + '/' + operation_id)
  end

  def getOperations(operation_id=nil)
    if operation_id == nil
      http_get_proxy(API_OPERATIONS_URL)
    else
      http_get_proxy(API_OPERATIONS_URL + '/' + operation_id)
    end
  end

  def create_totp(id, name)
    data = {
      'userId' => CGI.escape(id.to_s),
      'commonName' => CGI.escape(name.to_s)
    }
    http_post_proxy(API_TOTP_URL, data)
  end

  def get_totp(totp_id)
    http_get_proxy(API_TOTP_URL + '/' + totp_id)
  end

  # Validar un TOTP
  def validate_totp(totp_id, code)
    data = { 'code' => CGI.escape(code.to_s) }
    http_post_proxy(API_TOTP_URL + '/' + totp_id + '/validate', data)
  end

  # Eliminar un TOTP
  def delete_totp(totp_id)
    http_delete_proxy(API_TOTP_URL + '/' + totp_id)
  end

  # Comprobar el estado del control
  def check_control_status(control_id)
    http_get_proxy(API_CONTROL_STATUS_CHECK_URL + '/' + control_id)
  end

end
