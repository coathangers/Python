#create postgres database from JSON records: http://www.cluria.com/viewer.html
#example postgres sql script

CREATE TABLE huge_json
(
	skuID		text primary key,
	Item		text,
	Price		integer
)
