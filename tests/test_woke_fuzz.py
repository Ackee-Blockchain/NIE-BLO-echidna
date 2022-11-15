import logging
import random
​
import brownie
import woke.fuzzer.campaign
from woke.fuzzer.campaign import Campaign
from woke.fuzzer.decorators import flow, invariant, weight
from woke.fuzzer.random import random_account, random_bytes
​
​
class Fuzz:
    def __init__(self, contract_type) -> None:
        self.owners = [random_account()]
        self.owners.append(random_account(predicate=lambda x: x != self.owners[0]))
        self.contract = contract_type.deploy(self.owners[1], {"from": self.owners[0]})
        self.invited = None
    
    @flow
    def flow_add_owner(self):
        brownie.accounts.add()
​
        sender = random_account()
        new_owner = random_account()
        if sender in self.owners:
            self.contract.addOwner(new_owner, {"from": sender})
            self.invited = new_owner
        else:
            with brownie.reverts():
                self.contract.addOwner(new_owner, {"from": sender})
    
    @flow
    def flow_accept_invitation(self):
        brownie.accounts.add()
​
        sender = random_account()
        if sender == self.invited:
            self.contract.acceptInvitation({"from": sender})
        else:
            with brownie.reverts():
                self.contract.acceptInvitation({"from": sender})
​
    @flow
    def flow_withdraw(self):
        sender = random_account()
​
        if sender in self.owners:
            self.contract.withdraw({"from": sender})
        else:
            with brownie.reverts():
                self.contract.withdraw({"from": sender})
​
​
def test_executor(MultiOwnable):
    campaign = Campaign(lambda: Fuzz(MultiOwnable))
    campaign.run(100, 1000)