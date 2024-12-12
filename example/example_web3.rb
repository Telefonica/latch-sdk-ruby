#Latch Ruby SDK - Set of  reusable classes to  allow developers integrate Latch on their applications.
#Copyright (C) 2024 Telefonica Innovación Digital
#
#This library is free software you can redistribute it and/or
#modify it under the terms of the GNU Lesser General Public
#License as published by the Free Software Foundation either
#version 2.1 of the License, or (at your option) any later version.
#
#This library is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#Lesser General Public License for more details.
#
#You should have received a copy of the GNU Lesser General Public
#License along with this library if not, write to the Free Software
#Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require_relative '../latch_app'
require_relative '../latch_response'

# We define the credentials of our app in Latch
#app_id = "APP_ID"
#secret_key = "SECRET_KEY"
app_id = "Dnc4ftijVZrpyzj9RpWA"
secret_key = "dBUs8Rgbxk8DPX8uyV2JrMnTvVTYghuNtiQTLWzN"


def read_input(message, default_value = nil)
  print "#{message}: "
  input = gets.chomp
  input.empty? ? default_value : input
end

def print_response(response)
  puts "Data:"
  data_response = response.data
  puts data_response.inspect
end

def check_error_response(response, method_name)
  error_response = response.error
  result = !error_response.nil?

  if result
    error_code = error_response.code
    error_message = error_response.message
    puts "Error in #{method_name} request with error_code: #{error_code} and message: #{error_message}"
  end

  result
end

def exit_if_error_response(response, method_name)
  if check_error_response(response, method_name)
    exit(1)
  end
end

def check_status(api, account_id, element_id)
  # Fetch the response
  response = api.status(account_id)

  # Check for errors
  exit_if_error_response(response, "check_status")

  response_data = response.data

  # Evaluate the status
  case response_data["operations"][element_id]["status"]
  when 'on'
    puts "Your latch is open and you are able to perform action"
  when 'off'
    puts "Your latch is locked and you are not allowed to perform action"
  else
    puts "Error processing the response"
    exit(1)
  end
end

# Create a LatchApp instance with our credentials
latch = LatchApp.new(app_id, secret_key)

paring_code = read_input('Generated pairing token from the user account');
wallet = read_input('Your public key of your wallet');
signature = read_input('Sign the message "Latch-Web3" with your wallet');
common_name = read_input('Do you want a alias for the pairing, it will be showed in admin panels like Latch Support Tool (L:ST). Optional, blank if none ', nil)

response = latch.pair(paring_code, wallet, signature, common_name)
exit_if_error_response(response, "pair")
print_response(response)

puts "Store the accountId for future uses";
account_id = response.data["accountId"];

puts "* Check status account"
#When the state is checked, it can be checked at different levels. Application, Operation or Instance
check_status(latch, account_id, app_id);