require 'nokogiri'
require 'open-uri'
require 'csv'

url = ['http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_der_Kernstadt_von_Bad_Kreuznach/Denkmalzonen',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_der_Kernstadt_von_Bad_Kreuznach/Stra%C3%9Fen_A%E2%80%93K',
    'http://de.wikipedia.org/wiki/Liste_der_Kulturdenkm%C3%A4ler_in_der_Kernstadt_von_Bad_Kreuznach/Stra%C3%9Fen_L%E2%80%93Z',
    ]

url.each do |url|

kreis = Nokogiri::HTML(open(url))

bezeichnungen_array = Array.new
    beschreibung_array = Array.new
    title = kreis.css('title').text
    #stadtteil = title[29..title.length-13]
    stadtteil = 'Bad Kreuznach'
    lage_array = Array.new
    baujahr_array = Array.new
    bild_link_array = Array.new
    n_array = Array.new
    e_array = Array.new

    kreis.xpath('//tr/td[1]').each do |bezeichnung|
        bezeichnungen_array.push bezeichnung.text
    end

    kreis.css('tr').css('td[2]').each do |lage|
        la = lage.text #nimm nur den Text
        if la.index('Lage')
            para_lage = la.index('Lage')
            la = la[0..para_lage-2] #mach das Lage am Schluss weg
            #la.insert la.length, ', ' #Komma dazu
            #la.insert la.length, gemeinde #und die Gemeinde dazu
            lage_array.push la #und dann pack alles in den Array
        else
            lage_array.push la
        end
    end

    kreis.xpath('//tr/td[3]').each do |baujahr|
        baujahr_array.push baujahr.text
    end

    kreis.xpath('//tr/td[4]').each do |beschreibung|
        beschreibung_array.push beschreibung.text
    end

    kreis.css('tr').css('td[5]').each do |bild|
        bild = bild.css('a')[1]
        if bild
            bild = bild["href"]
            unless bild == '/wiki/Wikipedia:Bilderw%C3%BCnsche/Anleitung'
                bild_link_array.push bild
            end
            if bild == '/wiki/Wikipedia:Bilderw%C3%BCnsche/Anleitung' || bild == ''
                bild_link_array.push 'Kein Bild vorhanden'
            end
        end
    end


    kreis.css("a[class='external text']").each do |koord_ganz|
        koord = koord_ganz['href']
        if koord.index('params')
            puts koord
            anfang_koord = koord.index('params') #Anfang der Koordinaten
            anfang_n = anfang_koord + 7
            puts anfang_n
            ende_koord = koord.index('_E_re') #Ende der Koordinaten
            ende_e = ende_koord
            #koord[ende_koord..koord.length] = ''
            #koord[0..anfang_koord] = ''
            ende_n = koord.index('_N_') #Ende der N-Koordinaten
            n = koord[anfang_n..ende_n-1]
            anfang_e = ende_n + 3
            e = koord[anfang_e..ende_e-1]
            n_array.push n
            e_array.push e
        else
            n_array.push 'nope'
            e_array.push 'nope'
        end
    end


    CSV.open('Bad Kreuznach/' + stadtteil + '.csv', 'a') do |csv|
        #csv << ['bezeichnung', 'lage', 'baujahr', 'beschreibung']
        bezeichnungen_array.each_with_index do |vitamin, index|
            csv << [bezeichnungen_array[index], lage_array[index], stadtteil,  baujahr_array[index], beschreibung_array[index], bild_link_array[index],  n_array[index], e_array[index]]
        end
    end

end