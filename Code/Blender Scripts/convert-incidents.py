# convert-incidents.py

class IncidentError(Exception): pass

class Incident:
	def __init__(self, report_id, date, airport, aircraft_id, aircraft_type, pilot_percent_hours_on_type, pilot_total_hours, midair, narrative=""):
		assert len(report_id) >= 8 and len(report_id.split()) == 1, "invalid report ID"
		
		self.__report_id = report_id
		self.date = date
		self.airport = airport
		self.aircraft_id = aircraft_id
		self.aircraft_type = aircraft_type
		self.pilot_percent_hours_on_type = pilot_percent_hours_on_type
		self.pilot_total_hours = pilot_total_hours
		self.midair = midair
		self.narrative = narrative
		
	@property
	def date(self):
		return self.__date
	
	@date.setter
	def date(self, date):
		assert isinstance(date, datetime.date), "invalid date"
		self.__date = date
		
	@property
	def airport(self):
		return self.__airport
	
	@airport.setter
	def airport(self, airport):
		self.__airport = airport
		
	@property
	def aircraft_id(self):
		return self.__aircraft_id
		
	@aircraft_id.setter
	def aircraft_id(self, aircraft_id):
		self.__aircraft_id = aircraft_id
		
	@property
	def aircraft_type(self):
		return self.__aircraft_type
	
	@aircraft_type.setter
	def aircraft_type(self, aircraft_type):
		self.__aircraft_type = aircraft_type
		
	@property
	def pilot_percent_hours_on_type(self):
		return self.__pilot_percent_hours_on_type
	
	@pilot_percent_hours_on_type.setter
	def pilot_percent_hours_on_type(self, percent):
		assert 0.0 <= percent <= 100.0, "out of range percentage"
		self.__pilot_percent_hours_on_type = percent
		
	@property
	def pilot_total_hours(self):
		return self.__pilot_total_hours
	
	@pilot_total_hours.setter
	def pilot_total_hours(self, pilot_total_hours):
		self.__pilot_total_hours = pilot_total_hours
		
	@property
	def midair(self):
		return self.__midair
	
	@midair.setter
	def midair(self, midair):
		self.__midair = midair
		
	@property
	def narrative(self):
		return self.__narrative
	
	@narrative.setter
	def narrative(self, narrative):
		self.__narrative = narrative
		
class IncidentCollection(dict):
	def values(self):
		for report_id in self.keys():
			yield self[report_id]
			
	def items(self):
		for report_id in self.keys():
			yield(report_id, self[report_id])
	
	def __iter__(self):
		for report_id in sorted(super().keys()):
			yield report_id
			
	keys = __iter__
	