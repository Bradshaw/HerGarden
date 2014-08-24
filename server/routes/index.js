var express = require('express');
var router = express.Router();
var gen = require('../generate.js');

function S4() {
    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
}

// Generate a pseudo-GUID by concatenating random hexadecimal.
function guid() {
    return (S4()+S4()+S4()+S4());
}

router.get('/', function(req, res) {
  res.send("Hello");
});

router.get('/new/', function(req,res) {
    var area = gen.generate();
    var db = req.db;
    var worlds = db.get("worlds");
    worlds.insert(area, function(err, doc){
        console.log(doc._id);
        res.send(""+doc._id);
    });
});

router.get('/move/:wid/:oid/:xpos/:ypos', function(req, res){
    var wid = req.params.wid;
    var oid = req.params.oid;
    var x = req.params.xpos/10000;
    var y = req.params.ypos/10000;
    var db = req.db;
    var worlds = db.get("worlds");
    worlds.findById(wid, function(err, doc) {
        var  movables = doc.items.movables;
        for (it in movables){
            var ait = movables[it];
            if (ait.hasOwnProperty("id") && ait.id == oid)
            {
                ait.x = x;
                ait.y = y;
                worlds.updateById(wid, doc,function(){
                    res.send("dune");
                });
                return;
            }
        }
    });
});

router.get('/area/:id', function(req,res) {
    var id = req.params.id;
    var db = req.db;
    var worlds = db.get("worlds");
    worlds.findById(id, function(err, doc){
        res.send(JSON.stringify(doc)); 
    });
});

router.get('/visit/:notid', function(req, res){
    var id = req.params.notid;
    var db = req.db;
    var worlds = db.get("worlds");
    worlds.find({}, '-items -area -colors', function(err, docs){
        var rid = Math.floor(Math.random()*docs.length);
        while (docs[rid]._id==id){
            rid = Math.floor(Math.random()*docs.length);
        }
        res.send(""+docs[rid]._id); 
    });
});

module.exports = router;
