const { Web3 } = require('web3')
const fs = require('fs')

const web3 = new Web3('https://mainnet.infura.io/v3/')

async function createRandomAddress() {
  const account = web3.eth.accounts.create();
  return account;
}

async function searchBalances(count) {
  const foundAccounts = []
  for (let i = 0; i < count; i++) {
    const account = await createRandomAddress()
    const balance = await web3.eth.getBalance(account.address)
    var foundBalance = web3.utils.toWei(balance, "ether")
    console.log(foundBalance)
    if (foundBalance != '0') {
      console.log(`Address ${account.address} has balance ${web3.utils.fromWei(foundBalance, 'ether')}`)
      var foundAddress = account.address
      var foundPrivateKey = account.privateKey
      foundAccounts.push({ foundPrivateKey, foundAddress, foundBalance });
    }
  }
  
  console.log(`Total addresses with non-zero balances: ${foundAccounts.length}`)
  console.log(foundAccounts)
  require('fs').writeFile(
    './FoundAccounts.json',
    JSON.stringify(foundAccounts),
    function (err) {
        if (err) {
            console.error('Error happened');
        }
    }
);
}
          
searchBalances(10)
