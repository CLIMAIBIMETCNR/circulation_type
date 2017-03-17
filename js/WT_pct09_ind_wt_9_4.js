
function initDemoMap(){

   
        var DarkMatter = L.tileLayer('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', {
	attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
	subdomains: 'abcd',
	maxZoom: 19
}
    );

    var baseLayers = {
         "Grey Canvas": DarkMatter
    };

    var map = L.map('map', {
        layers: [ DarkMatter ]
    });

    var layerControl = L.control.layers(baseLayers);
    layerControl.addTo(map);
    map.setView([43.00, 14.44], 3);

    return {
        map: map,
        layerControl: layerControl
    };
}


// demo map
var mapStuff = initDemoMap();
var map = mapStuff.map;
var layerControl = mapStuff.layerControl;

var handleError = function(err){
    console.log('handleError...');
    console.log(err);
};

WindJSLeaflet.init({
    localMode: true,
    source:"data/WT_pct09_ind_wt_9_4.json",
    argMode: false,  
    sourcedata:null,
    caption:"WT_pct09_ind_wt_9_4",
    age:100,
    width:0.8,
    mintk:-20,
    maxtk:32,		
    map: map,
    layerControl: layerControl,
    useNearest: false,
    timeISO: null,
    nearestDaysLimit: 7,
    displayValues: true,
	displayOptions: {
		displayPosition: 'bottomleft',
		displayEmptyString: 'No wind data'
	},
	overlayName: 'wind700hpa',
	errorCallback: handleError
});
