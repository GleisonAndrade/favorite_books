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

		params_ignore_list.forEach(e => delete inputHash[e]);

		for (var key in inputHash) {
			$("<input />").attr("type", "hidden")
					.attr("name", key)
					.attr("value", inputHash[key])
					.appendTo(form_id);
		}
	}

	var timeout = null;	

	window.submit_form_ajax_input_select = function(form_id, input_id) {
		$('#' + input_id).on('change', function() {
			var inputs_hash = getInputs('#' + form_id);
			var params_ignore_list = Object.keys(inputs_hash);
			params_ignore_list.push('page');
			var params = getParameters();

			update_form_fields('#' + form_id, params, params_ignore_list);

			var elem = document.getElementById(form_id);
			$.rails.fire(elem, 'submit');
		});
	}

	function submit_search(form_id, input_id) {
		var inputs_hash = getInputs('#' + form_id);
		var params_ignore_list = Object.keys(inputs_hash);
		params_ignore_list.push('page');
		var params = getParameters();

		update_form_fields('#' + form_id, params, params_ignore_list);

		var elem = document.getElementById(form_id);
		$.rails.fire(elem, 'submit');
	}

	window.submit_form_ajax_input_text = function(form_id, input_id) {
		$('#' + input_id).on('keydown', function() {
			if (this.value.length > 3) {
				if (timeout) {  
					clearTimeout(timeout);
				}
				timeout = setTimeout(function() {
					submit_search(form_id, input_id);
				}, 500);
			}
		});		
	}

	// temporary

	submit_form_ajax_input_select('form-books-order', 'order_by');
	submit_form_ajax_input_text('form-books-filter', 'contains_text');
	submit_form_ajax_input_text('form-books-filter', 'with_author');

});
