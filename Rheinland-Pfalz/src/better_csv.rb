require 'rubygems'
require 'csv'
#coding: UTF-8

i = 0

CSV.foreach('rlp.csv', {:col_sep => "|"}) do |row|

	i += 1

    CSV.open('rlp_new.csv', 'a', {:col_sep => "|"}) do |csv|
    	eid = i
    	web = "http://gdke-rlp.de/index.php?id=19106"
    	if row[1]
    		ad1 = row[1]
    	else
    		ad1 = ""
    	end
    	if row[2]
    		ad2 = row[2]
    	else
    		ad2 = ""
    	end
    	adresse = ad1 + ', ' + ad2
    	if row[0] != row[1]
    		beschreibung = row[0]
    	else
    		beschreibung = "n.a."
    	end
    	if row[3]
    		dat = row[3]
    	else
    		dat = ""
    	end
    	if row[4]
    		dat2 = row[4]
    	else
    		dat2 = ""
    	end
    	bemerkung = dat + ': ' + dat2
    	lat = row[5]
    	lng = row[6]
    	created_at = "x"
    	updated_at = "y"
    	adresse = adresse.gsub("\n", "")
        csv << [eid, web, adresse, beschreibung, bemerkung, lat, lng, created_at, updated_at]
    end

end