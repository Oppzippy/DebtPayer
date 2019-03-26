import unittest
import yaml
from WCLPayoutDistributor import WCLPayoutDistributor

# Example data from WCL api
wcl_response = {
	'fights': [
		{ # No boss
			'id': 1,
		},
		{ # Boss that isn't listed in config
			'id': 2,
			'boss': -1
		},
		{ # Real boss, not a kill
			'id': 3,
			'boss': 1
		},
		{ # Real kills
			'id': 4,
			'boss': 3,
			'kill': True
		},
		{
			'id': 5,
			'boss': 4,
			'kill': True
		},
		{
			'id': 6,
			'boss': 5,
			'kill': True
		}
	],
	'exportedCharacters': [
		{
			'id': 1,
			'name': 'Booster1',
			'realm': 'BoosterRealm'
		},
		{
			'id': 2,
			'name': 'Booster2',
			'realm': 'BoosterRealm'
		},
		{
			'id': 3,
			'name': 'Booster3',
			'realm': 'BoosterRealm'
		},
		{
			'id': 5,
			'name': 'Booster4',
			'realm': 'BoosterRealm'
		},
		{
			'id': 4,
			'name': 'Carry1',
			'realm': 'BoosterRealm'
		},
		{
			'id': 9,
			'name': 'Carry2',
			'realm': 'OtherCarryRealm'
		},
	],
	'friendlies': [
		{
			'name': 'Booster1',
			'fights': [
				{
					'id': 1
				},
				{
					'id': 2
				},
				{
					'id': 3
				},
				{
					'id': 4
				},
				{
					'id': 5
				},
				{
					'id': 6
				}
			]
		},
		{
			'name': 'Booster2',
			'fights': [
				{
					'id': 1
				},
				{
					'id': 2
				},
				{
					'id': 3
				}
			]
		},
		{
			'name': 'Booster3',
			'fights': [
				{
					'id': 1
				},
				{
					'id': 2
				},
				{
					'id': 3
				},
				{
					'id': 4
				},
				{
					'id': 5
				},
				{
					'id': 6
				}
			]
		},
		{
			'name': 'Booster4',
			'fights': [
				{
					'id': 6,
				}
			]
		},
		{
			'name': 'Carry1',
			'fights': [
				{
					'id': 1
				},
				{
					'id': 2
				},
				{
					'id': 3
				},
				{
					'id': 4
				},
				{
					'id': 5
				},
				{
					'id': 6
				}
			]
		},
		{
			'name': 'Carry2',
			'fights': [
				{
					'id': 6
				}
			]
		}
	]
}

expected_result = {
	'Booster1': 441860,
	'Booster3': 441860,
	'Booster4': 116279
}

f = open('config.test.yaml', 'r', encoding="utf-8")
config = yaml.safe_load(f)


class TestWCLPayoutDistributor(unittest.TestCase):

	def test_init(self):
		dist = WCLPayoutDistributor(config, wcl_response)
		payout = dist.get_payout(1000000)
		self.assertEqual(expected_result, payout)

unittest.main()