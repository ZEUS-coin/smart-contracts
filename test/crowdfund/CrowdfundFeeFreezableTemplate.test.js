const CrowdfundFeeFreezableTemplate = artifacts.require('CrowdfundFeeFreezableTemplate');
const time = require('../helpers/time');
const { ether } = require('../helpers/ether');
const ERC20Mock = artifacts.require('ERC20Mock');
const shouldFail = require('../helpers/shouldFail');
const expectEvent = require('../helpers/expectEvent');
const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

contract('CrowdfundFeeFreezableTemplate', function ([_, holder, notHolder, owner, wallet, feeWallet, ...otherAccounts]) {
  const amount = ether(100);
  const feeAmount = ether(1);
  beforeEach(async function () {    
    this.contract = await CrowdfundFeeFreezableTemplate.new(wallet, feeWallet, { from: owner });
  });

  describe('FreezableCrowdfund  features', function () {
    it('Should have initial state not freeze', async function () {
    
      (await this.contract.isFreezed()).should.be.equal(false);
    });
    it('Freeze state by owner', async function () {
       await this.contract.freezeDonations(true, {from:owner});
      (await this.contract.isFreezed()).should.be.equal(true);
    });
    it('revert Freeze state by not owner', async function () {
        await shouldFail.reverting(this.contract.freezeDonations(true, {from: notHolder}));
      });
    it('revert when send when contract freezed', async function () {
        await this.contract.freezeDonations(true, {from:owner});
        await shouldFail.reverting(this.contract.send(amount, { from:holder}));   
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
    
  });
});