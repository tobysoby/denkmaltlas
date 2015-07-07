require 'nokogiri'
require 'open-uri'
require 'csv'

url = ['http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Mainz-Laubenheim',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Mainz-Marienborn',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Mainz-Mombach',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Mainz-Neustadt',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Mainz-Oberstadt',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Mainz-Weisenau']

url.each do |url|

doc = Nokogiri::HTML(open(url))

bezeichnungen_array = Array.new
beschreibung_array = Array.new
title = doc.css('title').text
stadtteil = title[28..title.length-13]


        doc.css('li').each do |denkmal|
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

        
        
    CSV.open(stadtteil + '.csv', 'a') do |csv|
#csv << ['bezeichnung', 'lage', 'baujahr', 'beschreibung']
bezeichnungen_array.each_with_index do |vitamin, index|
csv << [bezeichnungen_array[index], stadtteil, beschreibung_array[index]]
end
end

end