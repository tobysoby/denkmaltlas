require 'nokogiri'
require 'open-uri'
require 'csv'

url = 'http://de.wikipedia.org/wiki/Vorlage:Navigationsleiste_Kulturdenkm%C3%A4ler_im_Landkreis_Bad_Kreuznach'

doc = Nokogiri::HTML(open(url))

doc.css('.NavContent').css('a').each do |eintrag|
    link = 'http://de.wikipedia.org' + eintrag['href']

    kreis = Nokogiri::HTML(open(link))
    
    bezeichnungen_array = Array.new
    beschreibung_array = Array.new
    title = kreis.css('title').text
    stadtteil = title[28..title.length-13]


        kreis.css('li').each do |denkmal|
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

        
        
    CSV.open('ergebnisse/Bad Kreuznach/' + stadtteil + '.csv', 'a') do |csv|
#csv << ['bezeichnung', 'lage', 'baujahr', 'beschreibung']
bezeichnungen_array.each_with_index do |vitamin, index|
csv << [bezeichnungen_array[index], stadtteil, beschreibung_array[index]]
end
end
end