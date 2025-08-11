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
class LatchUser < LatchAuth

  # Create an instance of the class with the User ID and secret obtained from Telefonica Digital
  # @param [String] user_id
  # @param [String] secret_key
  def initialize(user_id, secret_key)
    super(user_id, secret_key)
  end

  # @return [LatchResponse]
  def get_subscription
    http_get_proxy(API_SUBSCRIPTION_URL)
  end

  # @param [String] name
  # @param [String] two_factor
  # @param [String] lock_on_request
  # @param [String] contact_phone
  # @param [String] contact_email
  # @return [LatchResponse]
  def create_application(name, two_factor, lock_on_request, contact_phone, contact_email)
    params = {
        'name' => name,
        'two_factor' => two_factor,
        'lock_on_request'=>lock_on_request,
        'contactEmail'=>contact_email,
        'contactPhone'=>contact_phone
    }
    http_put_proxy(API_APPLICATION_URL, params)
  end

  # @param [String] application_id
  # @return [LatchResponse]
  def remove_application(application_id)
    http_delete_proxy(API_APPLICATION_URL + '/' + application_id)
  end

  # @return [LatchResponse]
  def get_applications
    http_get_proxy(API_APPLICATION_URL)
  end

  # @param [String] application_id
  # @param [String] name
  # @param [String] two_factor
  # @param [String] lock_on_request
  # @param [String] contact_phone
  # @param [String] contact_email
  # @return [LatchResponse]
  def update_application(application_id, name, two_factor, lock_on_request, contact_phone, contact_email)
    params = {
        'name' => name,
        'two_factor' => two_factor,
        'lock_on_request'=>lock_on_request,
        'contactEmail'=>contact_email,
        'contactPhone'=>contact_phone
    }
    http_post_proxy(API_APPLICATION_URL + '/' + application_id, params)
  end
end