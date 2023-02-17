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
app_id = "YOUR_APP_ID"
secret_key = "YOUR_SECRET_KEY"

# Create a LatchApp instance with our credentials
latch = LatchApp.new(app_id, secret_key)

# We start the pairing process by entering the app token
response = latch.pair("token") 

# Return the response
if response.error != nil
  puts "Error: #{response.error.message}"
else
  puts "Pairing realizado correctamente. Respuesta de Latch:"
  puts response.data
end
