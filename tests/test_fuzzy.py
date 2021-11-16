from brownie import accounts
from brownie.test import given, strategy

@given(
    value=strategy('uint256', min_value=1),
)
def test_log_functions(Math,MathTrusted, value):
    c1 = Math.deploy({'from': accounts[0]})
    c2 = MathTrusted.deploy({'from': accounts[0]})

    res1 = c1.log2Untrusted(value)
    res2 = c2.log2Trusted(value)

    assert res1.return_value == res2.return_value
