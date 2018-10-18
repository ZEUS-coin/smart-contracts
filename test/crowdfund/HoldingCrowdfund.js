

const HolderCrowdfundMock = artifacts.require('HolderCrowdfundMock');
const time = require('../helpers/time');
const { ether } = require('../helpers/ether');
const ERC20Mock = artifacts.require('ERC20Mock');
const shouldFail = require('../helpers/shouldFail');
const expectEvent = require('../helpers/expectEvent');
const BigNumber = web3.BigNumber;
require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

contract('HoldingCrowdfund', function ([_, holder, notHolder, owner, wallet, ...otherAccounts]) {
  const tokenSupply = ether(20000000000);
  const holding = ether(1000);
  beforeEach(async function () {
    this.token = await ERC20Mock.new(owner, tokenSupply);
    await this.token.transfer(holder, holding, { from: owner });
    
    this.contract = await HolderCrowdfundMock.new(this.token.address, holding, wallet, { from: owner });
  });

  describe('Crowdfund features', function () {
    it('wallet receives funds from token holder', async function () {
      const amount = ether(10);
      const balance = await web3.eth.getBalance(wallet);
      await this.contract.send(amount, { from:holder});
      (await this.contract.holder({from: holder})).should.be.equal(true);
      //(await this.token.balanceOf(holder)).should.be.bignumber.equal(holding);
      (await web3.eth.getBalance(wallet)).should.be.bignumber.equal(balance.plus(amount));
    });
    it('reverts when not holder of token', async function () {
      const amount = ether(10); 
      (await this.contract.holder({from: notHolder})).should.be.equal(false);
      await shouldFail.reverting(this.contract.send(amount, { from:notHolder}));
    });
    it('Is holder', async function () {
 
      (await this.contract.holder({from: holder})).should.be.equal(true);
    });
    it('Is not holder', async function () {
   
      (await this.contract.holder({from: notHolder})).should.be.equal(true);
    });

    it('holder owns the correct value', async function () {     
      (await this.token.balanceOf(holder)).should.be.bignumber.equal(holding);
      ( await this.contract.holding({from:holder})).should.be.bignumber.equal(holding);
    });
    it('Fund added event', async function () {
      const amount = ether(10);
      console.log(holder);
      
      const { logs } = await this.contract.send(amount, {from:holder});
      console.log(holder);
      expectEvent.inLogs(logs, 'FundsAdded', { donator: holder, amount:amount });
    });
  });
});