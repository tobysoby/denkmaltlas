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

bezeichnung_arr = Array.new
adresse_arr = Array.new
ort_arr = Array.new
datierung_arr = Array.new
beschreibung_arr = Array.new
abbildung_arr = Array.new
long_arr = Array.new
lat_arr = Array.new
tags_arr = Array.new

index = 0

CSV.foreach("../ergebnisse/alle/complete.csv") do |row|
    tags = ''
    
    bezeichnung_arr[index] = row[0]
    adresse_arr[index] = row[1]
    ort_arr[index] = row[2]
    datierung_arr[index] = row[3]
    beschreibung_arr[index] = row[4]
    abbildung_arr[index] = row[5]
    long_arr[index] = row[6]
    lat_arr[index] = row[7]
    
    if beschreibung_arr[index]
    if beschreibung_arr[index].index("Friedhof")
        tags = tags + "Friedhof, "
    end
    
    if beschreibung_arr[index].index("Jüdisch") || beschreibung_arr[index].index("jüdisch") || beschreibung_arr[index].index("Jude")
        tags = tags + "Jüdisch, "
    end
    
    if beschreibung_arr[index].index("Kirche")
        tags = tags + "Kirche, "
    end
    
    if beschreibung_arr[index].index("Villa") || beschreibung_arr[index].index("villa")
        tags = tags + "Villa, "
    end
    
    if beschreibung_arr[index].index("Jugendstil")
        tags = tags + "Jugendstil, "
    end
    
    if beschreibung_arr[index].index("Barock") || beschreibung_arr[index].index("barock")
        tags = tags + "Barock, "
    end
    
    if beschreibung_arr[index].index("Gotik") || beschreibung_arr[index].index("gotisch")
        tags = tags + "Gotik, "
    end
    
    if beschreibung_arr[index].index("Romanik") || beschreibung_arr[index].index("romanisch")
        tags = tags + "Romanik, "
    end
    
    if beschreibung_arr[index].index("Denkmal") || beschreibung_arr[index].index("denkmal")
        tags = tags + "Denkmal, "
    end
    
    if beschreibung_arr[index].index("Fachwerk")
        tags = tags + "Fachwerk, "
    end
    
    if beschreibung_arr[index].index("Grube")
        tags = tags + "Grube, "
    end
    
    if beschreibung_arr[index].index("Brücke")
        tags = tags + "Brücke, "
    end
    
    if beschreibung_arr[index].index("chule")
        tags = tags + "Schule, "
    end
    
    if beschreibung_arr[index].index("chloss")
        tags = tags + "Schloss, "
    end
    
    if beschreibung_arr[index].index("loster")
        tags = tags + "Kloster, "
    end
    
    if beschreibung_arr[index].index("apelle")
        tags = tags + "Kapelle, "
    end
    end
    
    tags_arr[index] = tags
    
    if long_arr[index].to_s == "" || lat_arr[index].to_s == ""
        if adresse_arr[index] && ort_arr[index]
            puts adresse_arr[index] + ', ' + ort_arr[index]
            geocode = Geocoder.coordinates(adresse_arr[index] + ', ' + ort_arr[index])
            if geocode
                lat = geocode[1]
                long = geocode[0]
                
                lat_arr[index] =  lat
                long_arr[index] = long
            else
                lat_arr[index] = ""
                long_arr[index] = ""
            end
        else
            lat_arr[index] = ""
            long_arr[index] = ""
        end
    end
    
    index = index + 1
    
end
    
index = 0
    
    bezeichnung_arr.each_with_index do |vitamin, index|
            CSV.open('../ergebnisse/alle/complete_with_tags.csv', 'a+') do |csv|
            csv << [bezeichnung_arr[index], adresse_arr[index], ort_arr[index], datierung_arr[index], beschreibung_arr[index], abbildung_arr[index], long_arr[index], lat_arr[index], tags_arr[index]]
        end
    end