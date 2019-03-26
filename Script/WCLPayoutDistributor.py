import sqlite3

class WCLPayoutDistributor:
	def __init__(self, config, json):
		self.connection = sqlite3.connect(':memory:')
		self.cursor = self.connection.cursor()
		self.create_tables()
		self.populate_blacklist(config)
		self.populate_boss_weights(config)
		self.populate_whitelist(json)
		self.populate_fight_attendees(json)
		self.populate_boss_kills(json)
		
	def create_tables(self):
		self.cursor.execute('CREATE TABLE boss_weights (boss INTEGER PRIMARY KEY, weight REAL NOT NULL)')
		self.cursor.execute('CREATE TABLE blacklist (player TEXT PRIMARY KEY)')
		self.cursor.execute('CREATE TABLE whitelist (player TEXT PRIMARY KEY)')
		self.cursor.execute('CREATE TABLE fight_attendees (id INTEGER PRIMARY KEY, fight INTEGER NOT NULL, attendee TEXT NOT NULL)')
		self.cursor.execute('CREATE TABLE boss_kills (fight INTEGER PRIMARY KEY, boss INTEGER NOT NULL)')
		
	
	def populate_boss_weights(self, config):
		for boss, weight in config['bosses'].items():
			self.cursor.execute('INSERT INTO boss_weights (boss, weight) VALUES (:boss, :weight)', {'boss': boss, 'weight': weight})
	
	def populate_blacklist(self, config):
		for player in config['blacklist']:
			self.cursor.execute('INSERT INTO blacklist (player) VALUES (:player)', {'player': player})
	
	def populate_whitelist(self, json):
		for player in json['exportedCharacters']:
			self.cursor.execute('INSERT INTO whitelist (player) VALUES (:player)', {'player': player["name"]})
	
	def populate_fight_attendees(self, json):
		for friendly in json['friendlies']:
			for fight in friendly['fights']:
				self.cursor.execute('INSERT INTO fight_attendees (fight, attendee) VALUES (:fight, :friendly)', {'fight': fight['id'], 'friendly': friendly['name']})
	
	def populate_boss_kills(self, json):
		for fight in json['fights']:
			if fight.get('boss') != 0 and fight.get('kill'):
				self.cursor.execute('INSERT INTO boss_kills (fight, boss) VALUES (:fight, :boss)', {'fight': fight['id'], 'boss': fight['boss']})
				
	# End init, begin aggregation
	
	def get_shares(self):
		rows = self.cursor.execute('''
		SELECT fa.attendee, SUM(bw.weight) FROM fight_attendees as fa 
		INNER JOIN boss_kills as bk ON fa.fight = bk.fight 
		INNER JOIN boss_weights as bw ON bk.boss = bw.boss
		WHERE EXISTS (SELECT 1 FROM whitelist WHERE player = fa.attendee)
		AND NOT EXISTS (SELECT 1 FROM blacklist WHERE player = fa.attendee) GROUP BY fa.attendee''')
		
		ret = []
		for row in rows:
			ret.append(row)
		
		return ret
	
	def get_total_shares(self, rows):
		total_shares = 0
		for row in rows:
			total_shares += row[1]
		
		return total_shares
	
	def get_payout(self, cash):
		rows = self.get_shares()
		total_shares = self.get_total_shares(rows)
		share_price = cash / total_shares
		
		payout = {}
		for row in rows:
			payout[row[0]] = row[1] * share_price
		
		return payout
	
	def destroy(self):
		self.connection.close()
