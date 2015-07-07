require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
#encoding: UTF-8

url = "http://de.wikipedia.org/wiki/Kategorie:Liste_(Kulturdenkm%C3%A4ler_in_Hamburg)"

doc = Nokogiri::HTML(open(url))

bezeichnungen_array = Array.new
beschreibung_array = Array.new

doc.css('li').css('a').each do |link|
    link_text = link.text
    if link_text.index('Liste d')
        link_2 = 'http://de.wikipedia.org' + link['href']
        bezirk = Nokogiri::HTML(open(link_2))
        bezirk.css('tr').each do |row|
            #puts row.css('td').size
            if (row.css('td').size == 8 || row.css('td').size == 9)
            #if row.text.index('Lage')
                CSV.open('ergebnis.csv', 'a+') do |csv|
                    begin
                        id = ""
                        lage = ""
                        bezeichnung = ""
                        beschreibung = ""
                        koordinaten_n = ""
                        koordinaten_e = ""
                        id = row.css('td')[0].text
                        id.gsub!(/\n/, "")
                        #id.strip
                        #id_link = row.css('td')[0].css('a')[0]['href']
                        lage = row.css('td')[1].text
                        lage["(Lage)"] = ""
                        lage.chop.chop
                        #lage.gsub(/\n/, "")
                        lage.chomp!
                        puts lage
                        #lage = row.css('td')[1].text
                        bezeichnung = row.css('td')[1].text
                        bezeichnung["(Lage)"] = ""
                        bezeichnung.chop.chop
                        #bezeichnung.gsub(/\n/, "")
                        bezeichnung.strip!
                        #puts bezeichnung
                        art = row.css('td')[2].text
                        typ = row.css('td')[3].text
                        beschreibung = row.css('td')[4].text
                        koordinaten = row.css('td')[1].css('a')[0]['href']
                        params = koordinaten.index('params')
                        koordinaten_n = koordinaten[params+7..params+14]
                        #koordinaten_n['_'] = ""
                        koordinaten_e = koordinaten[params+18..params+25]
                        if koordinaten_e[0] == "0"
                            koordinaten_e.insert(0, "1")
                        end
                        if koordinaten_e[0] == "."
                            koordinaten_e.insert(0, "9")
                        end
                        puts koordinaten_e
                        puts koordinaten_n
                        #koordinaten_e["_"] = ""
                        #koordinaten_e["E"] = ""
                        if koordinaten_e[koordinaten_e.length-1] == "E"
                            koordinaten_e.chop!
                        end
                        if koordinaten_e[koordinaten_e.length-1] == "_"
                            koordinaten_e.chop!
                        end
                        #koordinaten_n["_"] = ""
                        #koordinaten_n["N"] = ""
                        if koordinaten_n[koordinaten_n.length-1] == "N"
                            koordinaten_n.chop!
                        end
                        if koordinaten_n[koordinaten_n.length-1] == "_"
                            koordinaten_n.chop!
                        end
                        bild = ""
=begin
                        if row.css('td')[4].css('a')['href']
                            bild = row.css('td')[4].css('a')['href']
                            puts bild
                        end
=end
                        #puts id, lage, bezeichnung, beschreibung, koordinaten_n, koordinaten_e, bild
                    #csv << [row.css('td')[2].text, row.css('td')[1].text, row.css('td')[0].text, row.css('td')[0].css('a')[0]['href'], row.css('td')[3].text]
                        csv << [id, lage, bezeichnung, beschreibung, koordinaten_n, koordinaten_e, bild]
                    rescue
                        next
                    end
                end
            end
        end
    end
end