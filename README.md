### LATCH RUBY SDK ###


#### PREREQUISITES ####

* Ruby 1.9.3 or above.

* Read API documentation (https://latch.tu.com/www/developers/doc_api).

* To get the "Application ID" and "Secret", (fundamental values for integrating Latch in any application), it’s necessary to register a developer account in Latch's website: https://latch.tu.com. On the upper right side, click on "Developer area".


#### USING THE SDK IN RUBY ####

* Require "Latch". Keep in mind where the SDK is placed inside your folder structure.
```
	require_relative '/latch/Latch'
```

* Create a Latch object with the "Application ID" and "Secret" previously obtained.
```
	api = Latch.new(appid, app_secret)
```

* Call to Latch Server. Pairing will return an account id that you should store for future api calls
```
     pairResponse = api.pair(PAIRING_CODE_HERE)
     statusResponse = api.status(ACCOUNT_ID_HERE)
     unpairResponse = api.unpair(ACCOUNT_ID_HERE)
```

* After every API call, get Latch response data and errors and handle them.
```
	responseData = response.data
	responseError = response.error
  ```
  
  
## USING RUBY SDK FOR WEB3 SERVICES ##

For using the Ruby SDK within an Web3 service, you must complain with the following:

* It is necessary to have a developer subscription that allows you to create web3 apps. 
* You need metamask extension for Google Chrome [Download metamask](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn)
* You need a wallet to operate on Polygon. You can easily create one through Metamask.


### Creation of a WEB3 Latch app ###

Once you have your developer Latch account created, you must logging in the website.

[Steps to add  new web3 app in latch-website](doc/Latch_WEB3_Apps.pdf)

We add a new method to pair the web3 applications, now we have two new parameters.
The two additional parameters are:
- WEB3WALLET: The Ethereum-based address wallet for the user that wants to pair the service.
- WEB3SIGNATURE: A proof-of-ownership signature of a constant, in order to verify that the user owns the private key of the wallet. You can use https://etherscan.io/verifiedSignatures# to sign the following message:
  - MESSAGE TO SIGN : "Latch-Web3"

* Call to Latch Server for pairing as usual, but with the newly methods:

```
    api = latch.Latch(APP_ID, SECRET_KEY)
    # PAIR
    response = api.pair(pairing_code, WEB3WALLET, WEB3SIGNATURE)
```


You have an example of use in the file [example for web3 app](example/example.rb)
  
