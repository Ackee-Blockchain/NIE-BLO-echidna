import random

from woke.fuzzer import Campaign, flow
from woke.fuzzer.random import random_account


class Fuzz:
    def __init__(self, contract_type):
        self.contract = contract_type.deploy({"from": random_account()})
        self.value = 0

    @flow
    def flow_add(self):
        increment = random.randint(0, 255)
        self.contract.add(increment, {"from": random_account()})
        self.value += increment

        assert self.contract.actualBalance() == self.value


def test_fuzz(Overflow):
    campaign = Campaign(lambda: Fuzz(Overflow))
    campaign.run(100, 10000)
