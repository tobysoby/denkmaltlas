require 'nokogiri'
require 'open-uri'
require 'csv'

url = 'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Mainz'

doc = Nokogiri::HTML(open(url))

bezeichnungen_array = Array.new
beschreibung_array = Array.new

doc.css('li').css('a').each do |link|
    link_text = link.text
    if link_text.index('Liste d')
        
        link_2 = 'http://de.wikipedia.org' + link['href']
        teilliste = Nokogiri::HTML(open(link_2))
        teilliste.css('li').each do |denkmal|
            denkmal_text = denkmal.text
            if denkmal_text.index(':')
                if not denkmal_text.index('Verzeichnis') || denkmal_text.index('Band') || denkmal_text.index('geändert')
                doppelpunkt = denkmal_text.index(':')
                bezeichnung = denkmal_text[0..doppelpunkt-1]
                beschreibung = denkmal_text[doppelpunkt+2..denkmal_text.length]
                bezeichnungen_array.push bezeichnung
                beschreibung_array.push beschreibung
                end
            end
        end
    end
        
    CSV.open('ergebnis.csv', 'a') do |csv|
#csv << ['bezeichnung', 'lage', 'baujahr', 'beschreibung']
bezeichnungen_array.each_with_index do |vitamin, index|
csv << [bezeichnungen_array[index], beschreibung_array[index]]
end
end
    
    
    end

