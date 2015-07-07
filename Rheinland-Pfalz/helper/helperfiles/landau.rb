require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'geocoder'
#coding: UTF-8

# config/initializers/geocoder.rb
Geocoder.configure(

  # geocoding service (see below for supported options):
  :lookup => :yandex
)

url = ['http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_der_Kernstadt_von_Landau_in_der_Pfalz',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Arzheim_(Landau)',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Dammheim',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Godramstein',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_M%C3%B6rlheim',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_M%C3%B6rzheim',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Nu%C3%9Fdorf_(Landau)',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Queichheim',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_Wollmesheim']
    
#doc = Nokogiri::HTML(open(url))

#doc.css('.NavContent').css('a').each do |eintrag|
    #link = 'http://de.wikipedia.org' + eintrag['href']
    
    
    stadtteil_array = Array.new

url.each do |url_each|

    kreis = Nokogiri::HTML(open(url_each))
    
    bezeichnungen_array = Array.new
    beschreibung_array = Array.new
    title = kreis.css('title').text
    stadtteil = title[29..title.length-13]
    if stadtteil.index("/")
        stadtteil.delete "/"
        #stadttteil = "Hirschhorn-Pflaz"
    end
    lat_array = Array.new
    long_array = Array.new
    
    if stadtteil != "Hauptstuhl" && stadtteil != "Hirschhorn/Pfalz"

    kreis.css('li').each do |denkmal|
        denkmal_text = denkmal.text
        if denkmal_text.index(':')
            if not denkmal_text.index('Verzeichnis') || denkmal_text.index('Band') || denkmal_text.index('geändert')
                
                #if denkmal.parent().previous_element().css('.mw-headline').text()
                 #   prev = denkmal.parent().previous_element().css('.mw-headline').text()
                    
                  #  if prev.index("Einzeldenkmäler") || denkmal.parent().previous_element().css('.mw-headline').text().index("Literatur") || denkmal.parent().previous_element().css('.mw-headline').text().index("")
                   #     stadtteil_array.push stadtteil
                    #else
                     #   stadtteil_array.push denkmal.parent().previous_element().previous_element().css(".mw-headline").text()
                    #end
                
                #else
                    stadtteil_array.push stadtteil
                #end
                
                doppelpunkt = denkmal_text.index(':')
                bezeichnung = denkmal_text[0..doppelpunkt-1]
                beschreibung = denkmal_text[doppelpunkt+2..denkmal_text.length]
                
                geocode = Geocoder.coordinates(bezeichnung + ', ' + stadtteil)
                if geocode
                    lat = geocode[0]
                    long = geocode[1]
                
                    lat_array.push lat
                    long_array.push long
                else
                    lat_array.push ""
                    long_array.push ""
                end
                
                bezeichnungen_array.push bezeichnung
                beschreibung_array.push beschreibung
            end
        end
    end
    
        #csv << ['bezeichnung', 'lage', 'baujahr', 'beschreibung']
        bezeichnungen_array.each_with_index do |vitamin, index|
            CSV.open('../ergebnisse/Landau/' + stadtteil_array[index] + '.csv', 'a+') do |csv|
            puts bezeichnungen_array[index], stadtteil_array[index], beschreibung_array[index], lat_array[index], long_array[index]
            csv << [bezeichnungen_array[index], stadtteil_array[index], beschreibung_array[index], lat_array[index], long_array[index]]
        end
    end
    end
end
    