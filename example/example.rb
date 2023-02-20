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
app_id = "D3UzHsBBKTEUQYGWRhfd"
secret_key = "KpVDdBAXRYipMVE9DPx8kMVGDeWxmUujNu2azNbX"

clientWallet = "0x22a8814abd23d77688e50e85d2d1c787e7929d24"
clientSignature = "0xd0747edd16468de0f3886562ec461e9f92b8f91d3daee79ac799103f44e5c2e863c8cd1e97f2046b8a5c73527919cccc38cedb1f3448e7d5b46776f2f3cefca11c"

# Create a LatchApp instance with our credentials
latch = LatchApp.new(app_id, secret_key)

# We start the pairing process by entering the app token
responsePair = latch.pair("pairingCode", clientWallet, clientSignature) 

# Return the response
 if responsePair.error != nil
  puts "Error: #{responsePair.error.message}"
else
  puts "Pairing successful"
  puts responsePair.data
end 



responsePairId = latch.pairWithId("test@email.com", clientWallet, clientSignature) 

# Return the response
if responsePairId.error != nil
  puts "Error: #{responsePairId.error.message}"
else
  puts "Pairing successful"
  puts responsePairId.data
end

# We lock the account

responseLock = latch.lock("accountId")

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