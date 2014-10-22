$(document).on 'ready page:change', ->
	opts = {
		container: 'mdeditor'
		basePath: 'http://localhost:3000'
		textarea: 'resource-description'
		theme: {
	    base: '/assets/editortheme/base/epiceditor.css'
	    preview: '/assets/editortheme/editor/epic-light.css'
	    editor: '/assets/editortheme/preview/github.css'
	  }
	}
	
	editor = new EpicEditor(opts).load()