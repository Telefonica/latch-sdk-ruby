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

require_relative 'latch_auth'

class LatchApp < LatchAuth

  # Create an instance of the class with the Application ID and secret obtained from Eleven Paths
  # @param $appId
  # @param $secretKey
  def initialize(app_id, secret_key)
    super(app_id, secret_key)
  end

  def pairWithId(account_id)
    http_get_proxy(API_PAIR_WITH_ID_URL + '/' + account_id)
  end


  def pair(token)
    http_get_proxy(API_PAIR_URL + '/' + token)
  end


  def status(account_id)
    http_get_proxy(API_CHECK_STATUS_URL + '/' + account_id)
  end


  def operationStatus(account_id, operation_id)
    http_get_proxy(API_CHECK_STATUS_URL + '/' + account_id + '/op/' + operation_id)
  end


  def unpair(account_id)
    http_get_proxy(API_UNPAIR_URL + '/' + account_id)
  end

  def lock(account_id, operation_id=nil)
    if operation_id  == nil
      http_post_proxy(API_LOCK_URL + '/' + account_id, {})
    else
      http_post_proxy(API_LOCK_URL + '/' + account_id + '/op/' + operation_id, {})
    end
  end

  def unlock(account_id, operation_id=nil)
    if operation_id  == nil
      http_post_proxy(API_UNLOCK_URL + '/' + account_id, {})
    else
      http_post_proxy(API_UNLOCK_URL + '/' + account_id + '/op/' + operation_id, {})
    end
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