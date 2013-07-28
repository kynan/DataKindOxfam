'use strict';

angular.module('angularApp', []);

function MainController($scope, $http){
  //load a map centred on Kenya
	var map = L.map('map').setView([-0.197754,38.144531], 6);

	var cloudmade = L.tileLayer('http://{s}.tile.cloudmade.com/{key}/{styleId}/256/{z}/{x}/{y}.png', {
		attribution: 'Map data &copy; 2011 OpenStreetMap contributors, Imagery &copy; 2011 CloudMade',
		key: 'BC9A493B41014CAABB98F0471D759707',
		styleId: 22677
	}).addTo(map);

	// control that shows state info on hover
	var info = L.control();

	info.onAdd = function (map) {
		this._div = L.DomUtil.create('div', 'info');
		this.update();
		return this._div;
	};

	info.update = function (props) {
		this._div.innerHTML = '<h4>Food Price</h4>' +  (props ?
			'<b>' + props.location + '</b><br />' + props.price + ' $'
			: 'Hover over a district');
	};

	info.addTo(map);

	// simple colour map
  // TODO: cleander with d3 scale
	function getColor(d) {
		return d > 1000 ? '#800026' :
		       d > 500  ? '#BD0026' :
		       d > 200  ? '#E31A1C' :
		       d > 100  ? '#FC4E2A' :
		       d > 50   ? '#FD8D3C' :
		       d > 20   ? '#FEB24C' :
		       d > 10   ? '#FED976' :
		                  '#FFEDA0';
	}

	function style(feature) {
		return {
			weight: 2,
			opacity: 1,
			color: 'white',
			dashArray: '3',
			fillOpacity: 0.7,
            //TODO use the const code for now
			fillColor: getColor(feature.properties.CONST_CODE)
		};
	}

	function highlightFeature(e) {
		var layer = e.target;

		layer.setStyle({
			weight: 5,
			color: '#666',
			dashArray: '',
			fillOpacity: 0.7
		});

		if (!L.Browser.ie && !L.Browser.opera) {
			layer.bringToFront();
		}

		info.update(layer.feature.properties);
	}

	var geojson;

	function resetHighlight(e) {
		geojson.resetStyle(e.target);
		info.update();
	}

	function zoomToFeature(e) {
		map.fitBounds(e.target.getBounds());
	}

	function onEachFeature(feature, layer) {
		layer.on({
			mouseover: highlightFeature,
			mouseout: resetHighlight,
			click: zoomToFeature
		});
	}

  $http.get("data/kenyacounties.geojson").success(function(json) {
       geojson = L.geoJson(json, {
      style: style,
      onEachFeature: onEachFeature
    }).addTo(map);
  });

	map.attributionControl.addAttribution('Oxfam Kenya Food Prices</a>');

	var legend = L.control({position: 'bottomright'});

	legend.onAdd = function (map) {

		var div = L.DomUtil.create('div', 'info legend'),
			grades = [0, 10, 20, 50, 100, 200, 500, 1000],
			labels = [],
			from, to;

		for (var i = 0; i < grades.length; i++) {
			from = grades[i];
			to = grades[i + 1];

			labels.push(
				'<i style="background:' + getColor(from + 1) + '"></i> ' +
				from + (to ? '&ndash;' + to : '+'));
		}

		div.innerHTML = labels.join('<br>');
		return div;
	};

	legend.addTo(map);
}
