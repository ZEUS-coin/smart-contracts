
const FreezableCrowdfund = artifacts.require('FreezableCrowdfund');
const time = require('../helpers/time');
const { ether } = require('../helpers/ether');
const ERC20Mock = artifacts.require('ERC20Mock');
const shouldFail = require('../helpers/shouldFail');
const expectEvent = require('../helpers/expectEvent');
const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

contract('FreezableCrowdfund', function ([_, holder, notHolder, owner, wallet, feeWallet, ...otherAccounts]) {
  const amount = ether(100);
  const feeAmount = ether(1);
  beforeEach(async function () {    
    this.contract = await FreezableCrowdfund.new( { from: owner });
  });

  describe('FreezableCrowdfund  features', function () {
    it('Should have initial state not freeze', async function () {
    
      (await this.contract.isFreezed()).should.be.equal(false);
    });
    it('Freeze state by owner', async function () {
       await this.contract.freezeDonations(true, {from:onwer});
      (await this.contract.isFreezed()).should.be.equal(true);
    });
    it('revert Freeze state by not owner', async function () {
        await shouldFail.reverting(this.contract.freezeDonations(true, {from: notHolder}));
      });
    it('revert when send when contract freezed', async function () {
        await this.contract.freezeDonations(true, {from:onwer});
        await shouldFail.reverting(this.contract.send(amount, { from:holder}));   
    });
    
  });
});