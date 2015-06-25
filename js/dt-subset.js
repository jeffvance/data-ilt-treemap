/* DataTables js file shared by all dt-* html files. The JS global variable
   "DT_JSON_FILE" must be set to the relative pathname of the subset_... json
   file before sourcing this file.
*/
$(document).ready(function() {
   $('#main-tbl').dataTable( {
      "ajax": {
         "url": DT_JSON_FILE,
         "dataSrc": ""
      },

      "columns": [ //json key names, case-sensitive (no dashes)
         { "data": "Name" },
         { "data": "DBaaS" },
         { "data": "License" },
         { "data": "Website" },
         { "data": "Details" },
         { "data": "Type" },
         { "data": "Score" }
      ],

      "columnDefs": [
         {
           "targets": "url-content", //classname
           "render": function(data,type,row,meta) {
                if (data.length == 0) return data;
                if (! data.startsWith('http')) data='http://'+data;
                var name=data.split('/').pop(); //last word if '/' in url
                return '<a href="'+data+'"\>'+name+'</a\>';
           }
         }],

      "lengthMenu": [[-1, 10, 20, 50, 100], ["All", 10, 20, 50, 100]]
    
    });
});
