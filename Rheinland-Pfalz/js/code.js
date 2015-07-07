var map;
var ajaxRequest;
var plotlist;
var plotlayers=[];
var popup = L.popup();
var pleiades;
var marker;



function markerClick (e) {
    //console.log('clicked:' + e.latlng);
    map.setView(e.latlng, 15, {animate: true, duration: 1});
}

function geoJSONMarker (data) {
    var geojsonMarkerOptions = {
    radius: 8,
    fillColor: "beige",
    color: "#000",
    weight: 3,
    opacity: 1,
    fillOpacity: 0.8
    };
    function onEachFeature(feature, layer) {
        // does this feature have a property named Description?
        if (feature.properties.field_1) {
            marker = layer.bindPopup('<b>' + feature.properties.field_1 + '</b><br/><br/>' + feature.properties.field_5);
            //marker.on('click', function (e) {markerClick(e)});
        }
    };
    L.geoJson(data, {
        style: function (feature) {
            switch (feature.properties.typ) {
                case 'sakralbau': return {color: 'red'};
                case 'burg': return {color: 'green'};
                case 'sonstiges': return {color: 'black'};
            }
        },
        pointToLayer: function (feature, latlng) {
            return L.circleMarker(latlng, geojsonMarkerOptions);
        },
        onEachFeature: onEachFeature
    }).addTo(map);
}
// parse geoJSON_points
//var kreise = ['Donnersbergkreis', 'Alzey-Worms', 'Bad Dürkheim', 'Germersheim', 'Mainz-Bingen', 'Rhein-Pfalz', 'Südliche Weinstraße', 'Südwestpfalz', 'Vulkaneifel', 'Bad_Kreuznach_Kreis', 'Neuwied_Kreis', 'Bernkastel-Wittlich_Kreis', 'Birkenfeld_Kreis'];
var kreise = ['gesamt_06082014'];
function parseJSON_points() {
    for (var i = 0; i<kreise.length; i++) {
        $.ajax({
            url: 'src/ergebnisse/' + kreise[i] + '.geojson',
            dataType: 'json',
            async: false,
            success: function(data) {
                geoJSONMarker(data);
            }
        });
    }
}

/*
function parseJSON_poly() {
    $.getJSON("src/Mainz/Mainz_geo_poly.geojson", function (data) {
        var myStyle = {
    "color": "black",
    "fill-color": "beige",
    "weight": 3,
    "opacity": 0.65
};

L.geoJson(data, {
    style: myStyle
}).addTo(map);
    });
}*/

function initmap() {
	// set up the map
	map = new L.Map('map');

	// create the tile layer with correct attribution
	var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
	var osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
	var osm = new L.TileLayer(osmUrl, {minZoom: 2, maxZoom: 32, attribution: osmAttrib});		

	// start the map in Lautere
    map.setView([49.443743, 7.768952], 13);
	map.addLayer(osm);
    
    //parseJSON_poly();
    parseJSON_points();    // pack den Pleiades-Layer drauf
    
    
    /*
    // Panoramio Layer
    var panoramio = new L.Panoramio({maxLoad: 50, maxTotal: 250});
    map.addLayer(panoramio);
    */
    
    
    
}

    