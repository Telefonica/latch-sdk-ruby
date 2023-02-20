#Latch Ruby SDK - Set of  reusable classes to  allow developers integrate Latch on their applications.
#Copyright (C) 2023 Telefonica Digital
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

  def pairWithId(account_id, web3Wallet, web3Signature)
    if web3Wallet.nil? || web3Signature.nil?
      http_get_proxy(API_PAIR_WITH_ID_URL + '/' + account_id)
    else
      params = { 'wallet' => web3Wallet, 'signature' => web3Signature }
      http_post_proxy(API_PAIR_WITH_ID_URL + '/' + account_id, params)
    end
  end

  def pair(token, web3Wallet, web3Signature)
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

end
