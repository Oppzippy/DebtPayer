import requests
import yaml
import sys
import math
from WCLPayoutDistributer import WCLPayoutDistributer

if len(sys.argv) < 3:
	print('Args: wclreport totalgold')
	sys.exit()

id = sys.argv[1]
total_currency = float(sys.argv[2])

with open('config.yaml', 'r', encoding="utf-8") as f:
	config = yaml.safe_load(f)
	resp = requests.get(f'https://www.warcraftlogs.com:443/v1/report/fights/{id}?api_key={config["api_key"]}')
	payout_distributer = WCLPayoutDistributer(config, resp.json())

	payout = payout_distributer.get_payout(total_currency)

	output = "\n".join("{},{}".format(k, math.floor(v)) for k, v in payout.items())

	print(output)
