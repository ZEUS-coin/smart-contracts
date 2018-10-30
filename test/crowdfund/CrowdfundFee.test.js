
const CrowdfundFeeTemplate = artifacts.require('CrowdfundFeeTemplate');
const time = require('../helpers/time');
const { ether } = require('../helpers/ether');
const ERC20Mock = artifacts.require('ERC20Mock');
const shouldFail = require('../helpers/shouldFail');
const expectEvent = require('../helpers/expectEvent');
const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

contract('CrowdfundFeeTemplate', function ([_, holder, notHolder, owner, wallet, feeWallet, ...otherAccounts]) {
  const amount = ether(100);
  const feeAmount = ether(1);
  beforeEach(async function () {    
    this.contract = await CrowdfundFeeTemplate.new(wallet, feeWallet, { from: owner });
  });

  describe('Crowdfund Fee features', function () {
    it('Should have zero funds without transfers', async function () {
    

      (await web3.eth.getBalance(this.contract.address)).should.be.bignumber.equal(ether(0));
     
     
    });
    it('wallet receives funds', async function () {
    
      const walletBalance = await web3.eth.getBalance(wallet);
     
      await this.contract.send(amount, { from:holder});

      (await web3.eth.getBalance(wallet)).should.be.bignumber.equal(walletBalance.plus(amount).minus(feeAmount));
    });
    it('Get correct wei raised', async function () {
   
      await this.contract.send(amount, { from:holder});
      (await this.contract.weiRaised()).should.be.bignumber.equal(amount.minus(feeAmount));
     
    });
    it('get correct wallet fee receives funds', async function () {

      await this.contract.send(amount, { from:holder});
      (await this.contract.feeRaised()).should.be.bignumber.equal(feeAmount);


    });
    it('wallet fee receives funds', async function () {
      const walletBalance = await web3.eth.getBalance(feeWallet);

      await this.contract.send(amount, { from:holder});

      (await web3.eth.getBalance(feeWallet)).should.be.bignumber.equal(walletBalance.plus(feeAmount));

     
    });

    it('reverts when sending zero funds', async function () {
      const amount = ether(0); 
      
      await shouldFail.reverting(this.contract.send(amount, { from: owner}));
    });
 
    it('Fund added event', async function () {
      const amount = ether(10);
      const { logs } = await this.contract.send(amount, {from:holder});
      expectEvent.inLogs(logs, 'FundsAdded', { donator: holder, amount:amount });
    });
  });
});