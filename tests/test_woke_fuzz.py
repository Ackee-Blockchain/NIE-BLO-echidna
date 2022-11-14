import math
import random

from woke.fuzzer.campaign import Campaign
from woke.fuzzer.decorators import flow, invariant
from woke.fuzzer.random import random_account


class Test:
    def __init__(self, trusted_type, untrusted_type) -> None:
        self.trusted = trusted_type.deploy({'from': random_account()})
        self.untrusted = untrusted_type.deploy({'from': random_account()})

    @flow
    def flow_log2(self):
        arg = random.randint(1, 2**256-1)
        res1 = self.trusted.log2Trusted(arg).return_value
        res2 = self.untrusted.log2Untrusted(arg).return_value
        res3 = math.ceil(math.log(arg, 2))
        assert res1 == res2 == res3


def test_counter(Math, MathTrusted):
    campaign = Campaign(lambda: Test(MathTrusted, Math))
    campaign.run(100, 40)
