var express = require('express');
var router = express.Router();
var gen = require('../generate.js');

function S4() {
    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
};

// Generate a pseudo-GUID by concatenating random hexadecimal.
function guid() {
    return (S4()+S4()+S4()+S4());
};

router.get('/', function(req, res) {
  res.send("Hello");
});

router.get('/new/', function(req,res) {
    var area = gen.generate();
    res.send(JSON.stringify(area));
});

router.get('/area/:id', function(req,res) {
    var id = req.params.id;
    res.send("got "+id);
});

module.exports = router;
