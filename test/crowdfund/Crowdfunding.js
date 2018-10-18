const Crowdfund = artifacts.require('Crowdfund');

const { ether } = require('../helpers/ether');
const ERC20Mock = artifacts.require('ERC20Mock');
const shouldFail = require('../helpers/shouldFail');
const expectEvent = require('../helpers/expectEvent');
const BigNumber = web3.BigNumber;
require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

/*contract('Crowdfund', function ([_, holder, notHolder, owner, wallet, ...otherAccounts]) {
 
  beforeEach(async function () {

    this.contract = await Crowdfund.new(wallet, { from: owner });
  });

  describe('Crowdfund features', function () {
    it('wallet receives funds', async function () {
      const amount = ether(10);
      const balance = await web3.eth.getBalance(wallet);
      await this.contract.send(amount, {from:holder});
      (await web3.eth.getBalance(wallet)).should.be.bignumber.equal(balance.plus(amount));
    });
    it('Fund added event', async function () {
        const amount = ether(10);
        const { logs } = await this.contract.send(amount, {from:holder});
        expectEvent.inLogs(logs, 'FundsAdded', { donator: holder, amount:amount });
      });
  });
});*/