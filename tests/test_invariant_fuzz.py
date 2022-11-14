import random

from woke.fuzzer import Campaign, flow, invariant
from woke.fuzzer.random import random_account


class Fuzz:
    def __init__(self, contract_type):
        self.contract = contract_type.deploy({"from": random_account()})

    @flow
    def flow_add(self):
        increment = random.randint(0, 255)
        self.contract.add(increment, {"from": random_account()})

    @invariant
    def invariant_actual_higher_than_last(self):
        assert self.contract.actualBalance() > self.contract.lastBalance()


def test_fuzz(Overflow):
    campaign = Campaign(lambda: Fuzz(Overflow))
    campaign.run(100, 10000)
