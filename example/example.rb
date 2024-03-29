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

require_relative '../latch_app'
require_relative '../latch_response'

# We define the credentials of our app in Latch
app_id = "APP_ID"
secret_key = "SECRET_KEY"

clientWallet = "YOUR_WALLET_ADDRESS"
clientSignature = "YOUR_SIGNATURE"

# Create a LatchApp instance with our credentials
latch = LatchApp.new(app_id, secret_key)

# We start the pairing process by entering the app token
responsePair = latch.pair("pairingCode")

# Return the response
if responsePair.error != nil
  puts "Error: #{responsePair.error.message}"
else
  puts "Pairing successful"
  puts responsePair.data
end 


responsePairId = latch.pairWithId("test@email.com") 

# Return the response
if responsePairId.error != nil
  puts "Error: #{responsePairId.error.message}"
else
  puts "Pairing successful"
  puts responsePairId.data
end


# USING THE SDK IN NODEJS FOR WEB3 SERVICES

responsePairCodeWeb3 = latch.pairWithCodeWeb3("pairingCode", clientWallet, clientSignature)
# Return the response
 if responsePairCodeWeb3.error != nil
  puts "Error: #{responsePairCodeWeb3.error.message}"
else
  puts "Pairing successful"
  puts responsePairCodeWeb3.data
end


responsePairIdWeb3 = latch.pairWithIdWeb3("test@email.com", clientWallet, clientSignature) 

# Return the response
if responsePairIdWeb3.error != nil
  puts "Error: #{responsePairIdWeb3.error.message}"
else
  puts "Pairing successful"
  puts responsePairIdWeb3.data
end

# We lock the account

responseLockWeb3 = latch.lock("accountId")

# Return the response
if responseLock.error != nil
  puts "Error: #{responseLock.error.message}"
else
  puts "Lock successful"
end

# We unlock the account
responseUnlock = latch.unlock("accountId")

# Return the response
if responseUnlock.error != nil
  puts "Error: #{responseUnlock.error.message}"
else
  puts "Unlock successful"
end


# We check the status of the account
responseStatus = latch.status("accountId")

# Return the response
if responseStatus.error != nil
  puts "Error: #{responseStatus.error.message}"
else
  puts "Status: #{responseStatus.data}"
end

# We unpair the account
responseUnpair = latch.unpair("accountId")

# Return the response
if responseUnpair.error != nil
  puts "Error: #{responseUnpair.error.message}"
else
  puts "Unpair successful"
end