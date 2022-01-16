'use strict';

$(window).on('load', function(){
	/* ===== Enable Bootstrap Popover (on element  ====== */
	var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-toggle="popover"]'))
	var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
		return new bootstrap.Popover(popoverTriggerEl)
	})

	/* ==== Enable Bootstrap Alert ====== */
	var alertList = document.querySelectorAll('.alert')
	alertList.forEach(function (alert) {
		new bootstrap.Alert(alert)
	});

	/* ===== Responsive Sidepanel ====== */
	const sidePanelToggler = document.getElementById('sidepanel-toggler'); 
	const sidePanel = document.getElementById('app-sidepanel');  
	const sidePanelDrop = document.getElementById('sidepanel-drop'); 
	const sidePanelClose = document.getElementById('sidepanel-close'); 

	window.addEventListener('load', function(){
		responsiveSidePanel(); 
	});

	window.addEventListener('resize', function(){
		responsiveSidePanel(); 
	});


	function responsiveSidePanel() {
		let w = window.innerWidth;
		if(w >= 1200) {
			// if larger 
			sidePanel.classList.remove('sidepanel-hidden');
			sidePanel.classList.add('sidepanel-visible');
			
		} else {
			// if smaller
			sidePanel.classList.remove('sidepanel-visible');
			sidePanel.classList.add('sidepanel-hidden');
		}
	};

	if(sidePanelToggler){
		sidePanelToggler.addEventListener('click', () => {
			if (sidePanel.classList.contains('sidepanel-visible')) {
				sidePanel.classList.remove('sidepanel-visible');
				sidePanel.classList.add('sidepanel-hidden');
				
			} else {
				sidePanel.classList.remove('sidepanel-hidden');
				sidePanel.classList.add('sidepanel-visible');
			}
		});

		sidePanelClose.addEventListener('click', (e) => {
			e.preventDefault();
			sidePanelToggler.click();
		});
	
		sidePanelDrop.addEventListener('click', (e) => {
			sidePanelToggler.click();
		});
	}

	/* ====== Mobile search ======= */
	const searchMobileTrigger = document.querySelector('.search-mobile-trigger');
	const searchBox = document.querySelector('.app-search-box');

	if (searchMobileTrigger){
		searchMobileTrigger.addEventListener('click', () => {
			searchBox.classList.toggle('is-visible');
			
			let searchMobileTriggerIcon = document.querySelector('.search-mobile-trigger-icon');
			
			if(searchMobileTriggerIcon.classList.contains('fa-search')) {
				searchMobileTriggerIcon.classList.remove('fa-search');
				searchMobileTriggerIcon.classList.add('fa-times');
			} else {
				searchMobileTriggerIcon.classList.remove('fa-times');
				searchMobileTriggerIcon.classList.add('fa-search');
			}
		});
	}

	/* Functions */

	window.getParameters = function() {
		var searchString = window.location.search.substring(1),
		params = searchString.split("&"),
		fields_hash = {};

		if (searchString == "") return {};
		for (var i = 0; i < params.length; i++) {
			var val = params[i].split("=");
			fields_hash[unescape(val[0])] = unescape(val[1]);
		}

		return fields_hash;
	}

	window.getInputs = function(form_id) {
		var fields = $(form_id).find( ":input" ).serializeArray();
		var fields_hash = {};

		for (var index in fields) {
			fields_hash[unescape(fields[index].name)] = unescape(fields[index].value);
		}

		return fields_hash
	}

	window.update_form_fields = function(form_id, inputHash, params_ignore_list) {
		console.log(params_ignore_list)

		params_ignore_list.forEach(e => delete inputHash[e]);

		console.log(inputHash)

		for (var key in inputHash) {
			$("<input />").attr("type", "hidden")
					.attr("name", key)
					.attr("value", inputHash[key])
					.appendTo(form_id);
		}
	}

});
